#!/bin/bash

# Repository Cleanup Script
# This script removes unnecessary files and folders to keep the git repository lean

set -e

echo "🧹 Starting repository cleanup..."
echo

# Function to safely remove if exists
safe_remove() {
    if [ -e "$1" ]; then
        echo "  ✅ Removing: $1"
        rm -rf "$1"
    else
        echo "  ⏭️  Already gone: $1"
    fi
}

# Function to show size before cleanup
echo "📊 Repository size before cleanup:"
du -sh .
echo

# 1. Remove macOS .DS_Store files
echo "🍎 Removing macOS .DS_Store files..."
find . -name ".DS_Store" -type f -delete 2>/dev/null || true
echo "  ✅ Removed all .DS_Store files"
echo

# 2. Remove large scan result directories  
echo "📁 Removing scan result directories (530MB+ savings)..."
safe_remove "dimpact-scan-results"
safe_remove "local-scan-results"
echo

# 3. Remove debug/log files
echo "📜 Removing debug and log files..."
safe_remove "scanner_debug.log"
safe_remove "scan-debug.log"
echo

# 4. Remove temporary/generated files
echo "🗂️  Removing temporary and generated files..."
safe_remove "jim.txt"
safe_remove "temp_output.yaml" 
safe_remove "container_list.txt"
safe_remove "discovered.json"
safe_remove "discovered.yaml"
safe_remove "clamav-3.2.0.tgz"
safe_remove "forced_translations.yaml"
echo

# 5. Remove duplicate chart directories (keep main dimpact-charts)
echo "📦 Removing duplicate chart directories..."
safe_remove "scripts/dimpact-charts"
safe_remove "helm-charts"
echo "  ℹ️  Keeping: dimpact-charts/ (main charts directory)"
echo

# 6. Remove empty directories
echo "📂 Removing empty directories..."
safe_remove "output"
safe_remove "cache"
safe_remove "CVE"
echo

# 7. Optional: Remove potentially unneeded files (uncomment if desired)
echo "❓ Optional removals (currently commented out):"
echo "  - docker-compose.yml (uncomment to remove if not using)"
echo "  - Dockerfile (uncomment to remove if not using)"
echo

# Uncomment these lines if you want to remove them:
# safe_remove "docker-compose.yml"
# safe_remove "Dockerfile"

# Update .gitignore to prevent future issues
echo "📝 Updating .gitignore to prevent future issues..."

# Add entries to .gitignore if they don't exist
gitignore_entries=(
    "# macOS files"
    ".DS_Store"
    ".DS_Store?"
    "*.DS_Store"
    ""
    "# Scan results (should be artifacts only)"
    "dimpact-scan-results/"
    "local-scan-results/"
    "*-scan-results/"
    ""
    "# Debug and log files"
    "*.log"
    "scanner_debug.log"
    "scan-debug.log"
    ""
    "# Temporary files"
    "temp_*.yaml"
    "temp_*.json"
    "container_list.txt"
    "discovered.json" 
    "discovered.yaml"
    ""
    "# Cache directories"
    "cache/"
    ""
    "# Empty output directories"
    "output/"
)

# Backup current .gitignore
cp .gitignore .gitignore.backup

# Add new entries if they don't already exist
for entry in "${gitignore_entries[@]}"; do
    if ! grep -Fxq "$entry" .gitignore 2>/dev/null; then
        echo "$entry" >> .gitignore
    fi
done

echo "  ✅ Updated .gitignore with cleanup rules"
echo "  💾 Backup saved as .gitignore.backup"
echo

# Show final size
echo "📊 Repository size after cleanup:"
du -sh .
echo

echo "✨ Cleanup completed!"
echo
echo "📋 Summary of changes:"
echo "  • Removed macOS .DS_Store files"
echo "  • Removed scan result directories (530MB+ savings)"
echo "  • Removed debug/log files (2.7MB+ savings)"  
echo "  • Removed temporary/generated files"
echo "  • Removed duplicate chart directories (4MB savings)"
echo "  • Removed empty directories"
echo "  • Updated .gitignore to prevent future issues"
echo
echo "🎯 Next steps:"
echo "  1. Review the changes: git status"
echo "  2. Commit the cleanup: git add . && git commit -m '🧹 Repository cleanup: Remove unnecessary files and directories'"
echo "  3. The workflow will now generate scan results as artifacts only"
echo "  4. Chart directories consolidated to: dimpact-charts/"
echo
echo "💡 With space-efficient storage, scan results will be:"
echo "  • Summary reports: Stored in git (small)"
echo "  • Raw data: Stored as GitHub Actions artifacts (large)"
echo "  • This keeps your repository lean while preserving all data!" 
