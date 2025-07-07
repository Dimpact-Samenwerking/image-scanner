#!/usr/bin/env bash

# Test Script for Dimpact Image Report Generator
# This script demonstrates the enhanced reporting functionality with sample data

set -e

# Colors for output
if [ -z "$CI" ]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    PURPLE='\033[0;35m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    PURPLE=''
    NC=''
fi

print_header() {
    echo ""
    echo -e "${PURPLE}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${PURPLE}║${NC}  🧪 ${PURPLE}Dimpact Image Report Generator - Test Suite${NC}         ${PURPLE}║${NC}"
    echo -e "${PURPLE}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_step() {
    echo -e "${BLUE}🔧 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_info() {
    echo -e "${YELLOW}ℹ️  $1${NC}"
}

# Function to check if jq is installed
check_dependencies() {
    if ! command -v jq >/dev/null 2>&1; then
        echo -e "${RED}❌ Error: jq is required but not installed${NC}"
        echo -e "${YELLOW}Please install jq:${NC}"
        echo "  - macOS: brew install jq"
        echo "  - Ubuntu/Debian: sudo apt-get install jq"
        echo "  - CentOS/RHEL: sudo yum install jq"
        exit 1
    fi
}

# Function to display test data overview
show_test_data_overview() {
    print_step "📊 Test Data Overview"
    echo ""
    echo "The test suite includes the following sample scenarios:"
    echo ""
    echo "1. 🔴 wordpress-critical  - Multiple critical vulnerabilities"
    echo "2. 🟠 nginx-high         - High severity vulnerabilities"
    echo "3. 🟡 mysql-medium       - Medium severity vulnerabilities"
    echo "4. 🔵 redis-low          - Low severity vulnerabilities"
    echo "5. 🌈 postgres-mixed     - Mixed severities + CVE suppressions"
    echo "6. ❌ apache-failed      - Failed scan scenario"
    echo ""
    print_info "CVE suppressions test file includes 2 suppressed CVEs"
    echo ""
}

# Function to run the report generator
run_report_test() {
    print_step "🚀 Running Report Generator with Test Data"
    echo ""
    
    # Run the report generator in test mode
    if scripts/dimpact-image-report.sh --test; then
        print_success "Report generation completed successfully!"
    else
        echo -e "${RED}❌ Report generation failed${NC}"
        exit 1
    fi
}

# Function to display the generated report
show_report_results() {
    local report_file="test-data/sample-scan-results/SCAN_REPORT.md"
    
    if [ -f "$report_file" ]; then
        print_step "📋 Generated Report Preview"
        echo ""
        echo -e "${YELLOW}Report file: $report_file${NC}"
        echo ""
        
        # Show first 50 lines of the report
        echo -e "${BLUE}--- Report Preview (first 50 lines) ---${NC}"
        head -50 "$report_file"
        echo ""
        echo -e "${BLUE}--- End Preview ---${NC}"
        echo ""
        
        # Show file size and line count
        local file_size=$(wc -c < "$report_file")
        local line_count=$(wc -l < "$report_file")
        print_info "Report statistics: $line_count lines, $file_size bytes"
        
        echo ""
        echo -e "${GREEN}💡 View the complete report with:${NC}"
        echo "   cat $report_file"
        echo "   or"
        echo "   open $report_file  # (macOS)"
        echo ""
    else
        echo -e "${RED}❌ Report file not found: $report_file${NC}"
        exit 1
    fi
}

# Function to validate test data structure
validate_test_data() {
    print_step "🔍 Validating Test Data Structure"
    
    local test_dir="test-data/sample-scan-results"
    local validation_passed=true
    
    # Check if test directory exists
    if [ ! -d "$test_dir" ]; then
        echo -e "${RED}❌ Test data directory not found: $test_dir${NC}"
        validation_passed=false
    fi
    
    # Check each test scenario
    local scenarios=("wordpress-critical" "nginx-high" "mysql-medium" "redis-low" "postgres-mixed")
    
    for scenario in "${scenarios[@]}"; do
        local json_file="$test_dir/$scenario/trivy-results.json"
        if [ -f "$json_file" ]; then
            # Validate JSON syntax
            if jq empty "$json_file" 2>/dev/null; then
                echo -e "${GREEN}✅ $scenario: Valid JSON${NC}"
            else
                echo -e "${RED}❌ $scenario: Invalid JSON${NC}"
                validation_passed=false
            fi
        else
            echo -e "${RED}❌ $scenario: Missing trivy-results.json${NC}"
            validation_passed=false
        fi
    done
    
    # Check apache-failed (should not have JSON file)
    if [ ! -f "$test_dir/apache-failed/trivy-results.json" ]; then
        echo -e "${GREEN}✅ apache-failed: Correctly missing JSON (failed scan)${NC}"
    else
        echo -e "${YELLOW}⚠️  apache-failed: Unexpectedly has JSON file${NC}"
    fi
    
    # Check CVE suppressions file
    if [ -f "test-data/cve-suppressions.md" ]; then
        echo -e "${GREEN}✅ CVE suppressions file exists${NC}"
    else
        echo -e "${RED}❌ CVE suppressions file missing${NC}"
        validation_passed=false
    fi
    
    if [ "$validation_passed" = true ]; then
        print_success "All test data validation checks passed!"
    else
        echo -e "${RED}❌ Test data validation failed${NC}"
        exit 1
    fi
    echo ""
}

# Function to show expected results
show_expected_results() {
    print_step "📈 Expected Results Summary"
    echo ""
    echo "The generated report should show:"
    echo ""
    echo "📊 Overall Totals:"
    echo "  • Critical: 3 (2 from wordpress + 1 from postgres, minus 1 suppressed)"
    echo "  • High: 3 (1 from wordpress + 2 from nginx + 1 from postgres)"
    echo "  • Medium: 4 (1 from wordpress + 1 from nginx + 3 from mysql + 1 from postgres)"
    echo "  • Low: 7 (1 from nginx + 1 from mysql + 4 from redis + 2 from postgres, minus 1 suppressed)"
    echo "  • Suppressed: 2 (CVE-2023-1234 and CVE-2023-2222)"
    echo "  • Failed: 1 (apache-failed)"
    echo ""
    echo "🏆 Image Ranking (by critical vulnerabilities):"
    echo "  1. wordpress-critical (2 critical)"
    echo "  2. postgres-mixed (0 critical, 1 suppressed)"
    echo "  3. nginx-high (0 critical)"
    echo "  4. mysql-medium (0 critical)"
    echo "  5. redis-low (0 critical)"
    echo "  6. apache-failed (scan failed)"
    echo ""
}

# Main execution
main() {
    print_header
    
    # Check dependencies
    print_step "🔧 Checking Dependencies"
    check_dependencies
    print_success "All dependencies available"
    echo ""
    
    # Validate test data
    validate_test_data
    
    # Show test data overview
    show_test_data_overview
    
    # Show expected results
    show_expected_results
    
    # Run the test
    run_report_test
    
    # Show results
    show_report_results
    
    echo -e "${GREEN}🎉 Test completed successfully!${NC}"
    echo ""
    echo -e "${PURPLE}Next steps:${NC}"
    echo "1. Review the generated report"
    echo "2. Test with your own scan data using: scripts/dimpact-image-report.sh --output-dir YOUR_DIR"
    echo "3. Customize CVE suppressions as needed"
    echo ""
}

# Run the main function
main "$@" 
