#!/usr/bin/env bash

# Script to find all values.yaml files and extract image sections
echo "🔍 Scanning for container images in Helm charts..."
echo "=================================================="
echo ""

# Function to build image URI
build_image_uri() {
    local registry="$1"
    local repository="$2"
    local tag="$3"
    
    # Default registry
    if [ -z "$registry" ] || [ "$registry" = "null" ]; then
        registry="docker.io"
    fi
    
    # Default tag
    if [ -z "$tag" ] || [ "$tag" = "null" ] || [ "$tag" = '""' ]; then
        tag="latest"
    fi
    
    echo "${registry}/${repository}:${tag}"
}

# Initialize counters using temporary files to avoid subshell issues
total_images_file=$(mktemp)
total_charts_file=$(mktemp)
echo "0" > "$total_images_file"
echo "0" > "$total_charts_file"

# Find all values.yaml files recursively in tmp/pulled_charts
find tmp/pulled_charts -name "values.yaml" -type f | while read -r file; do
    # Check if this file has any image sections
    has_images=$(grep -q "image:" "$file" && echo "yes")
    
    if [ "$has_images" = "yes" ]; then
        # Extract chart name from file path
        chart_name=$(echo "$file" | sed 's|.*/\([^/]*\)/values\.yaml|\1|')
        
        echo "📦 Chart: $chart_name"
        echo "   📂 File: $file"
        echo ""
        
        # Increment chart counter
        chart_count=$(cat "$total_charts_file")
        echo $((chart_count + 1)) > "$total_charts_file"
        
        # Create temp file for processing
        temp_file=$(mktemp)
        
        # Extract image sections using simple yq
        yq '..|select(has("image"))|.image' "$file" 2>/dev/null > "$temp_file"
        
        # Process each image block
        while IFS= read -r line; do
            if [[ "$line" =~ ^repository:\ * ]]; then
                repository=$(echo "$line" | sed 's/repository: *//' | tr -d '"')
            elif [[ "$line" =~ ^registry:\ * ]]; then
                registry=$(echo "$line" | sed 's/registry: *//' | tr -d '"')
            elif [[ "$line" =~ ^tag:\ * ]]; then
                tag=$(echo "$line" | sed 's/tag: *//' | tr -d '"')
                
                # When we hit a tag line, we likely have a complete image
                if [ -n "$repository" ]; then
                    image_uri=$(build_image_uri "$registry" "$repository" "$tag")
                    echo "   🐳 $image_uri"
                    
                    # Increment image counter
                    image_count=$(cat "$total_images_file")
                    echo $((image_count + 1)) > "$total_images_file"
                    
                    # Reset for next image
                    registry=""
                    repository=""
                    tag=""
                fi
            elif [[ "$line" =~ ^---$ ]] || [[ "$line" =~ ^$ ]]; then
                # Document separator or empty line - process any pending image
                if [ -n "$repository" ]; then
                    image_uri=$(build_image_uri "$registry" "$repository" "$tag")
                    echo "   🐳 $image_uri"
                    
                    # Increment image counter
                    image_count=$(cat "$total_images_file")
                    echo $((image_count + 1)) > "$total_images_file"
                    
                    # Reset for next image
                    registry=""
                    repository=""
                    tag=""
                fi
            fi
        done < "$temp_file"
        
        # Process any final pending image
        if [ -n "$repository" ]; then
            image_uri=$(build_image_uri "$registry" "$repository" "$tag")
            echo "   🐳 $image_uri"
            
            # Increment image counter
            image_count=$(cat "$total_images_file")
            echo $((image_count + 1)) > "$total_images_file"
        fi
        
        rm -f "$temp_file"
        echo ""
    fi
done

# Read final counts
final_image_count=$(cat "$total_images_file")
final_chart_count=$(cat "$total_charts_file")

# Clean up temp files
rm -f "$total_images_file" "$total_charts_file"

echo ""
echo "✨ Scan complete!"
echo "📊 Summary:"
echo "   📦 Charts with images: $final_chart_count"
echo "   🐳 Total container images found: $final_image_count"
