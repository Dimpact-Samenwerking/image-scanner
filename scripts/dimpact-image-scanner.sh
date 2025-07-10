#!/usr/bin/env bash

# Local Container Image Security Scanner
# This script provides the same functionality as the GitHub workflow for local execution
# Uses containerized scanning tools for maximum portability

set -euo pipefail

# Source utility functions
source "$(dirname "$0")/dimpact-scanner-utils.sh"
# Source EPSS and SARIF enrichment functions
source "$(dirname "$0")/dimpact-scanner-epss.sh"
# Source image discovery and YAML parsing functions
source "$(dirname "$0")/dimpact-scanner-discovery.sh"

# Load suppressed CVEs from the suppressions file (default: cve-suppressions.md)
CVE_SUPPRESSIONS_FILE="${CVE_SUPPRESSIONS_FILE:-cve-suppressions.md}"
load_cve_suppressions

# Ensure we're using bash
if [ -z "${BASH_VERSION:-}" ]; then
    echo "Error: This script requires bash" >&2
    exit 1
fi

# Check bash version (need 4.0+ for associative arrays and other features)
if (( BASH_VERSINFO[0] < 4 )); then
    echo "Warning: This script works best with bash 4.0 or later" >&2
    echo "Current version: $BASH_VERSION" >&2
fi

# Colors for output (only use colors if not in CI environment)
if [ -z "${CI:-}" ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

# Default configuration
SEVERITY_THRESHOLD="${SEVERITY_THRESHOLD:-MEDIUM}"
# Create date-prefixed output directory (YYMMDD format)
DEFAULT_DATE_PREFIX=$(date +%y%m%d)
OUTPUT_DIR="${OUTPUT_DIR:-./dimpact-scan-results/${DEFAULT_DATE_PREFIX}}"
HELM_CHARTS_DIR="${HELM_CHARTS_DIR:-./helm-charts}"
LIST_IMAGES_ONLY=false
PERFORMANCE_MODE="${PERFORMANCE_MODE:-normal}"  # normal, high, max

# Container image versions
TRIVY_VERSION="${TRIVY_VERSION:-aquasec/trivy:latest}"
YQ_VERSION="${YQ_VERSION:-mikefarah/yq:latest}"

# Declare arrays for discovered images and suppressed CVEs
declare -a discovered_images
declare -a suppressed_cves

# Declare associative array for image-to-charts mapping (requires bash 4+)
if (( BASH_VERSINFO[0] >= 4 )); then
    declare -A image_to_charts
fi

# Argument parsing for --image
USER_IMAGE=""
TESTMODE=false
USE_DISCOVERED=false
QUICKMODE=false
STRICT_MODE=false
UPDATE_DATABASES=false
CLEAN_CACHE=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --image)
            USER_IMAGE="$2"
            shift 2
            ;;
        --severity)
            SEVERITY_THRESHOLD="$2"
            shift 2
            ;;
        --output-dir)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        --list-images)
            LIST_IMAGES_ONLY=true
            shift
            ;;
        --performance)
            PERFORMANCE_MODE="$2"
            shift 2
            ;;
        --testmode)
            TESTMODE=true
            shift
            ;;
        --use-discovered)
            USE_DISCOVERED=true
            shift
            ;;
        --quickmode)
            QUICKMODE=true
            shift
            ;;
        --strict)
            STRICT_MODE=true
            shift
            ;;
        --update-db)
            UPDATE_DATABASES=true
            shift
            ;;
        --clean-cache)
            CLEAN_CACHE=true
            shift
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --image IMAGE            Scan a specific container image"
            echo "  --severity LEVEL         Set severity threshold (default: MEDIUM)"
            echo "  --output-dir DIR         Set output directory (default: ./dimpact-scan-results/YYMMDD)"
            echo "  --list-images            Only list images from discovered.yaml (no scan)"
            echo "  --performance MODE       Set performance mode: normal, high, max (default: normal)"
            echo "  --testmode               Run in test mode (scan only first 3 images)"
            echo "  --use-discovered         Use discovered.yaml file (required, must be generated externally)"
            echo "  --quickmode              Reuse existing scan data from docs/data/ directory"
            echo "  --strict                 Enable strict mode (fail fast on any error)"
            echo "  --update-db              Force update vulnerability databases"
            echo "  --clean-cache            Clean up all scanner caches and temporary files"
            echo "  --help                   Show this help message"
            echo ""
            echo "Required input: discovered.yaml must be present in the working directory."
            echo "This file should be generated externally (e.g., by running the image discovery script)."
            echo "This script does NOT perform image discovery or report generation."
            echo ""
            echo "Examples:"
            echo "  $0 --use-discovered                # Scan all images listed in discovered.yaml"
            echo "  $0 --image nginx:latest            # Scan a specific image"
            echo "  $0 --quickmode --use-discovered    # Reuse existing data where possible"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Function to get system resources
get_system_resources() {
    local cpu_cores=$(nproc 2>/dev/null || echo 4)
    local total_mem_gb=$(free -g 2>/dev/null | awk '/^Mem:/{print $2}' || echo 8)
    if [ -f "/sys/fs/cgroup/cpu.max" ]; then
        local cpu_quota=$(cat /sys/fs/cgroup/cpu.max | cut -d' ' -f1)
        if [ "$cpu_quota" != "max" ]; then
            cpu_cores=$((cpu_quota / 100000))
        fi
    fi
    if [ -f "/sys/fs/cgroup/memory.max" ]; then
        local mem_limit=$(cat /sys/fs/cgroup/memory.max)
        if [ "$mem_limit" != "max" ]; then
            total_mem_gb=$((mem_limit / 1024 / 1024 / 1024))
        fi
    fi
    echo "$cpu_cores:$total_mem_gb"
}

# Function to configure performance settings
configure_performance() {
    local mode="$1"
    local resources=($(get_system_resources | tr ':' ' '))
    local cpu_cores="${resources[0]}"
    local total_mem_gb="${resources[1]}"
    
    # Debug output for resource detection
    
    case "$mode" in
        "max")
            # Use all available resources for single container
            DOCKER_MEMORY_LIMIT="${total_mem_gb}G"
            DOCKER_CPU_LIMIT=$cpu_cores
            ;;
        "high")
            # Use 75% of available resources for single container
            DOCKER_MEMORY_LIMIT="$((total_mem_gb * 3 / 4))G"
            DOCKER_CPU_LIMIT=$((cpu_cores * 3 / 4))
            ;;
        "normal"|*)
            # Use 50% of available resources for single container
            DOCKER_MEMORY_LIMIT="$((total_mem_gb / 2))G"
            DOCKER_CPU_LIMIT=$((cpu_cores / 2))
            ;;
    esac
    
    # Ensure minimum values
    DOCKER_CPU_LIMIT=$((DOCKER_CPU_LIMIT > 1 ? DOCKER_CPU_LIMIT : 1))
    
    # Ensure memory limit has a minimum value and proper format
    if [[ "$DOCKER_MEMORY_LIMIT" == "0G" || -z "$DOCKER_MEMORY_LIMIT" || "$DOCKER_MEMORY_LIMIT" == "G" ]]; then
        DOCKER_MEMORY_LIMIT="8G"  # Default to 8GB if calculation fails
        print_warning "Memory calculation failed, using default 4GB limit"
    fi
    
    print_status "Performance mode: $mode"
    print_status "CPU cores available: $cpu_cores"
    print_status "Total memory available: ${total_mem_gb}GB"
    print_status "Sequential scanning mode enabled"
    print_status "Docker resource limits per container:"
    print_status "  • CPU: $DOCKER_CPU_LIMIT"
    print_status "  • Memory: $DOCKER_MEMORY_LIMIT"
}

# Function to get and display image age
get_image_age() {
    local image="$1"
    ensure_docker_env
    local created_date=$(docker inspect "$image" --format='{{.Created}}' 2>/dev/null)
    if [ -z "$created_date" ]; then
        print_status "📅 Image age: Unable to determine"
        return 1
    fi
    local current_epoch=$(date +%s)
    # Remove nanoseconds and Z for GNU date compatibility
    local created_date_short=$(echo "$created_date" | sed -E 's/\.[0-9]+Z$//')
    
    # Handle both GNU date (Linux) and BSD date (macOS)
    local image_epoch
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS uses BSD date - different syntax
        image_epoch=$(date -j -f "%Y-%m-%dT%H:%M:%S" "$created_date_short" "+%s" 2>/dev/null)
    else
        # Linux uses GNU date
        image_epoch=$(date -d "$created_date_short" +%s 2>/dev/null)
    fi
    
    if [ -z "$image_epoch" ]; then
        print_status "📅 Image age: Unable to parse creation date"
        return 1
    fi
    # Calculate age in seconds
    local age_seconds=$((current_epoch - image_epoch))
    
    # Convert to human-readable format
    local age_days=$((age_seconds / 86400))
    local age_hours=$(((age_seconds % 86400) / 3600))
    
    # Format age display - always show days only
    local age_text=""
    local status_emoji=""
    
    if [ $age_days -gt 365 ]; then
        age_text="${age_days} days"
        status_emoji="🔴"
    elif [ $age_days -gt 180 ]; then
        age_text="${age_days} days"
        status_emoji="🟠"
    elif [ $age_days -gt 90 ]; then
        age_text="${age_days} days"
        status_emoji="🟡"
    elif [ $age_days -gt 30 ]; then
        age_text="${age_days} days"
        status_emoji="🟢"
    elif [ $age_days -gt 0 ]; then
        age_text="${age_days} days"
        status_emoji="✅"
    elif [ $age_hours -gt 0 ]; then
        local age_minutes=$(((age_seconds % 3600) / 60))
        age_text="${age_hours} hour(s), ${age_minutes} minute(s)"
        status_emoji="✅"
    else
        local age_minutes=$((age_seconds / 60))
        age_text="${age_minutes} minute(s)"
        status_emoji="✅"
    fi
    
    # Display age information
    print_status "📅 Image created: $(echo "$created_date" | sed 's/T/ /' | sed 's/Z$//' | cut -d'.' -f1) UTC"
    print_status "⏰ Image age: ${status_emoji} ${age_text}"
    
    # Additional age-based recommendations
    if [ $age_days -gt 365 ]; then
        print_warning "   Very old image (>1 year) - strongly consider updating"
    elif [ $age_days -gt 180 ]; then
        print_warning "   Old image (>6 months) - review for updates"
    elif [ $age_days -gt 90 ]; then
        print_status "   Moderately old image (>3 months)"
    fi
    
    # Return age data for SARIF enhancement (global variables for post-processing)
    export IMAGE_CREATED_DATE="$created_date"
    export IMAGE_AGE_DAYS="$age_days"
    export IMAGE_AGE_SECONDS="$age_seconds"
    export IMAGE_AGE_TEXT="$age_text"
    export IMAGE_AGE_STATUS_EMOJI="$status_emoji"
}

# Function to enhance SARIF file with image age metadata
enhance_sarif_with_age() {
    local sarif_file="$1"
    local image="$2"
    local temp_sarif="${sarif_file}.temp"  # Ensure this is always defined at the top
    
    if [ ! -f "$sarif_file" ] || [ ! -s "$sarif_file" ]; then
        print_warning "SARIF file not found or empty: $sarif_file"
        return 1
    fi
    
    # Check if jq is available for JSON processing
    if ! command_exists jq; then
        print_warning "jq not available - cannot enhance SARIF with age metadata"
        return 1
    fi
    
    # Create backup of original SARIF file
    cp "$sarif_file" "${sarif_file}.backup"
    # Debug info before cp -a temp to target
    echo "[DEBUG] whoami: $(whoami)" >&2
    echo "[DEBUG] id: $(id)" >&2
    echo "[DEBUG] umask: $(umask)" >&2
    echo "[DEBUG] df -h .: $(df -h . | tail -1)" >&2
    echo "[DEBUG] ls -ld target dir: $(ls -ld $(dirname "$sarif_file"))" >&2
    echo "[DEBUG] ls -l target file: $(ls -l "$sarif_file" 2>/dev/null || echo 'not exist')" >&2
    echo "[DEBUG] ls -l temp file: $(ls -l "$temp_sarif" 2>/dev/null || echo 'not exist')" >&2
    
    # Get current date for scan timestamp
    local scan_timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    # Determine age status category based on days
    local age_status="unknown"
    if [ -n "$IMAGE_AGE_DAYS" ]; then
        if [ "$IMAGE_AGE_DAYS" -gt 365 ]; then
            age_status="very_old"
        elif [ "$IMAGE_AGE_DAYS" -gt 180 ]; then
            age_status="old"
        elif [ "$IMAGE_AGE_DAYS" -gt 90 ]; then
            age_status="moderate"
        elif [ "$IMAGE_AGE_DAYS" -gt 30 ]; then
            age_status="recent"
        else
            age_status="very_recent"
        fi
    fi
    
    # Enhance the SARIF file with age metadata in properties section
    jq --arg created_date "${IMAGE_CREATED_DATE:-unknown}" \
       --arg age_days "${IMAGE_AGE_DAYS:-0}" \
       --arg age_seconds "${IMAGE_AGE_SECONDS:-0}" \
       --arg age_text "${IMAGE_AGE_TEXT:-unknown}" \
       --arg age_status "$age_status" \
       --arg scan_timestamp "$scan_timestamp" \
       '.runs[0].properties += {
         "imageCreatedDate": $created_date,
         "imageAgeDays": ($age_days | tonumber),
         "imageAgeSeconds": ($age_seconds | tonumber),
         "imageAgeText": $age_text,
         "imageAgeStatus": $age_status,
         "scanTimestamp": $scan_timestamp,
         "ageMetadataVersion": "1.0"
       }' "$sarif_file" > "$temp_sarif" 2>/dev/null
    
    # Check if jq processing was successful
    if [ $? -eq 0 ] && [ -s "$temp_sarif" ]; then
        # Validate that the enhanced file is valid JSON
        if jq empty "$temp_sarif" 2>/dev/null; then
            cp -a "$temp_sarif" "$sarif_file"
            cp_exit=$?
            if [ $cp_exit -ne 0 ]; then
                echo "[DEBUG] cp -a failed with exit code $cp_exit" >&2
                echo "[DEBUG] whoami: $(whoami)" >&2
                echo "[DEBUG] id: $(id)" >&2
                echo "[DEBUG] umask: $(umask)" >&2
                echo "[DEBUG] df -h .: $(df -h . | tail -1)" >&2
                echo "[DEBUG] ls -ld target dir: $(ls -ld $(dirname "$sarif_file"))" >&2
                echo "[DEBUG] ls -l target file: $(ls -l "$sarif_file" 2>/dev/null || echo 'not exist')" >&2
                echo "[DEBUG] ls -l temp file: $(ls -l "$temp_sarif" 2>/dev/null || echo 'not exist')" >&2
            fi
            print_status "✅ Enhanced SARIF with image age metadata"
            

        else
            print_warning "Enhanced SARIF file is invalid JSON - reverting to original"
            rm -f "$temp_sarif"
            return 1
        fi
    else
        print_warning "Failed to enhance SARIF with age metadata"
        rm -f "$temp_sarif"
        return 1
    fi
    
    # Clean up backup file if enhancement was successful
    rm -f "${sarif_file}.backup"
}

# Function to enhance SARIF file with charts metadata
enhance_sarif_with_charts() {
    local sarif_file="$1"
    local image="$2"
    local temp_sarif="${sarif_file}.temp"  # Ensure this is always defined at the top
    
    if [ ! -f "$sarif_file" ] || [ ! -s "$sarif_file" ]; then
        print_warning "SARIF file not found or empty: $sarif_file"
        return 1
    fi
    
    # Check if jq is available for JSON processing
    if ! command_exists jq; then
        print_warning "jq not available - cannot enhance SARIF with charts metadata"
        return 1
    fi
    
    # Check if we have bash 4+ and charts information available
    if (( BASH_VERSINFO[0] < 4 )); then
        print_status "Bash < 4.0 detected - skipping charts enhancement"
        return 0
    fi
    
    # Get charts information for this image
    local charts_list="${image_to_charts[$image]:-}"
    if [[ -z "$charts_list" ]]; then
        print_status "No charts information available for $image - skipping charts enhancement"
        return 0
    fi
    
    print_status "🔧 Enhancing SARIF with Helm charts information..."
    
    # Create backup of original SARIF file
    cp "$sarif_file" "${sarif_file}.backup"
    # Debug info before cp -a temp to target
    echo "[DEBUG] whoami: $(whoami)" >&2
    echo "[DEBUG] id: $(id)" >&2
    echo "[DEBUG] umask: $(umask)" >&2
    echo "[DEBUG] df -h .: $(df -h . | tail -1)" >&2
    echo "[DEBUG] ls -ld target dir: $(ls -ld $(dirname "$sarif_file"))" >&2
    echo "[DEBUG] ls -l target file: $(ls -l "$sarif_file" 2>/dev/null || echo 'not exist')" >&2
    echo "[DEBUG] ls -l temp file: $(ls -l "$temp_sarif" 2>/dev/null || echo 'not exist')" >&2
    
    # Convert comma-separated charts list to JSON array
    local charts_json_array="[]"
    if [[ -n "$charts_list" ]]; then
        # Split charts by comma and create JSON array
        local charts_array=""
        IFS=',' read -ra chart_names <<< "$charts_list"
        for chart in "${chart_names[@]}"; do
            chart=$(echo "$chart" | xargs)  # Trim whitespace
            if [[ -n "$chart" ]]; then
                if [[ -z "$charts_array" ]]; then
                    charts_array="\"$chart\""
                else
                    charts_array="$charts_array, \"$chart\""
                fi
            fi
        done
        if [[ -n "$charts_array" ]]; then
            charts_json_array="[$charts_array]"
        fi
    fi
    
    # Get current date for enhancement timestamp
    local enhancement_timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    # Create temporary file for enhanced SARIF
    jq --argjson charts_array "$charts_json_array" \
       --arg charts_count "${#chart_names[@]}" \
       --arg enhancement_timestamp "$enhancement_timestamp" \
       '.runs[0].properties += {
         "helmCharts": $charts_array,
         "helmChartsCount": ($charts_count | tonumber),
         "helmChartsEnhanced": true,
         "helmChartsEnhancementDate": $enhancement_timestamp,
         "chartsMetadataVersion": "1.0"
       }' "$sarif_file" > "$temp_sarif" 2>/dev/null
    
    # Check if jq processing was successful
    if [ $? -eq 0 ] && [ -s "$temp_sarif" ]; then
        # Validate that the enhanced file is valid JSON
        if jq empty "$temp_sarif" 2>/dev/null; then
            cp -a "$temp_sarif" "$sarif_file"
            cp_exit=$?
            if [ $cp_exit -ne 0 ]; then
                echo "[DEBUG] cp -a failed with exit code $cp_exit" >&2
                echo "[DEBUG] whoami: $(whoami)" >&2
                echo "[DEBUG] id: $(id)" >&2
                echo "[DEBUG] umask: $(umask)" >&2
                echo "[DEBUG] df -h .: $(df -h . | tail -1)" >&2
                echo "[DEBUG] ls -ld target dir: $(ls -ld $(dirname "$sarif_file"))" >&2
                echo "[DEBUG] ls -l target file: $(ls -l "$sarif_file" 2>/dev/null || echo 'not exist')" >&2
                echo "[DEBUG] ls -l temp file: $(ls -l "$temp_sarif" 2>/dev/null || echo 'not exist')" >&2
            fi
            print_status "✅ Enhanced SARIF with Helm charts metadata"
            

        else
            print_warning "Enhanced SARIF file is invalid JSON - reverting to original"
            rm -f "$temp_sarif"
            return 1
        fi
    else
        print_warning "Failed to enhance SARIF with charts metadata"
        rm -f "$temp_sarif"
        return 1
    fi
    
    # Clean up backup file if enhancement was successful
    rm -f "${sarif_file}.backup"
}

# Function to enhance SARIF file with suppressed CVE metadata
# Adds 'suppressed': true to results whose ruleId is in suppressed_cves
enhance_sarif_with_suppressions() {
    local sarif_file="$1"
    local suppressed_json
    suppressed_json=$(printf '%s\n' "${suppressed_cves[@]}" | jq -R . | jq -s .)
    local temp_sarif="${sarif_file}.temp"  # Ensure this is always defined at the top

    if [ ! -f "$sarif_file" ] || [ ! -s "$sarif_file" ]; then
        print_warning "SARIF file not found or empty: $sarif_file"
        return 1
    fi
    if ! command_exists jq; then
        print_warning "jq not available - cannot enhance SARIF with suppressions"
        return 1
    fi
    cp "$sarif_file" "${sarif_file}.backup"
    jq --argjson suppressed_cves "$suppressed_json" '
      .runs[0].results |= map(
        if (.ruleId | IN($suppressed_cves[]))
        then . + {suppressed: true}
        else .
        end
      )
    ' "$sarif_file" > "$temp_sarif" 2>/dev/null
    if [ $? -eq 0 ] && [ -s "$temp_sarif" ]; then
        if jq empty "$temp_sarif" 2>/dev/null; then
            cp -a "$temp_sarif" "$sarif_file"
            cp_exit=$?
            if [ $cp_exit -ne 0 ]; then
                echo "[DEBUG] cp -a failed with exit code $cp_exit" >&2
                echo "[DEBUG] whoami: $(whoami)" >&2
                echo "[DEBUG] id: $(id)" >&2
                echo "[DEBUG] umask: $(umask)" >&2
                echo "[DEBUG] df -h .: $(df -h . | tail -1)" >&2
                echo "[DEBUG] ls -ld target dir: $(ls -ld $(dirname "$sarif_file"))" >&2
                echo "[DEBUG] ls -l target file: $(ls -l "$sarif_file" 2>/dev/null || echo 'not exist')" >&2
                echo "[DEBUG] ls -l temp file: $(ls -l "$temp_sarif" 2>/dev/null || echo 'not exist')" >&2
            fi
            print_status "✅ Enhanced SARIF with suppressed CVE metadata"
        else
            print_warning "Enhanced SARIF file is invalid JSON - reverting to original"
            rm -f "$temp_sarif"
            return 1
        fi
    else
        print_warning "Failed to enhance SARIF with suppressed CVE metadata"
        rm -f "$temp_sarif"
        return 1
    fi
    rm -f "${sarif_file}.backup"
}

# Function to scan a single image
scan_image() {
    local image="$1"
    local safe_name=$(echo "$image" | sed 's/[^a-zA-Z0-9]/-/g')
    local image_dir="$OUTPUT_DIR/$safe_name"
    local abs_image_dir=$(get_absolute_path "$image_dir")
    
    print_status "🔍 Scanning image: $image"
    mkdir -p "$image_dir"
    
    ensure_docker_env
    if ! check_disk_space 3; then
        print_warning "Low disk space detected before scanning $image"
        print_status "Cleaning up temporary files..."
        cleanup_temp_dirs
        if ! check_disk_space 2; then
            print_error "Insufficient disk space to scan $image, skipping..."
            echo "SCAN_FAILED: $image - Insufficient disk space" >> "$OUTPUT_DIR/failed_scans.log"
            return 1
        fi
    fi
    print_status " Pulling image..."
    if ! docker pull --platform linux/amd64 "$image"; then
        print_error "Failed to pull image: $image"
        echo "SCAN_FAILED: $image - Failed to pull image" >> "$OUTPUT_DIR/failed_scans.log"
        return 1
    fi
    print_status "📋 Getting image metadata..."
    if ! get_image_age "$image"; then
        print_error "Failed to get image age for $image"
        echo "SCAN_FAILED: $image - Failed to get image age" >> "$OUTPUT_DIR/failed_scans.log"
        return 1
    fi
    print_status "🛡️ Running Trivy vulnerability scan (SARIF format)..."
    TRIVY_DB_PATH="$HOME/.cache/trivy/db/"
    if [ -d "$TRIVY_DB_PATH" ]; then
        TRIVY_SKIP_DB_UPDATE="--skip-db-update"
    else
        TRIVY_SKIP_DB_UPDATE=""
    fi
    local trivy_temp_dir="$abs_image_dir/trivy-temp"
    mkdir -p "$trivy_temp_dir"
    local temp_output="$trivy_temp_dir/trivy_output.log"
    docker run --rm --user $(id -u):$(id -g) --memory="$DOCKER_MEMORY_LIMIT" --cpus="$DOCKER_CPU_LIMIT" \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v "$abs_image_dir:/output" \
        -v "$HOME/.cache/trivy:/root/.cache/trivy" \
        -v "$trivy_temp_dir:/tmp" \
        -e TMPDIR=/tmp \
        "$TRIVY_VERSION" image \
        --format sarif \
        --output /output/trivy-results.sarif \
        --severity LOW,MEDIUM,HIGH,CRITICAL \
        --scanners vuln \
        --quiet \
        $TRIVY_SKIP_DB_UPDATE \
        "$image" > "$temp_output" 2>&1
    local trivy_exit=$?
    if [ $trivy_exit -ne 0 ]; then
        print_warning "Trivy scan failed for $image. See log below:"
        cat "$temp_output"
    fi
    rm -f "$temp_output"
    
    # Process SARIF results and show vulnerability summary
    if [ -f "$image_dir/trivy-results.sarif" ] && [ -s "$image_dir/trivy-results.sarif" ]; then
        print_success "✅ SARIF scan completed for $image"
        print_status "📄 SARIF output: $image_dir/trivy-results.sarif"
        
        # Enhance SARIF file with image age metadata
        enhance_sarif_with_age "$image_dir/trivy-results.sarif" "$image" || {
            print_error "[ACTION REQUIRED] Failed to enhance SARIF with age metadata for $image_dir/trivy-results.sarif.\n  - Check that jq is installed and the SARIF file is valid JSON.\n  - Try: sudo apt install jq\n  - If the SARIF file is missing or empty, check the scan output."
        }
        
        # Enhance SARIF file with Helm charts metadata
        enhance_sarif_with_charts "$image_dir/trivy-results.sarif" "$image" || {
            print_error "[ACTION REQUIRED] Failed to enhance SARIF with Helm charts metadata for $image_dir/trivy-results.sarif.\n  - Check that jq is installed and the SARIF file is valid JSON.\n  - If the SARIF file is missing or empty, check the scan output.\n  - If using bash < 4, charts enhancement is skipped."
        }
        # Enhance SARIF file with suppressed CVE metadata
        enhance_sarif_with_suppressions "$image_dir/trivy-results.sarif" || {
            print_error "[ACTION REQUIRED] Failed to enhance SARIF with suppressed CVE metadata for $image_dir/trivy-results.sarif.\n  - Check that jq is installed and the SARIF file is valid JSON.\n  - If the SARIF file is missing or empty, check the scan output."
        }
        
        # Fetch and enhance SARIF with EPSS exploitability scores
        fetch_epss_scores "$image_dir/trivy-results.sarif" || {
            print_error "[ACTION REQUIRED] Failed to fetch EPSS scores for $image_dir/trivy-results.sarif.\n  - Check network connectivity for EPSS data download.\n  - If jq is missing, install it: sudo apt install jq\n  - If no CVEs found, this may not be an error."
        }
        enhance_sarif_with_epss "$image_dir/trivy-results.sarif" || {
            print_error "[ACTION REQUIRED] Failed to enhance SARIF with EPSS data for $image_dir/trivy-results.sarif.\n  - Check that jq is installed and the SARIF and EPSS files are valid JSON.\n  - If the SARIF or EPSS file is missing or empty, check the scan and EPSS output."
        }
        
        # Show vulnerability summary from SARIF using actual CVE severity levels
        if command_exists jq; then
            # Optimized function to count all vulnerabilities by severity from SARIF rules
            count_all_severities() {
                local sarif_file="$1"
                
                # Use simple, reliable jq commands to count each severity from properties.tags
                local critical_count=$(jq -r '.runs[0].tool.driver.rules[] | select(.properties.tags[]? == "CRITICAL") | .id' "$sarif_file" 2>/dev/null | wc -l | tr -d ' ')
                local high_count=$(jq -r '.runs[0].tool.driver.rules[] | select(.properties.tags[]? == "HIGH") | .id' "$sarif_file" 2>/dev/null | wc -l | tr -d ' ')
                local medium_count=$(jq -r '.runs[0].tool.driver.rules[] | select(.properties.tags[]? == "MEDIUM") | .id' "$sarif_file" 2>/dev/null | wc -l | tr -d ' ')
                local low_count=$(jq -r '.runs[0].tool.driver.rules[] | select(.properties.tags[]? == "LOW") | .id' "$sarif_file" 2>/dev/null | wc -l | tr -d ' ')
                
                # Fallback to help text if no results from tags
                if [ "$critical_count" = "0" ] && [ "$high_count" = "0" ] && [ "$medium_count" = "0" ] && [ "$low_count" = "0" ]; then
                    critical_count=$(jq -r '.runs[0].tool.driver.rules[] | select(.help.text? | test("Severity: CRITICAL")) | .id' "$sarif_file" 2>/dev/null | wc -l | tr -d ' ')
                    high_count=$(jq -r '.runs[0].tool.driver.rules[] | select(.help.text? | test("Severity: HIGH")) | .id' "$sarif_file" 2>/dev/null | wc -l | tr -d ' ')
                    medium_count=$(jq -r '.runs[0].tool.driver.rules[] | select(.help.text? | test("Severity: MEDIUM")) | .id' "$sarif_file" 2>/dev/null | wc -l | tr -d ' ')
                    low_count=$(jq -r '.runs[0].tool.driver.rules[] | select(.help.text? | test("Severity: LOW")) | .id' "$sarif_file" 2>/dev/null | wc -l | tr -d ' ')
                fi
                
                # Output counts in format: CRITICAL,HIGH,MEDIUM,LOW
                echo "${critical_count:-0},${high_count:-0},${medium_count:-0},${low_count:-0}"
            }
            
            # Get all counts in a single efficient operation
            local severity_counts=$(count_all_severities "$image_dir/trivy-results.sarif")
            if [ -n "$severity_counts" ]; then
                IFS=',' read -r critical_count high_count medium_count low_count <<< "$severity_counts"
            else
                # Fallback if jq command fails
                local critical_count=0
                local high_count=0
                local medium_count=0
                local low_count=0
            fi
            
            print_status "📊 Vulnerability Summary for $image:"
            print_status "  🔴 Critical: $critical_count"
            print_status "  🟠 High: $high_count"
            print_status "  🟡 Medium: $medium_count"
            print_status "  🔵 Low: $low_count"
            
            local total_vulns=$((critical_count + high_count + medium_count + low_count))
            if [ $total_vulns -gt 0 ]; then
                print_warning "⚠️ Found $total_vulns total vulnerabilities in $image"
            else
                print_success "✅ No vulnerabilities found in $image"
            fi
        fi
    else
        print_warning "⚠️ SARIF output not found or empty for $image"
        echo "SCAN_FAILED: $image - No SARIF output generated" >> "$OUTPUT_DIR/failed_scans.log"
        return 1
    fi
    
    print_status "🔄 scan_image function completed for $image, returning to loop"
}

# Function to display progress banner with figlet
display_progress_banner() {
    local current="$1"
    local total="$2"
    local image="$3"
    
    echo
    echo "═══════════════════════════════════════════════════════════════════════════════"
    echo
    
    # Use figlet if available, otherwise use ASCII art fallback
    if command_exists figlet; then
        # Create the progress text
        local progress_text="$current of $total"
        figlet -f standard "$progress_text"
    else
        # Fallback ASCII art
        echo "    ██████  ██████   ██████   ██████  ██████  ███████ ███████ "
        echo "    ██   ██ ██   ██ ██    ██ ██       ██   ██ ██      ██      "
        echo "    ██████  ██████  ██    ██ ██   ███ ██████  █████   ███████ "
        echo "    ██      ██   ██ ██    ██ ██    ██ ██   ██ ██           ██ "
        echo "    ██      ██   ██  ██████   ██████  ██   ██ ███████ ███████ "
        echo
        echo "                          $current of $total"
    fi
    
    echo
    echo "───────────────────────────────────────────────────────────────────────────────"
    echo "🔍 SCANNING: $image"
    echo "📊 PROGRESS: [$current/$total] ($(( current * 100 / total ))%)"
    echo "⏰ STARTED:  $(date '+%Y-%m-%d %H:%M:%S')"
    echo "───────────────────────────────────────────────────────────────────────────────"
    echo
}

# Function to check if existing scan data is available for an image
has_existing_data() {
    print_status "🔧 Function: has_existing_data"
    local image="$1"
    local safe_name=$(echo "$image" | sed 's/[^a-zA-Z0-9]/-/g')
    
    # Check if data exists in docs/data/ directory
    local existing_data_dir="docs/data/$safe_name"
    
    if [ -d "$existing_data_dir" ] && [ -f "$existing_data_dir/trivy-results.sarif" ]; then
        print_status "✅ Found existing data for $image in $existing_data_dir"
        return 0
    else
        print_status "❌ No existing data found for $image"
        return 1
    fi
}

# Function to copy existing scan data to output directory
copy_existing_data() {
    print_status "🔧 Function: copy_existing_data"
    local image="$1"
    local safe_name=$(echo "$image" | sed 's/[^a-zA-Z0-9]/-/g')
    
    local existing_data_dir="docs/data/$safe_name"
    local target_dir="$OUTPUT_DIR/$safe_name"
    
    # Create target directory
    mkdir -p "$target_dir"
    
    # Copy SARIF file if it exists
    if [ -f "$existing_data_dir/trivy-results.sarif" ]; then
        if cp "$existing_data_dir/trivy-results.sarif" "$target_dir/"; then
            print_status "📋 Copied SARIF data: $existing_data_dir/trivy-results.sarif → $target_dir/"
            
            # Copy any additional files that might exist
            if [ -f "$existing_data_dir/epss-scores.json" ]; then
                cp "$existing_data_dir/epss-scores.json" "$target_dir/" 2>/dev/null || true
                print_status "📋 Copied EPSS data: $existing_data_dir/epss-scores.json → $target_dir/"
            fi
            
            print_success "✅ Successfully copied existing scan data for $image"
            return 0
        else
            print_error "❌ Failed to copy SARIF file for $image"
            return 1
        fi
    else
        print_error "❌ SARIF file not found in existing data for $image"
        return 1
    fi
}

# Function to run sequential scans
run_sequential_scans() {
    local images=("$@")
    local total=${#images[@]}
    local current=1
    local failed_count=0
    local success_count=0
    local reused_count=0
    local scanned_count=0

    print_status "🔄 run_sequential_scans started with $total images"
    
    if [ "$QUICKMODE" = true ]; then
        print_status "🚀 Starting quickmode processing (${total} images)"
        print_status "Will reuse existing data from docs/data/ when available"
    else
        print_status "🔄 Starting sequential image scans (${total} images)"
    fi

    # Run scans sequentially (or copy existing data in quickmode)
    for image in "${images[@]}"; do
        print_status "🔄 Processing image $current of $total: $image"
        
        # Display progress banner with figlet
        display_progress_banner "$current" "$total" "$image"
        
        local image_processed=false
        
        # In quickmode, check for existing data first
        if [ "$QUICKMODE" = true ] && has_existing_data "$image"; then
            print_status "⚡ Quickmode: Found existing data for $image"
            
            if copy_existing_data "$image"; then
                print_success "✅ Reused existing scan data for $image ($current of $total)"
                reused_count=$((reused_count + 1))
                success_count=$((success_count + 1))
                image_processed=true
            else
                print_warning "⚠️ Failed to copy existing data for $image, will scan fresh"
            fi
        fi
        
        # If quickmode failed to copy existing data, or quickmode is disabled, do fresh scan
        if [ "$image_processed" = false ]; then
            print_status "🚀 Scanning image $current of $total: $image"
            
            # Run scan_image and capture its exit code
            if scan_image "$image"; then
                print_status "✅ Completed scan $current of $total: $image"
                scanned_count=$((scanned_count + 1))
                success_count=$((success_count + 1))
            else
                print_warning "❌ Failed to scan image $current of $total: $image"
                echo "SCAN_FAILED: $image - Scan function returned error" >> "$OUTPUT_DIR/failed_scans.log"
                failed_count=$((failed_count + 1))
            fi
        fi
        
        print_status "🔄 Finished processing image $current of $total, moving to next..."
        current=$((current + 1))
    done
    
    print_status "🔄 Loop completed, generating summary..."
    
    if [ "$QUICKMODE" = true ]; then
        print_status "🎉 Quickmode processing completed!"
        print_status "📊 Processing Results Summary:"
        print_status "  • Successfully processed: $success_count images"
        print_status "  • Reused existing data: $reused_count images"
        print_status "  • Fresh scans performed: $scanned_count images"
        print_status "  • Failed operations: $failed_count images"
        
        if [ $reused_count -gt 0 ]; then
            print_success "⚡ Quickmode saved time by reusing $reused_count existing scan results!"
        fi
    else
        print_status "🎉 Sequential scans completed!"
        print_status "📊 Scan Results Summary:"
        print_status "  • Successfully scanned: $success_count images"
        print_status "  • Failed scans: $failed_count images"
    fi
    
    if [ $failed_count -gt 0 ]; then
        print_status "  • See failed_scans.log for details on failed operations"
    fi
    
    print_status "🔄 run_sequential_scans function completed normally"
}

# Function to display discovered images
display_discovered_images() {
    echo -e "\nDiscovered Container Images:"
    echo "==========================="
    echo
    
    for image in "${discovered_images[@]}"; do
        # Split the image into registry, repository, and tag
        local registry
        local repo
        local tag
        
        if [[ "$image" =~ ^([^/]+)/([^:]+):(.+)$ ]]; then
            registry="${BASH_REMATCH[1]}"
            repo="${BASH_REMATCH[2]}"
            tag="${BASH_REMATCH[3]}"
        elif [[ "$image" =~ ^([^:]+):(.+)$ ]]; then
            registry="docker.io"
            repo="${BASH_REMATCH[1]}"
            tag="${BASH_REMATCH[2]}"
        else
            continue
        fi
        
        # Print with proper formatting
        printf "Registry:   %s\n" "$registry"
        printf "Repository: %s\n" "$repo"
        printf "Tag:        %s\n" "$tag"
        printf "Digest:     %s\n\n" "$tag"
    done
}

# Function to show instructions for running the report generation script
show_report_instructions() {
    print_status "🔧 Function: show_report_instructions"
    
    echo ""
    echo "═══════════════════════════════════════════════════════════════════════════════"
    echo "📊 NEXT STEP: Generate Consolidated Reports"
    echo "═══════════════════════════════════════════════════════════════════════════════"
    echo ""
    print_status "🎯 Scanning completed! Now generate comprehensive reports from the SARIF data:"
    echo ""
    
    # Check if report script exists and show appropriate instructions
    if [ -f "./scripts/dimpact-image-report.sh" ]; then
        print_success "✅ Report generation script found: ./scripts/dimpact-image-report.sh"
        echo ""
        print_status "🚀 Run the following command to generate reports:"
        echo ""
        echo "    INPUT_DIR=\"${OUTPUT_DIR}\" CVE_SUPPRESSIONS_FILE=\"cve-suppressions.md\" \\"
        echo "    ./scripts/dimpact-image-report.sh --input-dir \"${OUTPUT_DIR}\""
        echo ""
        print_status "📋 This will create:"
        print_status "  • 📄 Consolidated SARIF file with all vulnerabilities"
        print_status "  • 📊 Markdown summary report with statistics"
        print_status "  • 🌐 HTML dashboard with interactive charts"
        print_status "  • 📈 Charts and visualizations in docs/data/"
        echo ""
        print_status "💡 The report script will automatically update the documentation dashboard"
    else
        print_error "❌ Report generation script not found: ./scripts/dimpact-image-report.sh"
        print_status "📥 Please ensure the report script is available before generating reports"
    fi
    
    echo ""
    print_status "📁 Scan results location: ${OUTPUT_DIR}"
    print_status "🔍 Individual SARIF files are available in subdirectories"
    echo ""
    echo "═══════════════════════════════════════════════════════════════════════════════"
}

# Function to load images from discovered.yaml file
load_images_from_file() {
    local discovered_file="discovered.yaml"
    
    if [ ! -f "$discovered_file" ]; then
        print_error "discovered.yaml file not found"
        print_status "Run image discovery with: ./scripts/dimpact-image-discovery.sh --output-file"
        exit 1
    fi
    
    print_status "Loading images from $discovered_file..."
    
    # Check if yq is available
    if ! command_exists yq; then
        print_error "yq is required to parse YAML file. Please install yq first."
        exit 1
    fi
    
    # Initialize arrays and associative array
    discovered_images=()
    if (( BASH_VERSINFO[0] >= 4 )); then
        image_to_charts=()
    fi
    
    # Parse YAML and extract image names with charts information
    local temp_file=$(mktemp)
    local temp_charts_file=$(mktemp)
    
    # Extract image names (url:version)
    yq e '.[] | .url + ":" + .version' "$discovered_file" > "$temp_file" 2>/dev/null
    
    # Extract charts information for each image (if bash 4+ available)
    if (( BASH_VERSINFO[0] >= 4 )); then
        yq e '.[] | @json' "$discovered_file" 2>/dev/null | while IFS= read -r entry; do
            local url=$(echo "$entry" | jq -r '.url // empty' 2>/dev/null)
            local version=$(echo "$entry" | jq -r '.version // empty' 2>/dev/null)
            
            if [[ -n "$url" && -n "$version" && "$url" != "null" && "$version" != "null" ]]; then
                local image="$url:$version"
                
                # Extract charts array and convert to comma-separated string
                local charts_json=$(echo "$entry" | jq -r '.charts // [] | @json' 2>/dev/null)
                local charts_list=""
                if [[ -n "$charts_json" && "$charts_json" != "null" && "$charts_json" != "[]" ]]; then
                    charts_list=$(echo "$charts_json" | jq -r '.[] // empty' 2>/dev/null | tr '\n' ',' | sed 's/,$//')
                fi
                
                # Store in temporary file for processing outside the subshell
                echo "$image|$charts_list" >> "$temp_charts_file"
            fi
        done
        
        # Read the chart mappings from the temporary file (outside subshell)
        if [[ -f "$temp_charts_file" ]]; then
            while IFS='|' read -r image charts_list; do
                if [[ -n "$image" ]]; then
                    image_to_charts["$image"]="$charts_list"
                fi
            done < "$temp_charts_file"
        fi
    fi
    
    # Read unique images into the discovered_images array
    while IFS= read -r image; do
        if [ -n "$image" ] && [ "$image" != "null" ]; then
            discovered_images+=("$image")
        fi
    done < "$temp_file"
    
    # Clean up temporary files
    rm -f "$temp_file" "$temp_charts_file"
    
    if [ ${#discovered_images[@]} -eq 0 ]; then
        print_error "No images found in $discovered_file"
        exit 1
    fi
    
    print_success "Loaded ${#discovered_images[@]} images from $discovered_file"
    
    # Show charts information if available
    if (( BASH_VERSINFO[0] >= 4 )) && [ ${#image_to_charts[@]} -gt 0 ]; then
        print_status "Charts information loaded for ${#image_to_charts[@]} images"
    fi
}

# Function to force update vulnerability databases
update_vulnerability_databases() {
    print_status "🔄 Force updating vulnerability databases..."
    
    # Ensure Docker CLI hints are disabled
    ensure_docker_env
    
    # Create cache directories
    mkdir -p "$HOME/.cache/trivy"
    
    # Update Trivy database
    print_status "Updating Trivy vulnerability database..."
    docker run --rm \
        -v "$HOME/.cache/trivy:/root/.cache/trivy" \
        "$TRIVY_VERSION" image --download-db-only --db-repository aquasec/trivy-db|| {
        print_error "Failed to update Trivy database"
        return 1
    }
    
    print_success "Vulnerability databases updated successfully"
}

# Function to clean all caches and temporary files
clean_all_caches() {
    print_status "🧹 Cleaning all scanner caches..."
    
    # Ensure Docker CLI hints are disabled
    ensure_docker_env
    
    # Clean Trivy cache
    if [ -d "$HOME/.cache/trivy" ]; then
        print_status "Cleaning Trivy cache..."
        rm -rf "$HOME/.cache/trivy"
    fi
    
    # Clean Docker system
    print_status "Cleaning Docker system..."
    docker system prune -af >/dev/null 2>&1 || true
    
    # Clean temporary directories
    cleanup_temp_dirs
    
    print_success "All caches cleaned successfully"
}

# Function to check available disk space
check_disk_space() {
    local required_gb="${1:-5}"  # Default 5GB requirement
    local temp_dir="${TMPDIR:-/tmp}"
    
    # Get available space in GB (cross-platform)
    local available_gb
    if command_exists df; then
        # Use human-readable format which works on both Linux and macOS
        local avail_str=$(df -h "$temp_dir" 2>/dev/null | awk 'NR==2 {print $4}')
        if [[ "$avail_str" =~ ([0-9.]+)G ]]; then
            available_gb=${BASH_REMATCH[1]%.*}  # Remove decimal part
        elif [[ "$avail_str" =~ ([0-9.]+)T ]]; then
            available_gb=$((${BASH_REMATCH[1]%.*} * 1024))
        elif [[ "$avail_str" =~ ([0-9]+)M ]]; then
            available_gb=1  # Less than 1GB available
        else
            available_gb=10  # Conservative fallback
        fi
    else
        available_gb=10  # Conservative fallback
    fi
    
    print_status "Disk space check:"
    print_status "  • Available space: ${available_gb}GB in $temp_dir"
    print_status "  • Required space: ${required_gb}GB"
    
    if [ "$available_gb" -lt "$required_gb" ]; then
        print_error "Insufficient disk space! Available: ${available_gb}GB, Required: ${required_gb}GB"
        print_status "💡 Recommendations:"
        print_status "  • Free up disk space or use external storage"
        print_status "  • Clean Docker images: docker system prune -a"
        print_status "  • Set TMPDIR to a location with more space"
        return 1
    fi
    
    print_status "✅ Sufficient disk space available"
    return 0
}

# Function to cleanup temporary directories
cleanup_temp_dirs() {
    print_status "🧹 Cleaning up temporary directories..."
    
    # Ensure Docker CLI hints are disabled
    ensure_docker_env
    
    # Clean up Docker system
    docker system prune -f >/dev/null 2>&1 || true
    
    # Clean up any temporary files
    find /tmp -name "trivy-*" -type d -exec rm -rf {} + 2>/dev/null || true
    
    # Clean up TMPDIR if different from /tmp
    if [ "${TMPDIR:-/tmp}" != "/tmp" ]; then
        find "${TMPDIR:-/tmp}" -name "trivy-*" -type d -exec rm -rf {} + 2>/dev/null || true
    fi
}

# Set up cleanup trap
# trap cleanup_on_exit EXIT   # REMOVED - causing premature cleanup

# Main execution block
main() {
    print_status "Starting container image security scan..."
    
    # Show quickmode status
    if [ "$QUICKMODE" = true ]; then
        print_status "⚡ Quickmode enabled - will reuse existing scan data from docs/data/ when available"
    fi
    

    
    # Configure performance settings
    configure_performance "$PERFORMANCE_MODE"
    
    # Handle database update request
    if [ "$UPDATE_DATABASES" = true ]; then

        update_vulnerability_databases
        cleanup_on_exit
        exit 0
    fi
    
    # Handle cache cleanup request
    if [ "$CLEAN_CACHE" = true ]; then

        clean_all_caches
        cleanup_on_exit
        exit 0
    fi
    
    # If --list-images is specified, only list images from discovered.yaml
    if [ "$LIST_IMAGES_ONLY" = true ]; then
        if [ ! -f "discovered.yaml" ]; then
            print_error "discovered.yaml not found. Please generate it externally."
            print_status "Run the image discovery script before using this script."
            cleanup_on_exit
            exit 1
        fi
        load_images_from_file
        display_discovered_images
        cleanup_on_exit
        exit 0
    fi
    
    # Always load and scan discovered images
    if [ ! -f "discovered.yaml" ]; then
        print_error "discovered.yaml not found. Please generate it externally."
        print_status "Run the image discovery script before using this script."
        cleanup_on_exit
        exit 1
    fi
    load_images_from_file
    # Apply test mode limitation if enabled
    if [ "$TESTMODE" = true ]; then
        local original_count=${#discovered_images[@]}
        print_status "🧪 Test mode enabled - limiting scan to first 3 images"
        print_status "Original array has $original_count images"
        
        if [ $original_count -gt 3 ]; then
            # More robust array slicing that works in all bash versions
            local temp_array=()
            local count=0
            print_status "Creating limited array with first 3 images..."
            
            for img in "${discovered_images[@]}"; do
                if [ $count -lt 3 ]; then
                    temp_array[count]="$img"
                    print_status "  Added image $((count + 1)): $img"
                    count=$((count + 1))
                else
                    break
                fi
            done
            
            print_status "Built temp array with ${#temp_array[@]} images"
            
            # Clear and rebuild the discovered_images array
            discovered_images=()
            for i in "${!temp_array[@]}"; do
                discovered_images[i]="${temp_array[i]}"
            done
            
            print_status "Scanning ${#discovered_images[@]} out of $original_count total images"
        else
            print_status "Scanning all ${#discovered_images[@]} images (less than 3 found)"
        fi
        
        print_status "Final array size: ${#discovered_images[@]}"
    fi

    # Debug: Show the first few images to be scanned
    print_status "📋 Images to scan:"
    if [ ${#discovered_images[@]} -eq 0 ]; then
        print_error "No images to scan! Array is empty."
        cleanup_on_exit
        exit 1
    fi

    local debug_count=0
    for img in "${discovered_images[@]}"; do
        if [ $debug_count -lt 5 ]; then
            print_status "  $((debug_count + 1)). $img"
            debug_count=$((debug_count + 1))
        else
            print_status "  ... and $((${#discovered_images[@]} - 5)) more"
            break
        fi
    done

    # Ensure parent directory exists for the new structure
    mkdir -p "$(dirname "$OUTPUT_DIR")"
    mkdir -p "$OUTPUT_DIR"
    print_status "About to call run_sequential_scans with ${#discovered_images[@]} images"
    run_sequential_scans "${discovered_images[@]}"
    
    # Show instructions for running the report generation script
    show_report_instructions
    
    # Explicit cleanup at the end
    cleanup_on_exit
    
    print_success "Scan completed successfully! Results are available in $OUTPUT_DIR"
    echo "[COMPLETED]"
}

# Run main function
main "$@"
