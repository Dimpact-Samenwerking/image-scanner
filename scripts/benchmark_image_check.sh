#!/usr/bin/env bash

# Benchmark script to test different methods of checking Docker image existence
set -euo pipefail

echo "🏃‍♂️ Docker Image Existence Check Benchmark"
echo "============================================="

# Test images - mix of existing and non-existing
TEST_IMAGES=(
    "docker.io/alpine:3.20"
    "docker.io/nginx:1.27.4"
    "docker.io/bitnami/postgresql:17.2.0-debian-12-r2"
    "docker.io/curlimages/curl:8.13.0"
    "docker.io/library/ubuntu:22.04"
    "docker.io/nonexistent/image:latest"
    "docker.io/fake/test:v1.0.0"
    "docker.io/alpine:nonexistent-tag"
)

# Function to time a command (simplified approach)
time_command() {
    local cmd="$1"
    local image="$2"
    
    # Simple timing using date
    local start_time=$(date +%s)
    
    if eval "$cmd \"$image\"" >/dev/null 2>&1; then
        local result="✅"
    else
        local result="❌"
    fi
    
    local end_time=$(date +%s)
    local duration=$(((end_time - start_time) * 1000)) # Convert to milliseconds
    
    # If duration is 0, run a more detailed test for small times
    if [ "$duration" -eq 0 ]; then
        # Run multiple times and take average for sub-second operations
        local start_detailed=$(date +%s)
        for i in {1..3}; do
            eval "$cmd \"$image\"" >/dev/null 2>&1
        done
        local end_detailed=$(date +%s)
        duration=$(( (end_detailed - start_detailed) * 1000 / 3 ))
    fi
    
    echo "$duration:$result"
}

# Test docker manifest inspect
test_manifest() {
    local image="$1"
    time_command "docker manifest inspect" "$image"
}

# Test docker buildx imagetools inspect
test_buildx() {
    local image="$1"
    time_command "docker buildx imagetools inspect" "$image"
}

# Check if buildx is available
if ! docker buildx version >/dev/null 2>&1; then
    echo "❌ Docker buildx not available"
    exit 1
fi

echo "🔍 Testing with ${#TEST_IMAGES[@]} images..."
echo ""

# Headers
printf "%-50s | %-20s | %-20s | %-10s\n" "Image" "Manifest (ms)" "Buildx (ms)" "Winner"
printf "%-50s-|-%-20s-|-%-20s-|-%-10s\n" "$(printf '%*s' 50 '' | tr ' ' '-')" "$(printf '%*s' 20 '' | tr ' ' '-')" "$(printf '%*s' 20 '' | tr ' ' '-')" "$(printf '%*s' 10 '' | tr ' ' '-')"

total_manifest_time=0
total_buildx_time=0
manifest_wins=0
buildx_wins=0

for image in "${TEST_IMAGES[@]}"; do
    echo -n "Testing $image..." >&2
    
    # Test manifest method
    manifest_result=$(test_manifest "$image")
    manifest_time=${manifest_result%:*}
    manifest_status=${manifest_result#*:}
    
    # Test buildx method  
    buildx_result=$(test_buildx "$image")
    buildx_time=${buildx_result%:*}
    buildx_status=${buildx_result#*:}
    
    # Determine winner
    if [ "$manifest_time" -lt "$buildx_time" ]; then
        winner="Manifest"
        ((manifest_wins++))
    elif [ "$buildx_time" -lt "$manifest_time" ]; then
        winner="Buildx"
        ((buildx_wins++))
    else
        winner="Tie"
    fi
    
    # Add to totals
    total_manifest_time=$((total_manifest_time + manifest_time))
    total_buildx_time=$((total_buildx_time + buildx_time))
    
    printf "%-50s | %10s ms %s | %10s ms %s | %-10s\n" \
        "$image" \
        "$manifest_time" "$manifest_status" \
        "$buildx_time" "$buildx_status" \
        "$winner"
    
    echo " done" >&2
done

echo ""
echo "📊 BENCHMARK RESULTS"
echo "===================="
echo "Total images tested: ${#TEST_IMAGES[@]}"
echo "Manifest total time: ${total_manifest_time}ms"
echo "Buildx total time: ${total_buildx_time}ms"
echo "Average manifest time: $((total_manifest_time / ${#TEST_IMAGES[@]}))ms"
echo "Average buildx time: $((total_buildx_time / ${#TEST_IMAGES[@]}))ms"
echo ""
echo "Winner count:"
echo "  Manifest wins: $manifest_wins"
echo "  Buildx wins: $buildx_wins"
echo ""

if [ "$total_manifest_time" -lt "$total_buildx_time" ]; then
    improvement=$(( (total_buildx_time - total_manifest_time) * 100 / total_buildx_time ))
    echo "🏆 WINNER: docker manifest inspect"
    echo "   → ${improvement}% faster than buildx overall"
elif [ "$total_buildx_time" -lt "$total_manifest_time" ]; then
    improvement=$(( (total_manifest_time - total_buildx_time) * 100 / total_manifest_time ))
    echo "🏆 WINNER: docker buildx imagetools inspect"
    echo "   → ${improvement}% faster than manifest overall"
else
    echo "🤝 TIE: Both methods performed equally"
fi

echo ""
echo "💡 RECOMMENDATION:"
if [ "$manifest_wins" -gt "$buildx_wins" ]; then
    echo "   Use 'docker manifest inspect' as the primary method"
elif [ "$buildx_wins" -gt "$manifest_wins" ]; then
    echo "   Use 'docker buildx imagetools inspect' as the primary method"
else
    echo "   Both methods are comparable - use either"
fi 
