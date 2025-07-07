#!/usr/bin/env bash

# Environment Diagnostic Script for GitHub Actions Self-Hosted Runner
# This script helps diagnose why the security scanning workflow is failing

set -e

echo "🔍 Environment Diagnostic Report"
echo "================================="
echo

# Basic environment info
echo "📍 Environment Information:"
echo "  • OS: $(uname -s)"
echo "  • Architecture: $(uname -m)"
echo "  • Kernel: $(uname -r)"
echo "  • Date: $(date)"
echo "  • User: $(whoami)"
echo "  • Working Directory: $(pwd)"
echo

# Check environment variables
echo "🌍 Environment Variables:"
echo "  • HOME: ${HOME:-'not set'}"
echo "  • PATH: ${PATH:-'not set'}"
echo "  • OSTYPE: ${OSTYPE:-'not set'}"
echo "  • CI: ${CI:-'not set'}"
echo "  • GITHUB_ACTIONS: ${GITHUB_ACTIONS:-'not set'}"
echo "  • RUNNER_OS: ${RUNNER_OS:-'not set'}"
echo

# Check dependencies
echo "🔧 Dependency Check:"
dependencies=("docker" "jq" "helm" "yq" "figlet" "bash")
for dep in "${dependencies[@]}"; do
    if command -v "$dep" >/dev/null 2>&1; then
        version=$(${dep} --version 2>/dev/null | head -1 || echo "unknown")
        echo "  ✅ $dep: $(which $dep) ($version)"
    else
        echo "  ❌ $dep: not found"
    fi
done
echo

# Check Docker specifically
echo "🐳 Docker Status:"

# Ensure Docker CLI hints are disabled
if [ -z "${DOCKER_CLI_HINTS:-}" ]; then
    echo "  Setting DOCKER_CLI_HINTS=false to disable Docker CLI hints"
    export DOCKER_CLI_HINTS=false
elif [ "$DOCKER_CLI_HINTS" != "false" ]; then
    echo "  Warning: DOCKER_CLI_HINTS is set to '$DOCKER_CLI_HINTS' - setting to 'false' to suppress hints"
    export DOCKER_CLI_HINTS=false
fi

if command -v docker >/dev/null 2>&1; then
    echo "  • Docker executable: $(which docker)"
    echo "  • Docker version: $(docker --version)"
    
    if docker info >/dev/null 2>&1; then
        echo "  ✅ Docker daemon: accessible"
        echo "  • Docker root dir: $(docker info --format '{{.DockerRootDir}}')"
        echo "  • Server version: $(docker info --format '{{.ServerVersion}}')"
        echo "  • Storage driver: $(docker info --format '{{.Driver}}')"
        echo "  • Total memory: $(docker info --format '{{.MemTotal}}')"
        echo "  • CPUs: $(docker info --format '{{.NCPU}}')"
    else
        echo "  ❌ Docker daemon: not accessible"
        echo "  • Check if Docker daemon is running"
        echo "  • Check Docker socket permissions"
    fi
    
    # Test Docker with hello-world
    echo "  • Testing Docker with hello-world..."
    if docker run --rm hello-world >/dev/null 2>&1; then
        echo "  ✅ Docker test: successful"
    else
        echo "  ❌ Docker test: failed"
    fi
else
    echo "  ❌ Docker: not installed"
fi
echo

# Check submodule status
echo "📦 Submodule Status:"
if [ -f ".gitmodules" ]; then
    echo "  • .gitmodules exists: ✅"
    if [ -d "dimpact-charts" ]; then
        echo "  • dimpact-charts directory: ✅"
        if [ -d "dimpact-charts/charts" ]; then
            echo "  • dimpact-charts/charts directory: ✅"
            chart_count=$(find dimpact-charts/charts -mindepth 1 -maxdepth 1 -type d | wc -l)
            echo "  • Number of charts: $chart_count"
            if [ "$chart_count" -gt 0 ]; then
                echo "  • Chart directories:"
                find dimpact-charts/charts -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | head -5 | sed 's/^/    - /'
            else
                echo "  ❌ No chart directories found"
            fi
        else
            echo "  ❌ dimpact-charts/charts directory: missing"
        fi
        
        # Check git submodule status
        if command -v git >/dev/null 2>&1; then
            echo "  • Git submodule status:"
            git submodule status 2>/dev/null | sed 's/^/    /' || echo "    Error checking submodule status"
        fi
    else
        echo "  ❌ dimpact-charts directory: missing"
    fi
else
    echo "  ❌ .gitmodules: not found"
fi
echo

# Check system resources
echo "💻 System Resources:"
if command -v nproc >/dev/null 2>&1; then
    cpu_cores=$(nproc)
elif command -v sysctl >/dev/null 2>&1; then
    cpu_cores=$(sysctl -n hw.ncpu 2>/dev/null || echo "unknown")
else
    cpu_cores="unknown"
fi
echo "  • CPU cores: $cpu_cores"

# Memory detection
if command -v free >/dev/null 2>&1; then
    total_mem_gb=$(free -g | awk '/^Mem:/{print $2}')
    echo "  • Total memory: ${total_mem_gb}GB (via free)"
elif command -v sysctl >/dev/null 2>&1; then
    mem_bytes=$(sysctl -n hw.memsize 2>/dev/null || echo "0")
    if [ "$mem_bytes" != "0" ]; then
        total_mem_gb=$(echo "$mem_bytes" | awk '{print int($0/1024/1024/1024)}')
        echo "  • Total memory: ${total_mem_gb}GB (via sysctl)"
    else
        echo "  • Total memory: unknown"
    fi
else
    echo "  • Total memory: unknown (no detection method available)"
fi

# Disk space
echo "  • Disk space:"
df -h . | awk 'NR==2 {print "    Available: " $4 " of " $2 " (" $5 " used)"}'
echo

# Check scanner scripts
echo "📜 Scanner Scripts:"
scripts=("dimpact-image-scanner.sh" "dimpact-image-report.sh" "dimpact-image-discovery.sh")
for script in "${scripts[@]}"; do
    if [ -f "scripts/$script" ]; then
        if [ -x "scripts/$script" ]; then
            echo "  ✅ scripts/$script: exists and executable"
        else
            echo "  ⚠️  scripts/$script: exists but not executable"
        fi
    else
        echo "  ❌ scripts/$script: not found"
    fi
done
echo

# Test image discovery
echo "🔍 Image Discovery Test:"
if [ -f "scripts/dimpact-image-discovery.sh" ] && [ -x "scripts/dimpact-image-discovery.sh" ]; then
    echo "  • Running discovery test..."
    if discovery_output=$(./scripts/dimpact-image-discovery.sh 2>&1 | head -10); then
        image_count=$(echo "$discovery_output" | grep -c "^- name:" || echo "0")
        echo "  ✅ Discovery successful: $image_count images found"
        if [ "$image_count" -gt 0 ]; then
            echo "  • Sample images:"
            echo "$discovery_output" | grep "^- name:" | head -3 | sed 's/^/    /'
        fi
    else
        echo "  ❌ Discovery failed"
        echo "$discovery_output" | sed 's/^/    Error: /'
    fi
else
    echo "  ❌ Cannot test discovery: script not found or not executable"
fi
echo

# Test Docker containers can be pulled
echo "🚢 Container Image Test:"
test_images=("aquasec/trivy:latest")
for image in "${test_images[@]}"; do
    echo "  • Testing $image..."
    if docker pull "$image" >/dev/null 2>&1; then
        echo "    ✅ Pull successful"
        # Test run
        if [ "$image" = "aquasec/trivy:latest" ]; then
            if docker run --rm "$image" --version >/dev/null 2>&1; then
                echo "    ✅ Run test successful"
            else
                echo "    ❌ Run test failed"
            fi
        fi
    else
        echo "    ❌ Pull failed"
    fi
done
echo

# Check cache directories
echo "💾 Cache Directories:"
cache_dirs=("$HOME/.cache/trivy")
for cache_dir in "${cache_dirs[@]}"; do
    if [ -d "$cache_dir" ]; then
        size=$(du -sh "$cache_dir" 2>/dev/null | cut -f1 || echo "unknown")
        echo "  ✅ $cache_dir: exists ($size)"
    else
        echo "  ❌ $cache_dir: not found"
    fi
done
echo

# Summary
echo "📋 Summary:"
echo "  • Check any ❌ items above for potential issues"
echo "  • Ensure all dependencies are installed and accessible"
echo "  • Verify Docker daemon is running and accessible"
echo "  • Confirm submodules are properly checked out"
echo "  • Check that scanner scripts have execute permissions"
echo

echo "🎯 Quick Fix Commands:"
echo "  # Fix script permissions:"
echo "  chmod +x scripts/*.sh"
echo
echo "  # Initialize submodules:"
echo "  git submodule update --init --recursive"
echo
echo "  # Test scanner locally:"
echo "  ./scripts/dimpact-image-scanner.sh --testmode --debug --image nginx:latest"
echo

echo "Diagnostic complete! 🏁" 
