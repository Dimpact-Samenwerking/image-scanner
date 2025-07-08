#!/usr/bin/env bash

# Utility functions for Dimpact image scanner

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

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

ensure_docker_env() {
    if [ -z "${DOCKER_CLI_HINTS:-}" ]; then
        print_status "Setting DOCKER_CLI_HINTS=false to disable Docker CLI hints"
        export DOCKER_CLI_HINTS=false
    elif [ "$DOCKER_CLI_HINTS" != "false" ]; then
        print_warning "DOCKER_CLI_HINTS is set to '$DOCKER_CLI_HINTS' - setting to 'false' to suppress hints"
        export DOCKER_CLI_HINTS=false
    fi
}

get_absolute_path() {
    local path="$1"
    mkdir -p "$path"
    if command_exists realpath; then
        realpath "$path"
    elif command_exists python3; then
        python3 -c "import os; print(os.path.abspath('$path'))"
    elif command_exists python; then
        python -c "import os; print(os.path.abspath('$path'))"
    elif command_exists perl; then
        perl -MCwd=abs_path -le "print abs_path('$path')"
    else
        cd "$path" && pwd
    fi
}

check_disk_space() {
    local required_gb="${1:-5}"
    local temp_dir="${TMPDIR:-/tmp}"
    local available_gb
    if command_exists df; then
        local avail_str=$(df -h "$temp_dir" 2>/dev/null | awk 'NR==2 {print $4}')
        if [[ "$avail_str" =~ ([0-9.]+)G ]]; then
            available_gb=${BASH_REMATCH[1]%.*}
        elif [[ "$avail_str" =~ ([0-9.]+)T ]]; then
            available_gb=$((${BASH_REMATCH[1]%.*} * 1024))
        elif [[ "$avail_str" =~ ([0-9]+)M ]]; then
            available_gb=1
        else
            available_gb=10
        fi
    else
        available_gb=10
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

cleanup_temp_dirs() {
    print_status "🧹 Cleaning up temporary directories..."
    ensure_docker_env
    docker system prune -f >/dev/null 2>&1 || true
    find /tmp -name "trivy-*" -type d -exec rm -rf {} + 2>/dev/null || true
    if [ "${TMPDIR:-/tmp}" != "/tmp" ]; then
        find "${TMPDIR:-/tmp}" -name "trivy-*" -type d -exec rm -rf {} + 2>/dev/null || true
    fi
}

cleanup_on_exit() {
    print_status "🧹 Performing final cleanup..."
    ensure_docker_env
    cleanup_temp_dirs
    local avail_str=$(df -h "${TMPDIR:-/tmp}" 2>/dev/null | awk 'NR==2 {print $4}' || echo "10G")
    local available_gb
    if [[ "$avail_str" =~ ([0-9.]+)G ]]; then
        available_gb=${BASH_REMATCH[1]%.*}
    elif [[ "$avail_str" =~ ([0-9.]+)T ]]; then
        available_gb=$((${BASH_REMATCH[1]%.*} * 1024))
    elif [[ "$avail_str" =~ ([0-9]+)M ]]; then
        available_gb=1
    else
        available_gb=10
    fi
    if [ "$available_gb" -lt 5 ] 2>/dev/null; then
        print_status "Low disk space detected, cleaning up unused Docker images..."
        docker image prune -f >/dev/null 2>&1 || true
    fi
}

# Shared function: Load CVE suppressions from a markdown file
load_cve_suppressions() {
    suppressed_cves=()
    local suppressions_file="${CVE_SUPPRESSIONS_FILE:-cve-suppressions.md}"
    if [ -f "$suppressions_file" ]; then
        print_status "Loading CVE suppressions from $suppressions_file..."
        # Extract CVE IDs from the markdown table (skip header rows)
        while IFS='|' read -r _ cve_id _; do
            cve_id=$(echo "$cve_id" | xargs)
            if [[ "$cve_id" =~ ^CVE-[0-9]{4}-[0-9]+$ ]]; then
                suppressed_cves+=("$cve_id")
                print_status "  ✓ Suppressing CVE: $cve_id"
            fi
        done < <(grep -E '^\|[[:space:]]*CVE-' "$suppressions_file" 2>/dev/null || true)
        print_status "  📊 Total suppressed CVEs: ${#suppressed_cves[@]}"
    else
        print_status "No $suppressions_file file found, no CVEs will be suppressed"
    fi
} 
