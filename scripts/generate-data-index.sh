#!/usr/bin/env bash
set -euo pipefail
trap 'echo "❌ Script failed at line $LINENO"' ERR

# Generate Data Index for GitHub Pages Dashboard
# This script creates a JSON index of all available SARIF files
# to avoid dependency on directory listing which GitHub Pages doesn't support

echo "🚀 Starting data index generation..."

# Function to print colored output
print_status() {
    echo -e "\033[0;34mℹ️  [INFO]\033[0m $1"
}

print_success() {
    echo -e "\033[0;32m✅ [SUCCESS]\033[0m $1"
}

print_error() {
    echo -e "\033[0;31m❌ [ERROR]\033[0m $1"
}

# Check if we're in the right location
if [ ! -d "docs/data" ]; then
    print_error "docs/data directory not found. Run this from project root after dimpact-image-report.sh"
    exit 1
fi

# Initialize data index
DATA_INDEX_FILE="docs/data/index.json"
print_status "📝 Creating data index: $DATA_INDEX_FILE"

# Start JSON structure
cat > "$DATA_INDEX_FILE" << 'EOF'
{
  "generated": "",
  "version": "1.0",
  "totalImages": 0,
  "images": []
}
EOF

# Collect all SARIF files
declare -a image_entries
total_images=0

print_status "🔍 Scanning for SARIF files in docs/data/..."

for img_dir in docs/data/*/; do
    if [ -d "$img_dir" ]; then
        img_name=$(basename "$img_dir")
        sarif_file="${img_dir}trivy-results.sarif"
        
        if [ -f "$sarif_file" ]; then
            print_status "  ✅ Found: $img_name"
            
            # Get file size and modification time
            file_size=$(stat -f%z "$sarif_file" 2>/dev/null || stat -c%s "$sarif_file" 2>/dev/null || echo "0")
            file_mtime=$(stat -f%m "$sarif_file" 2>/dev/null || stat -c%Y "$sarif_file" 2>/dev/null || echo "0")
            
            # Convert to ISO date
            if command -v date >/dev/null 2>&1; then
                if [[ "$OSTYPE" == "darwin"* ]]; then
                    file_date=$(date -r "$file_mtime" -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || echo "unknown")
                else
                    file_date=$(date -d "@$file_mtime" -u +"%Y-%m-%dT%H:%M:%SZ" 2>/dev/null || echo "unknown")
                fi
            else
                file_date="unknown"
            fi
            
            # Add to array
            image_entries+=("$img_name|$file_size|$file_date")
            total_images=$((total_images + 1))
        else
            print_status "  ⚠️  Missing SARIF: $img_name"
        fi
    fi
done

print_status "📊 Found $total_images images with SARIF files"

# Generate JSON with proper escaping
{
    echo "{"
    echo "  \"generated\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\","
    echo "  \"version\": \"1.0\","
    echo "  \"description\": \"Auto-generated index of SARIF scan results for GitHub Pages dashboard\","
    echo "  \"totalImages\": $total_images,"
    echo "  \"images\": ["
    
    count=0
    for entry in "${image_entries[@]}"; do
        count=$((count + 1))
        IFS='|' read -r img_name file_size file_date <<< "$entry"
        
        echo -n "    {"
        echo -n "\"name\": \"$img_name\", "
        echo -n "\"sarifPath\": \"data/$img_name/trivy-results.sarif\", "
        echo -n "\"fileSize\": $file_size, "
        echo -n "\"lastModified\": \"$file_date\""
        echo -n "}"
        
        if [ $count -lt ${#image_entries[@]} ]; then
            echo ","
        else
            echo ""
        fi
    done
    
    echo "  ]"
    echo "}"
} > "$DATA_INDEX_FILE"

print_success "🎉 Data index generated successfully!"
print_status "📄 Index file: $DATA_INDEX_FILE"
print_status "📊 Images indexed: $total_images"

# Validate JSON
if command -v jq >/dev/null 2>&1; then
    if jq . "$DATA_INDEX_FILE" >/dev/null 2>&1; then
        print_success "✅ JSON validation passed"
    else
        print_error "❌ JSON validation failed"
        exit 1
    fi
else
    print_status "ℹ️  jq not available - skipping JSON validation"
fi

print_success "🌐 Dashboard will now work on GitHub Pages!"
echo ""
echo "📋 Next steps:"
echo "  1. 📤 git add docs/data/index.json"
echo "  2. 💾 git commit -m \"Add data index for GitHub Pages\""
echo "  3. 🚀 git push origin main" 
