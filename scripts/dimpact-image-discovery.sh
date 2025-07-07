#!/usr/bin/env bash

# Image Discovery Script for Dimpact Helm Charts
# Discovers container images from Helm charts and outputs them as JSON

set -euo pipefail

# Ensure we're using bash
if [[ -z "${BASH_VERSION:-}" ]]; then
    echo "Error: This script requires bash" >&2
    exit 1
fi

# Check bash version
if (( BASH_VERSINFO[0] < 4 )); then
    echo "Warning: This script works best with bash 4.0 or later" >&2
    echo "Current version: $BASH_VERSION" >&2
    echo "On macOS, you can upgrade with: brew install bash" >&2
fi

# Default values
OUTPUT_FILE=""
CHECK_IMAGE_AVAILABILITY=false
FORCED_TRANSLATIONS_FILE="forced_translations.yaml"

# Global variables for translations (using temp files for bash 3.x compatibility)
TRANSLATIONS_DIR="${TMPDIR:-${TMP:-/tmp}}/dimpact_translations_$$"

# Function to handle CTRL-C gracefully
cleanup() {
    echo "" >&2
    echo "🛑 Operation interrupted by user. Cleaning up..." >&2
    # Clean up temporary files
    rm -rf tmp >/dev/null 2>&1
    rm -rf "$TRANSLATIONS_DIR" >/dev/null 2>&1
    exit 130
}

# Set up signal trap for CTRL-C
trap cleanup SIGINT

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --output-file)
            OUTPUT_FILE="discovered.yaml"
            shift
            ;;
        --check-image-availability)
            CHECK_IMAGE_AVAILABILITY=true
            shift
            ;;
        --translations-file)
            FORCED_TRANSLATIONS_FILE="$2"
            shift 2
            ;;
        -h|--help)
            echo "Usage: $0 [--output-file] [--check-image-availability] [--translations-file FILE] [--help]"
            echo ""
            echo "Options:"
            echo "  --output-file               Save YAML output to discovered.yaml file"
            echo "  --check-image-availability  Check availability of all discovered container images"
            echo "  --translations-file         Specify custom forced translations file (default: forced_translations.yaml)"
            echo "  --help                      Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                                            # Discover and display images"
            echo "  $0 --output-file                              # Save discovery to discovered.yaml"
            echo "  $0 --check-image-availability                 # Discover and check image availability"
            echo "  $0 --output-file --check-image-availability   # Save discovery and check image availability"
            echo "  $0 --translations-file translations.yaml      # Use custom translations file"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Exit on any error
set -e

# Function to load forced translations from YAML file
load_forced_translations() {
    # Check if yq is available
    if ! command -v yq >/dev/null 2>&1; then
        return 0
    fi
    
    # Check if forced translations file exists
    if [[ ! -f "$FORCED_TRANSLATIONS_FILE" ]]; then
        return 0
    fi
    
    # Create translations directory
    mkdir -p "$TRANSLATIONS_DIR"
    
    # Load direct image translations
    if yq e '.translations' "$FORCED_TRANSLATIONS_FILE" >/dev/null 2>&1; then
        yq e '.translations | to_entries | .[] | .key + ": " + .value' "$FORCED_TRANSLATIONS_FILE" 2>/dev/null > "$TRANSLATIONS_DIR/translations.txt"
    fi
    
    # Load default versions
    if yq e '.default_versions' "$FORCED_TRANSLATIONS_FILE" >/dev/null 2>&1; then
        yq e '.default_versions | to_entries | .[] | .key + ": " + .value' "$FORCED_TRANSLATIONS_FILE" 2>/dev/null > "$TRANSLATIONS_DIR/default_versions.txt"
    fi
    
    # Load registry redirects
    if yq e '.registry_redirects' "$FORCED_TRANSLATIONS_FILE" >/dev/null 2>&1; then
        yq e '.registry_redirects | to_entries | .[] | .key + ": " + .value' "$FORCED_TRANSLATIONS_FILE" 2>/dev/null > "$TRANSLATIONS_DIR/registry_redirects.txt"
    fi
    
    # Load pattern translations
    if yq e '.pattern_translations' "$FORCED_TRANSLATIONS_FILE" >/dev/null 2>&1; then
        yq e '.pattern_translations | to_entries | .[] | .key + ": " + .value' "$FORCED_TRANSLATIONS_FILE" 2>/dev/null > "$TRANSLATIONS_DIR/pattern_translations.txt"
    fi
}

# Function to apply forced translations to an image URI
apply_forced_translations() {
    local original_image="$1"
    local image="$original_image"
    
    # Step 1: Check for direct translation
    if [[ -f "$TRANSLATIONS_DIR/translations.txt" ]]; then
        # Use simple string matching instead of regex to avoid escaping issues
        local translated=""
        while IFS= read -r line; do
            # Skip empty lines
            if [[ -z "$line" ]]; then
                continue
            fi
            # Split on first ': ' using parameter expansion
            local key="${line%%: *}"
            local value="${line#*: }"
            if [[ "$key" = "$image" ]]; then
                translated="$value"
                break
            fi
        done < "$TRANSLATIONS_DIR/translations.txt"
        
        if [[ -n "$translated" ]]; then
            echo "$translated"
            return
        fi
    fi
    
    # Step 2: Check for pattern translations
    if [[ -f "$TRANSLATIONS_DIR/pattern_translations.txt" ]]; then
        while IFS= read -r line; do
            if [[ -z "$line" ]]; then
                continue
            fi
            local pattern_key="${line%%: *}"
            local pattern_value="${line#*: }"
            
            # Convert pattern to match (replace * with anything)
            local pattern_regex="${pattern_key//\*/.*}"
            
            if [[ "$image" =~ ^${pattern_regex}$ ]]; then
                # Extract the tag from the original image
                local tag=""
                if [[ "$image" =~ :([^:]+)$ ]]; then
                    tag="${BASH_REMATCH[1]}"
                fi
                
                # Replace {tag} placeholder in the pattern value
                local translated_pattern="${pattern_value//\{tag\}/$tag}"
                echo "$translated_pattern"
                return
            fi
        done < "$TRANSLATIONS_DIR/pattern_translations.txt"
    fi
    
    # Step 3: Check for registry redirects
    if [[ "$image" =~ ^([^/]+)/(.+)$ ]] && [[ -f "$TRANSLATIONS_DIR/registry_redirects.txt" ]]; then
        local registry="${BASH_REMATCH[1]}"
        local rest="${BASH_REMATCH[2]}"
        local new_registry=""
        while IFS= read -r line; do
            if [[ -z "$line" ]]; then
                continue
            fi
            local key="${line%%: *}"
            local value="${line#*: }"
            if [[ "$key" = "$registry" ]]; then
                new_registry="$value"
                break
            fi
        done < "$TRANSLATIONS_DIR/registry_redirects.txt"
        
        if [[ -n "$new_registry" ]]; then
            image="$new_registry/$rest"
        fi
    fi
    
    # Step 4: Check for default version mappings
    if [[ "$image" =~ ^(.+):latest$ ]] && [[ -f "$TRANSLATIONS_DIR/default_versions.txt" ]]; then
        local image_base="${BASH_REMATCH[1]}"
        local default_tag=""
        while IFS= read -r line; do
            if [[ -z "$line" ]]; then
                continue
            fi
            local key="${line%%: *}"
            local value="${line#*: }"
            if [[ "$key" = "$image_base" ]]; then
                default_tag="$value"
                break
            fi
        done < "$TRANSLATIONS_DIR/default_versions.txt"
        
        if [[ -n "$default_tag" ]]; then
            image="$image_base:$default_tag"
        fi
    fi
    
    echo "$image"
}

# Function to map repository aliases to their actual URLs
map_repo_url() {
    local repo=$1
    # Remove leading @ if present
    local alias=${repo#@}
    local map_file="repo_map.yaml"
    # Check if yq and the map file exist
    if command -v yq >/dev/null 2>&1 && [[ -f "$map_file" ]]; then
        local uri=$(yq e ".${alias}" "$map_file" 2>/dev/null)
        if [[ -n "$uri" ]] && [[ "$uri" != "null" ]]; then
            echo "$uri"
            return
        fi
    fi
    # Fallback: return the original input
    echo "$repo"
}

# Function to map chart versions to their available versions
map_chart_version() {
    local chart=$1
    local version=$2
    local repo=$3
    local repo_url=$(map_repo_url "$repo")
    local latest_version=$(helm search repo "$chart" --repo "$repo_url" --versions | grep "$chart" | head -n 1 | awk '{print $2}')
    if [[ -n "$latest_version" ]]; then
        echo "$latest_version"
    else
        echo "$version"
    fi
}

# Function to clean image string
clean_image_string() {
    local image="$1"
    # Remove comments
    image=$(echo "$image" | sed 's/#.*$//')
    # Remove leading/trailing whitespace
    image=$(echo "$image" | xargs)
    # Remove empty strings
    if [[ -n "$image" ]] && [[ "$image" != "null" ]]; then
        # Only add docker.io prefix to images that don't already have a registry
        # Check if image already has a registry (contains a dot in the first part)
        if [[ ! "$image" =~ ^[^/]*\.[^/]*/.*$ ]] && [[ ! "$image" =~ ^[^/]*:[0-9]+/.*$ ]]; then
            # This is a Docker Hub image without registry prefix
            if [[ "$image" != */* ]]; then
                # Official library image (no slash)
                image="docker.io/library/$image"
            else
                # Organization/user image (one slash, no explicit registry)
                image="docker.io/$image"
            fi
        fi
        
        echo "$image"
    fi
}

# Function to parse image components
parse_image_components() {
    local image="$1"
    local registry=""
    local repository=""
    local tag=""
    
    # Remove any leading/trailing whitespace
    image=$(echo "$image" | xargs)
    
    # Extract tag first
    if [[ "$image" =~ :([^:]+)$ ]]; then
        tag="${BASH_REMATCH[1]}"
        image="${image%:*}"
    else
        # No tag specified, default to "latest"
        tag="latest"
    fi
    
    # Parse registry and repository
    if [[ "$image" =~ ^([^/]+\.[^/]+)/(.+)$ ]]; then
        # Has registry with dot (e.g., docker.io/bitnami/keycloak, ghcr.io/owner/repo)
        registry="${BASH_REMATCH[1]}"
        repository="${BASH_REMATCH[2]}"
    elif [[ "$image" =~ ^([^/]+):([0-9]+)/(.+)$ ]]; then
        # Has registry with port (e.g., localhost:5000/myapp)
        registry="${BASH_REMATCH[1]}:${BASH_REMATCH[2]}"
        repository="${BASH_REMATCH[3]}"
    elif [[ "$image" =~ ^([^/]+)/(.+)$ ]] && [[ "${BASH_REMATCH[1]}" == *"."* ]]; then
        # Registry with dot but no second component (e.g., registry.k8s.io/something)
        registry="${BASH_REMATCH[1]}"
        repository="${BASH_REMATCH[2]}"
    else
        # No explicit registry - assume Docker Hub
        registry="docker.io"
        if [[ "$image" == */* ]]; then
            # Organization/repository (e.g., bitnami/keycloak)
            repository="$image"
        else
            # Official library image (e.g., alpine)
            repository="library/$image"
        fi
    fi
    
    echo "$registry:$repository:$tag"
}

# Function to validate if a string is a valid Docker tag
is_valid_docker_tag() {
    local tag="$1"
    
    # Check if tag is empty or null
    if [[ -z "$tag" ]] || [[ "$tag" = "null" ]]; then
        return 1
    fi
    
    # Check if tag starts with a comment character
    if [[ "$tag" =~ ^[[:space:]]*# ]]; then
        return 1
    fi
    
    # Check if tag contains spaces (invalid for Docker tags)
    if [[ "$tag" =~ [[:space:]] ]]; then
        return 1
    fi
    
    # Check if tag is just whitespace
    if [[ "$tag" =~ ^[[:space:]]*$ ]]; then
        return 1
    fi
    
    # Check for other invalid characters or patterns
    # Docker tags can contain lowercase letters, digits, underscores, periods, and dashes
    # They can also contain uppercase letters, colons (for digests), and @ symbols
    if [[ "$tag" =~ ^[a-zA-Z0-9._@:-]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to check if Docker is available and running
check_docker() {
    echo "🔧 Checking Docker availability..." >&2
    
    # Ensure Docker CLI hints are disabled
    if [[ -z "${DOCKER_CLI_HINTS:-}" ]]; then
        echo "Setting DOCKER_CLI_HINTS=false to disable Docker CLI hints" >&2
        export DOCKER_CLI_HINTS=false
    elif [[ "$DOCKER_CLI_HINTS" != "false" ]]; then
        echo "Warning: DOCKER_CLI_HINTS is set to '$DOCKER_CLI_HINTS' - setting to 'false' to suppress hints" >&2
        export DOCKER_CLI_HINTS=false
    fi
    
    if ! command -v docker >/dev/null 2>&1; then
        echo "ERROR: Docker is not installed or not in PATH" >&2
        echo "Please install Docker to use the --check-image-availability option" >&2
        return 1
    fi
    
    echo "  ✅ Docker command found: $(which docker)" >&2
    
    # Check Docker version
    local docker_version=$(docker --version 2>/dev/null || echo "unknown")
    echo "  ℹ️  Docker version: $docker_version" >&2
    
    if ! docker info >/dev/null 2>&1; then
        echo "ERROR: Docker is not running or not accessible" >&2
        echo "Please start Docker daemon to use the --check-image-availability option" >&2
        echo "Try running: docker info" >&2
        return 1
    fi
    
    echo "  ✅ Docker daemon is running and accessible" >&2
    
    # Check available checking methods (in priority order)
    echo "🔍 Available image checking methods (priority order):" >&2
    if command -v docker >/dev/null 2>&1 && docker buildx version >/dev/null 2>&1; then
        echo "  1. ✅ docker buildx imagetools (FASTEST - primary method)" >&2
    else
        echo "  1. ❌ docker buildx imagetools (not available)" >&2
    fi
    
    if docker manifest inspect --help >/dev/null 2>&1; then
        echo "  2. ✅ docker manifest inspect (fallback)" >&2
    else
        echo "  2. ❌ docker manifest inspect (not available)" >&2
    fi
    
    if command -v skopeo >/dev/null 2>&1; then
        echo "  3. ✅ skopeo inspect (alternative method)" >&2
    else
        echo "  3. ❌ skopeo inspect (not available)" >&2
    fi
    
    if command -v curl >/dev/null 2>&1; then
        echo "  4. ✅ curl (for Docker Hub API - last resort)" >&2
    else
        echo "  4. ❌ curl (not available)" >&2
    fi
    
    echo "" >&2
    return 0
}

# Function to check dependencies
check_dependencies() {
    local missing_deps=()
    local optional_deps=()
    
    # Check for required commands
    if ! command -v helm >/dev/null 2>&1; then
        missing_deps+=("helm")
    fi
    
    # Check for optional commands
    if ! command -v yq >/dev/null 2>&1; then
        optional_deps+=("yq")
    fi
    
    if ! command -v docker >/dev/null 2>&1; then
        optional_deps+=("docker")
    fi
    
    # Report missing critical dependencies
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        echo "ERROR: Missing required dependencies: ${missing_deps[*]}" >&2
        echo "Installation instructions:" >&2
        for dep in "${missing_deps[@]}"; do
            case "$dep" in
                "helm")
                    echo "  helm - macOS: brew install helm | Ubuntu: snap install helm --classic" >&2
                    ;;
            esac
        done
        exit 1
    fi
}

# Function to check if a container image exists and is accessible
check_image() {
    local image="$1"
    local image_name="${image%:*}"
    local tag="${image##*:}"
    
    # Try multiple methods to check image availability
    # Method 1: Try docker buildx imagetools inspect FIRST (fastest method - 10-15x faster than manifest)
    if command -v docker >/dev/null 2>&1 && docker buildx version >/dev/null 2>&1; then
        if docker buildx imagetools inspect "$image" >/dev/null 2>&1; then
            echo "  🐳 Checking: $image  ✅" >&2
            return 0
        fi
    fi
    
    # Method 2: Fallback to docker manifest inspect (slower but more widely available)
    if docker manifest inspect "$image" >/dev/null 2>&1; then
        echo "  🐳 Checking: $image  ✅" >&2
        return 0
    fi
    
    # Method 3: Try skopeo inspect (if available)
    if command -v skopeo >/dev/null 2>&1; then
        if skopeo inspect "docker://$image" >/dev/null 2>&1; then
            echo "  🐳 Checking: $image  ✅" >&2
            return 0
        fi
    fi
    
    # Method 4: For Docker Hub images, try to use the API directly
    if [[ "$image" =~ ^(docker\.io/)?([^/]+/[^:]+):(.+)$ ]] || [[ "$image" =~ ^(docker\.io/)?library/([^:]+):(.+)$ ]]; then
        local repo_path=""
        local tag_name=""
        
        if [[ "$image" =~ ^(docker\.io/)?library/([^:]+):(.+)$ ]]; then
            # Official library image
            repo_path="library/${BASH_REMATCH[2]}"
            tag_name="${BASH_REMATCH[3]}"
        elif [[ "$image" =~ ^(docker\.io/)?([^/]+/[^:]+):(.+)$ ]]; then
            # Organization/user image
            repo_path="${BASH_REMATCH[2]}"
            tag_name="${BASH_REMATCH[3]}"
        fi
        
        if [[ -n "$repo_path" ]] && [[ -n "$tag_name" ]]; then
            local manifest_url="https://registry-1.docker.io/v2/$repo_path/manifests/$tag_name"
            if curl -s -o /dev/null -w "%{http_code}" -H "Accept: application/vnd.docker.distribution.manifest.v2+json" "$manifest_url" | grep -q "200"; then
                echo "  🐳 Checking: $image  ✅" >&2
                return 0
            fi
        fi
    fi
    
    echo "  🐳 Checking: $image  ❌" >&2
    return 1
}

# Function to check all discovered images
check_discovered_images() {
    local yaml_content="$1"
    local translated_map_file="${TMP_DIR:-/tmp}/translated_map.txt"
    
    echo "🐳 Starting to check discovered container images..." >&2
    echo "" >&2
    
    # Check Docker availability first
    if ! check_docker; then
        return 1
    fi
    
    # Parse YAML content to extract full image URIs
    local full_images=()
    local current_url=""
    local current_version=""
    
    echo "🔍 Parsing YAML content for images..." >&2
    echo "📄 YAML content preview:" >&2
    echo "$yaml_content" | head -20 >&2
    echo "" >&2
    
    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]] && continue
        
        if [[ "$line" =~ ^[[:space:]]*url:[[:space:]]*(.+)$ ]]; then
            current_url="${BASH_REMATCH[1]}"
            # Remove quotes if present
            current_url="${current_url//\"/}"
            current_url="${current_url//\'/}"
            echo "  📍 Found URL: $current_url" >&2
        elif [[ "$line" =~ ^[[:space:]]*version:[[:space:]]*(.+)$ ]]; then
            current_version="${BASH_REMATCH[1]}"
            # Remove quotes if present
            current_version="${current_version//\"/}"
            current_version="${current_version//\'/}"
            
            # Validate the tag/version before using it
            if is_valid_docker_tag "$current_version"; then
                echo "  🏷️  Found valid version: $current_version" >&2
                
                # When we have both URL and version, construct the full image URI
                if [[ -n "$current_url" ]] && [[ -n "$current_version" ]]; then
                    local full_image="$current_url:$current_version"
                    full_images+=("$full_image")
                    echo "  ✅ Assembled image: $full_image" >&2
                    current_url=""
                    current_version=""
                fi
            else
                echo "  ⚠️  Skipping invalid version: $current_version" >&2
                # Reset the current_url since we can't use this version
                current_url=""
                current_version=""
            fi
        elif [[ "$line" =~ ^[[:space:]]*-[[:space:]]*name: ]]; then
            # Reset when we encounter a new item
            current_url=""
            current_version=""
        fi
    done <<< "$yaml_content"
    
    # Filter out any empty entries and invalid images, then remove duplicates and sort
    local filtered_images=()
    for img in "${full_images[@]}"; do
        # Skip empty entries
        if [[ -z "$img" ]]; then
            continue
        fi
        
        # Extract tag from image to validate
        local img_tag=""
        if [[ "$img" =~ :([^:]+)$ ]]; then
            img_tag="${BASH_REMATCH[1]}"
        else
            # No tag specified, default to "latest"
            img_tag="latest"
        fi
        
        # Skip images with invalid tags
        if ! is_valid_docker_tag "$img_tag"; then
            echo "  🚫 Filtering out invalid image: $img (invalid tag: '$img_tag')" >&2
            continue
        fi
        
        filtered_images+=("$img")
    done
    
    # Remove duplicates and sort
    local unique_images=($(printf '%s\n' "${filtered_images[@]}" | sort -u))
    
    local total=${#unique_images[@]}
    local success=0
    local failed=0
    
    echo "📊 Found $total unique images to check" >&2
    
    if [[ $total -eq 0 ]]; then
        echo "⚠️  No images found to check!" >&2
        echo "This could mean:" >&2
        echo "  • The YAML parsing failed" >&2
        echo "  • The chart values don't contain any image references" >&2
        echo "  • The YAML structure is different than expected" >&2
        return 0
    fi
    
    echo "" >&2
    echo "🔍 Images to check:" >&2
    for img in "${unique_images[@]}"; do
        echo "  - $img" >&2
    done
    echo "" >&2
    
    # Check each image (apply forced translations before checking)
    for image in "${unique_images[@]}"; do
        if check_image "$image"; then
            echo "✅ Found: $image"
            echo
            ((success++))
        else
            echo "❌ Not found: $image"
            echo
            ((failed++))
        fi
    done

    echo "" >&2
    echo "🔍 Check Summary:" >&2
    echo "  ✅ Available images: $success" >&2
    echo "  ❌ Unavailable images: $failed" >&2
    echo "  📊 Total checked: $total images" >&2

    # Display total unique images checked (happy, attractive, emoji)
    echo -e "\n🎉✨ Total unique images checked: $success ✨🎉"

    if [[ $failed -gt 0 ]]; then
        echo "" >&2
        echo "⚠️  Some images are not accessible. This may be due to:" >&2
        echo "  • Image does not exist or was moved" >&2
        echo "  • Registry requires authentication" >&2
        echo "  • Network connectivity issues" >&2
        echo "  • Incorrect image name or tag" >&2
    fi
    
    return $failed
}

# Function to build image URI (from extract_helm_images.sh)
build_image_uri() {
    local registry="$1"
    local repository="$2"
    local tag="$3"
    
    # Check if repository already contains a registry (has dots before first slash)
    if [[ "$repository" =~ ^[^/]*\.[^/]*/.*$ ]] || [[ "$repository" =~ ^[^/]*:[0-9]+/.*$ ]]; then
        # Repository already contains a registry, don't add default registry
        local image_uri="$repository"
    else
        # Default registry only for repositories without explicit registry
        if [[ -z "$registry" ]] || [[ "$registry" = "null" ]]; then
            registry="docker.io"
        fi
        local image_uri="${registry}/${repository}"
    fi
    
    # Default tag
    if [[ -z "$tag" ]] || [[ "$tag" = "null" ]] || [[ "$tag" = '""' ]]; then
        tag="latest"
    fi
    
    echo "${image_uri}:${tag}"
}

# Function to extract images from a values file
extract_images_from_values() {
    local values_file="$1"
    local chart_name="$2"
    local output_file="$3"
    
    if [[ -f "$values_file" ]]; then
        # Check if yq is available
        if ! command -v yq >/dev/null 2>&1; then
            echo "ERROR: yq command not found. Please install yq to process YAML files." >&2
            echo "  Ubuntu: sudo snap install yq" >&2
            echo "  or: sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 && sudo chmod +x /usr/local/bin/yq" >&2
            return 1
        fi
        
        # Check if this file has any image sections
        has_images=$(grep -q "image:" "$values_file" && echo "yes")
        
        if [[ "$has_images" = "yes" ]]; then
            # Create temp file for processing
            temp_file=$(mktemp)
            
            # Extract image sections using simple yq
            yq '..|select(has("image"))|.image' "$values_file" 2>/dev/null > "$temp_file"
            
            # Process each image block
            registry=""
            repository=""
            tag=""
            
            while IFS= read -r line; do
                if [[ "$line" =~ ^repository:\ * ]]; then
                    repository=$(echo "$line" | sed 's/repository: *//' | sed 's/#.*//' | tr -d '" ' | xargs)
                elif [[ "$line" =~ ^registry:\ * ]]; then
                    registry=$(echo "$line" | sed 's/registry: *//' | sed 's/#.*//' | tr -d '" ' | xargs)
                elif [[ "$line" =~ ^tag:\ * ]]; then
                    tag=$(echo "$line" | sed 's/tag: *//' | sed 's/#.*//' | tr -d '" ' | xargs)
                    
                    # When we hit a tag line, we likely have a complete image
                    if [[ -n "$repository" ]]; then
                        image_uri=$(build_image_uri "$registry" "$repository" "$tag")
                        echo "$chart_name: $image_uri" >> "$output_file"
                        # Reset for next image
                        registry=""
                        repository=""
                        tag=""
                    fi
                elif [[ "$line" =~ ^---$ ]] || [[ "$line" =~ ^$ ]]; then
                    # Document separator or empty line - process any pending image
                    if [[ -n "$repository" ]]; then
                        image_uri=$(build_image_uri "$registry" "$repository" "$tag")
                        echo "$chart_name: $image_uri" >> "$output_file"
                        # Reset for next image
                        registry=""
                        repository=""
                        tag=""
                    fi
                fi
            done < "$temp_file"
            
            # Process any final pending image
            if [[ -n "$repository" ]]; then
                image_uri=$(build_image_uri "$registry" "$repository" "$tag")
                echo "$chart_name: $image_uri" >> "$output_file"
            fi
            
            rm -f "$temp_file"
        fi
    fi
}

# Function to process a chart and its dependencies
process_chart() {
    local chart_dir="$1"
    local chart_name="$2"
    local output_file="$3"
    
    # Check if chart directory exists
    if [[ ! -d "$chart_dir" ]]; then
        return 1
    fi
    
    # Process the main chart's values
    if [[ -f "$chart_dir/values.yaml" ]]; then
        extract_images_from_values "$chart_dir/values.yaml" "$chart_name" "$output_file"
    fi
    
    # Process any additional values files
    for values_file in "$chart_dir"/values-*.yaml; do
        if [[ -f "$values_file" ]]; then
            extract_images_from_values "$values_file" "$chart_name" "$output_file"
        fi
    done
    
    # Process dependencies if they exist
    if [[ -f "$chart_dir/Chart.yaml" ]]; then
        local deps_dir="$chart_dir/charts"
        if [[ -d "$deps_dir" ]]; then
            for dep_dir in "$deps_dir"/*; do
                if [[ -d "$dep_dir" ]]; then
                    local dep_name=$(basename "$dep_dir")
                    process_chart "$dep_dir" "$dep_name" "$output_file"
                fi
            done
        fi
    fi
}

# Function to check and download dependencies
check_and_download_dependencies() {
    local chart_yaml="$1"
    local dependencies_dir="$2"
    
    # Check if dependencies section exists
    if yq e '.dependencies' "$chart_yaml" > /dev/null 2>&1; then
        # Create dependencies directory if it doesn't exist
        mkdir -p "$dependencies_dir"
        
        # Get the number of dependencies
        local count=$(yq e '.dependencies | length' "$chart_yaml")
        
        # Extract dependencies and download them
        for ((i=0; i<$count; i++)); do
            local name=$(yq e ".dependencies[$i].name" "$chart_yaml")
            local version=$(yq e ".dependencies[$i].version" "$chart_yaml")
            local repo=$(yq e ".dependencies[$i].repository" "$chart_yaml")
            
            # Remove @ prefix from repository name
            repo=${repo#@}
            
            # Pull the chart using the correct format
            if helm pull "$repo/$name" --version "$version" --destination "$dependencies_dir" >/dev/null 2>&1; then
                # Extract the chart
                local chart_file="$dependencies_dir/$name-$version.tgz"
                if [[ -f "$chart_file" ]]; then
                    tar -xzf "$chart_file" -C "$dependencies_dir" >/dev/null 2>&1
                    rm "$chart_file"  # Remove the .tgz file after extraction
                fi
            fi
        done
    fi
}

# Function to generate YAML output
# Now also outputs a mapping of original:translated images to $TMP_DIR/translated_map.txt
generate_yaml_output() {
    local images_file="$1"
    local suppress_file_output="${2:-false}"  # Optional parameter to suppress file output
    local yaml_output=""
    local translated_map_file="${TMP_DIR:-/tmp}/translated_map.txt"
    : > "$translated_map_file"  # Truncate file
    
    # Use associative arrays to group images by url:version and collect charts
    # Check if we have bash 4+ for associative arrays
    if (( BASH_VERSINFO[0] >= 4 )); then
        declare -A image_to_charts
        declare -A image_to_url
        declare -A image_to_version
        
        # First pass: collect all chart-image combinations
        while IFS= read -r line; do
            if [[ $line =~ ^([^:]+):[[:space:]]*(.+)$ ]]; then
                local chart_name="${BASH_REMATCH[1]}"
                local image="${BASH_REMATCH[2]}"
                local original_image="$image"
                
                # Apply forced translations if any
                local translated_image=$(apply_forced_translations "$image")
                if [[ "$translated_image" != "$image" ]]; then
                    image="$translated_image"
                fi
                
                # Write mapping: translated_image:original_image
                echo "$image:$original_image" >> "$translated_map_file"
                
                # Parse image components
                IFS=':' read -r registry repository tag <<< "$(parse_image_components "$image")"
                
                # Validate the tag before including in output
                if ! is_valid_docker_tag "$tag"; then
                    echo "⚠️  Skipping image with invalid tag: $image (tag: '$tag')" >&2
                    continue
                fi
                
                # Construct full URL (maintain docker.io prefix for consistency)
                local full_url
                if [[ -n "$registry" ]]; then
                    full_url="$registry/$repository"
                else
                    # Fallback if no registry detected
                    full_url="$repository"
                fi
                
                # Create unique key for this image (url:version)
                local image_key="$full_url:$tag"
                
                # Store image details
                image_to_url["$image_key"]="$full_url"
                image_to_version["$image_key"]="$tag"
                
                # Add chart to the list for this image
                if [[ "${image_to_charts[$image_key]+isset}" == "isset" ]]; then
                    # Check if chart already exists in the list to avoid duplicates
                    if [[ ! "${image_to_charts[$image_key]}" =~ (^|,)$chart_name(,|$) ]]; then
                        image_to_charts["$image_key"]="${image_to_charts[$image_key]},$chart_name"
                    fi
                else
                    image_to_charts["$image_key"]="$chart_name"
                fi
            fi
        done < <(grep -E '^[^:]+: .+$' "$images_file")
        
        # Second pass: generate YAML output grouped by image
        for image_key in $(printf '%s\n' "${!image_to_charts[@]}" | sort); do
            local url="${image_to_url[$image_key]}"
            local version="${image_to_version[$image_key]}"
            local charts="${image_to_charts[$image_key]}"
            
            # Convert comma-separated charts to YAML array format
            local charts_yaml=""
            IFS=',' read -ra chart_array <<< "$charts"
            for chart in "${chart_array[@]}"; do
                chart=$(echo "$chart" | xargs)  # Trim whitespace
                if [[ -z "$charts_yaml" ]]; then
                    charts_yaml="    - $chart"
                else
                    charts_yaml+=$'\n'"    - $chart"
                fi
            done
            
            # Add YAML entry
            yaml_output+="- url: $url"$'\n'
            yaml_output+="  version: $version"$'\n'
            yaml_output+="  charts:"$'\n'
            yaml_output+="$charts_yaml"$'\n'
        done
    else
        # Fallback for bash < 4: use original logic with warning
        echo "⚠️  Warning: Using bash < 4.0, chart grouping not available" >&2
        
        # Original logic for older bash versions
        while IFS= read -r line; do
            if [[ $line =~ ^([^:]+):[[:space:]]*(.+)$ ]]; then
                local chart_name="${BASH_REMATCH[1]}"
                local image="${BASH_REMATCH[2]}"
                local original_image="$image"
                # Apply forced translations if any
                local translated_image=$(apply_forced_translations "$image")
                if [[ "$translated_image" != "$image" ]]; then
                    image="$translated_image"
                fi
                # Write mapping: translated_image:original_image
                echo "$image:$original_image" >> "$translated_map_file"
                # Parse image components
                IFS=':' read -r registry repository tag <<< "$(parse_image_components "$image")"
                # Validate the tag before including in output
                if ! is_valid_docker_tag "$tag"; then
                    echo "⚠️  Skipping image with invalid tag: $image (tag: '$tag')" >&2
                    continue
                fi
                # Construct full URL (maintain docker.io prefix for consistency)
                local full_url
                if [[ -n "$registry" ]]; then
                    full_url="$registry/$repository"
                else
                    # Fallback if no registry detected
                    full_url="$repository"
                fi
                # Add YAML entry (original format for compatibility)
                yaml_output+="- name: $chart_name"$'\n'
                yaml_output+="  url: $full_url"$'\n'
                yaml_output+="  version: $tag"$'\n'
            fi
        done < <(grep -E '^[^:]+: .+$' "$images_file" | sort -u)
    fi
    
    # Output the YAML
    if [[ "$suppress_file_output" = true ]]; then
        # Just return the content when suppressing file output
        printf "%s" "$yaml_output"
    elif [[ -n "$OUTPUT_FILE" ]]; then
        printf "%s" "$yaml_output" > "$OUTPUT_FILE"
        echo "YAML output saved to $OUTPUT_FILE" >&2
    else
        printf "%s" "$yaml_output"
    fi
}

# Function to download and extract latest Dimpact helm charts
fetch_latest_dimpact_charts() {
    local repo_zip_url="https://github.com/Dimpact-Samenwerking/helm-charts/archive/refs/heads/main.zip"
    local tmp_dir="${TMPDIR:-/tmp}/dimpact_charts_zip_$$"
    local zip_file="$tmp_dir/helm-charts-main.zip"
    local extracted_dir="$tmp_dir/helm-charts-main"
    local charts_src="$extracted_dir/charts"
    local charts_dest="dimpact-charts/charts"

    echo "🛳️  Downloading latest Dimpact helm charts..."

    # Check for curl and unzip dependencies
    local missing=()
    command -v curl >/dev/null 2>&1 || missing+=("curl")
    command -v unzip >/dev/null 2>&1 || missing+=("unzip")
    if [[ ${#missing[@]} -gt 0 ]]; then
        echo "❌ Missing dependencies: ${missing[*]}" >&2
        echo "Please install them and try again!" >&2
        exit 1
    fi

    # Prepare temp dir
    rm -rf "$tmp_dir"
    mkdir -p "$tmp_dir"

    # Download the zip
    echo "📥 Fetching charts zip from GitHub..."
    if ! curl -s -L -o "$zip_file" "$repo_zip_url"; then
        echo "❌ Failed to download charts zip!" >&2
        rm -rf "$tmp_dir"
        exit 1
    fi

    # Unzip
    echo "📦 Unzipping charts..."
    if ! unzip -q "$zip_file" -d "$tmp_dir"; then
        echo "❌ Failed to unzip charts!" >&2
        rm -rf "$tmp_dir"
        exit 1
    fi

    # Move charts to destination
    if [[ -d "$charts_src" ]]; then
        mkdir -p "dimpact-charts"
        rm -rf "$charts_dest"
        cp -r "$charts_src" "$charts_dest"
        rm -rf "$charts_src"
        echo "✅ Charts updated in $charts_dest! 🚀"
    else
        echo "❌ Could not find charts/ in the extracted zip!" >&2
        rm -rf "$tmp_dir"
        exit 1
    fi

    # Clean up
    rm -rf "$tmp_dir"
    echo "🧹 Cleaned up temp files."
    echo "🎉 Dimpact charts are ready!"
}

# Main execution block
main() {
    # Download and extract latest Dimpact helm charts before discovery
    fetch_latest_dimpact_charts
    # Check dependencies first
    check_dependencies
    
    # Load forced translations
    load_forced_translations
    
    # Initialize helm repositories from repo_map.yaml
    if command -v yq >/dev/null 2>&1 && [[ -f "scan-config/repo_map.yaml" ]]; then
        for alias in $(yq e 'keys | .[]' scan-config/repo_map.yaml); do
            uri=$(yq e ".${alias}" scan-config/repo_map.yaml)
            if [[ -n "$alias" ]] && [[ -n "$uri" ]]; then
                helm repo add --force-update "$alias" "$uri" >/dev/null 2>&1
            fi
        done
    else
        echo "ERROR: yq command not found or scan-config/repo_map.yaml is missing." >&2
        echo "Please ensure yq is installed and the repo map file exists." >&2
        exit 1
    fi

    # Update helm repositories silently
    helm repo update >/dev/null 2>&1

    # Create a temporary directory for pulled charts
    TMP_DIR=tmp
    mkdir -p "$TMP_DIR"
    PULLED_CHARTS_DIR="$TMP_DIR/pulled_charts"
    mkdir -p "$PULLED_CHARTS_DIR"

         # Check if the podiumd chart exists
     if [[ ! -d "dimpact-charts/charts/podiumd" ]]; then
         echo "ERROR: podiumd chart not found in the repository" >&2
         echo "Current working directory: $(pwd)" >&2
         echo "Looking for: dimpact-charts/charts/podiumd" >&2
         if [[ -d "dimpact-charts" ]]; then
             echo "dimpact-charts directory exists" >&2
             if [[ -d "dimpact-charts/charts" ]]; then
                 echo "dimpact-charts/charts directory exists" >&2
                 echo "Available charts:" >&2
                 ls -1 dimpact-charts/charts/ 2>/dev/null || echo "No charts found" >&2
             else
                 echo "dimpact-charts/charts directory does not exist" >&2
             fi
         else
             echo "dimpact-charts directory does not exist" >&2
         fi
         exit 1
     fi
     
     # Check for dependencies in the podiumd chart silently
     check_and_download_dependencies "dimpact-charts/charts/podiumd/Chart.yaml" "$PULLED_CHARTS_DIR" >/dev/null 2>&1

    # Create a temporary file for storing images
    IMAGES_FILE="$TMP_DIR/images.txt"
    touch "$IMAGES_FILE"

         # Process all charts and extract images
     if ! process_chart "dimpact-charts/charts/podiumd" "podiumd" "$IMAGES_FILE"; then
         echo "ERROR: Failed to process main podiumd chart" >&2
         exit 1
     fi


    # Process all downloaded dependencies
    for chart_dir in "$PULLED_CHARTS_DIR"/*; do
        if [[ -d "$chart_dir" ]]; then
            chart_name=$(basename "$chart_dir")
            if ! process_chart "$chart_dir" "$chart_name" "$IMAGES_FILE"; then
                echo "WARNING: Failed to process dependency chart: $chart_name" >&2
            fi
        fi
    done

    # Generate YAML output and capture it if we need to check images
    if [[ "$CHECK_IMAGE_AVAILABILITY" = true ]]; then
        # Generate YAML and capture it (suppress file output to handle it ourselves)
        yaml_content=$(generate_yaml_output "$IMAGES_FILE" true)
        
        # Output the YAML (to stdout or file as configured)
        if [[ -n "$OUTPUT_FILE" ]]; then
            printf "%s" "$yaml_content" > "$OUTPUT_FILE"
            echo "YAML output saved to $OUTPUT_FILE" >&2
        else
            printf "%s" "$yaml_content"
        fi
        
        # Debug: print contents of translated_map.txt
        echo "--- DEBUG: Contents of tmp/translated_map.txt ---"
        cat tmp/translated_map.txt || echo "(not found)"
        echo "--- END DEBUG ---"
        
        # Check all discovered images
        echo "" >&2
        check_discovered_images "$yaml_content" || true
    else
        # Standard behavior - just generate and output YAML
        generate_yaml_output "$IMAGES_FILE"
    fi

    # Clean up silently
    rm -rf tmp >/dev/null 2>&1
    rm -rf "$TRANSLATIONS_DIR" >/dev/null 2>&1
}

# Run main function
main
