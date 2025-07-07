#!/bin/bash

# Simple EPSS Test Script
# Tests the EPSS integration with a single container image

echo "🧪 Testing EPSS Integration with Container Scanner"
echo "=================================================="

# Test with nginx image (has known vulnerabilities)
TEST_IMAGE="nginx:1.27.4"
OUTPUT_DIR="./test-epss-results"

echo "📦 Testing image: $TEST_IMAGE"
echo "📁 Output directory: $OUTPUT_DIR"
echo ""

# Clean up previous test results
if [ -d "$OUTPUT_DIR" ]; then
    echo "🧹 Cleaning up previous test results..."
    rm -rf "$OUTPUT_DIR"
fi

echo "🚀 Starting EPSS-enhanced scan..."
echo ""

# Run the scanner with EPSS enhancement
./scripts/dimpact-image-scanner.sh \
    --image "$TEST_IMAGE" \
    --output-dir "$OUTPUT_DIR" \
    --testmode

echo ""
echo "✅ Test completed!"
echo ""
echo "📊 Results:"
echo "  • SARIF file: $OUTPUT_DIR/*/trivy-results.sarif"
echo "  • Check for EPSS data in the SARIF properties section"
echo ""

# Check if EPSS data was added
SARIF_FILE=$(find "$OUTPUT_DIR" -name "trivy-results.sarif" | head -1)
if [ -f "$SARIF_FILE" ]; then
    echo "🔍 Checking EPSS enhancement..."
    
    # Check if EPSS metadata exists
    if jq -e '.runs[0].properties.epssEnhanced' "$SARIF_FILE" >/dev/null 2>&1; then
        echo "  ✅ EPSS metadata found in SARIF"
        
        # Count enhanced rules
        ENHANCED_COUNT=$(jq '[.runs[0].tool.driver.rules[] | select(.properties.epss)] | length' "$SARIF_FILE" 2>/dev/null || echo "0")
        echo "  📈 Enhanced $ENHANCED_COUNT vulnerability rules with EPSS data"
        
        # Show sample EPSS scores
        echo "  🎯 Sample EPSS scores:"
        jq -r '.runs[0].tool.driver.rules[] | select(.properties.epss) | "    • " + .id + ": " + (.properties.epss * 100 | tostring | .[0:4]) + "% (" + .properties.epssScore + " risk)"' "$SARIF_FILE" 2>/dev/null | head -5
        
    else
        echo "  ❌ No EPSS metadata found in SARIF"
    fi
else
    echo "❌ SARIF file not found"
fi

echo ""
echo "🌐 Dashboard Integration:"
echo "  • Start dashboard: cd docs && python3 -m http.server 8080"
echo "  • View results at: http://localhost:8080"
echo "  • Look for 🎯 EPSS scores on image cards and in details modal"
echo ""
echo "📚 EPSS Information:"
echo "  • EPSS predicts exploitation probability in next 30 days"
echo "  • Scores range from 0-100% (0-1.0 in API)"
echo "  • >50% = Very High Risk 🔴"
echo "  • >5% = High Risk 🟠"
echo "  • >1% = Medium Risk 🟡"
echo "  • ≤1% = Low Risk 🟢" 
