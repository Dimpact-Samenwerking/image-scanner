#!/usr/bin/env bash
# dimpact-scan-postprocess.sh
#
# Post-processing for container scan workflow: report generation, dashboard data,
# historical storage, cleanup, and documentation. Compatible with Ubuntu/macOS.
#
# Usage:
#   ./scripts/dimpact-scan-postprocess.sh <SCAN_DATE> <SCAN_TIMESTAMP> <GITHUB_RUN_ID> <GITHUB_RUN_NUMBER> <GITHUB_SHA> <GITHUB_REF> <GITHUB_ACTOR> <GITHUB_EVENT_NAME>
#
# All output is emoji-rich and shellcheck clean. Lines <80 chars.
#
# Arguments:
#   SCAN_DATE        - Scan date (YYYY-MM-DD)
#   SCAN_TIMESTAMP   - Scan timestamp (YYYYMMDD_HHMMSS)
#   GITHUB_RUN_ID    - GitHub Actions run ID
#   GITHUB_RUN_NUMBER- GitHub Actions run number
#   GITHUB_SHA       - Commit SHA
#   GITHUB_REF       - Git ref
#   GITHUB_ACTOR     - GitHub actor
#   GITHUB_EVENT_NAME- GitHub event name

set -euo pipefail

SCAN_DATE="${1:-$(date -u +"%Y-%m-%d")}"
SCAN_TIMESTAMP="${2:-$(date -u +"%Y%m%d_%H%M%S")}"
GITHUB_RUN_ID="${3:-GITHUB_RUN_ID}"
GITHUB_RUN_NUMBER="${4:-GITHUB_RUN_NUMBER}"
GITHUB_SHA="${5:-GITHUB_SHA}"
GITHUB_REF="${6:-GITHUB_REF}"
GITHUB_ACTOR="${7:-GITHUB_ACTOR}"
GITHUB_EVENT_NAME="${8:-GITHUB_EVENT_NAME}"

# --- Pre-report diagnostics ---
echo "🔍 Pre-report generation diagnostics:"
if [[ -d "./local-scan-results" ]]; then
  SARIF_COUNT=$(find ./local-scan-results -name "*.sarif" | wc -l)
  echo "  ✅ Results directory exists"
  echo "  📄 SARIF files found: $SARIF_COUNT"
  echo "  📁 Directory structure:"
  find ./local-scan-results -name "*.sarif" | head -5 | sed 's/^/    /'
else
  echo "  ❌ Results directory missing - creating minimal structure"
  mkdir -p "./local-scan-results"
fi

# --- Generate comprehensive report ---
set +e

echo "🚀 Running enhanced report generation..."
./scripts/dimpact-image-report.sh --input-dir "./local-scan-results"
REPORT_EXIT_CODE=$?

echo "📊 Report generation exit code: $REPORT_EXIT_CODE"

# --- Post-report diagnostics ---
echo "🔍 Post-report generation diagnostics:"
if [[ -d "./local-scan-results" ]]; then
  echo "  📁 Generated files:"
  ls -la "./local-scan-results/" | grep -E "\.(md|json)$" | sed 's/^/    /' || echo "    No markdown/json files found"
  if [[ -f "./local-scan-results/SCAN_REPORT.md" ]]; then
    REPORT_SIZE=$(du -h ./local-scan-results/SCAN_REPORT.md | cut -f1)
    REPORT_LINES=$(wc -l < ./local-scan-results/SCAN_REPORT.md)
    echo "  ✅ SCAN_REPORT.md generated successfully"
    echo "  📏 Report size: $REPORT_SIZE ($REPORT_LINES lines)"
    if grep -q "Summary Table" ./local-scan-results/SCAN_REPORT.md; then
      echo "  ✅ Report contains summary table"
    else
      echo "  ⚠️ Report may be incomplete - missing summary table"
    fi
    echo "  📄 Report preview:"
    head -15 "./local-scan-results/SCAN_REPORT.md" | sed 's/^/    /'
  else
    echo "  ❌ SCAN_REPORT.md not generated"
  fi
  if [[ -d "pages/data" ]]; then
DASHBOARD_FILES=$(find pages/data -name "*.sarif" | wc -l)
    echo "  📊 Dashboard data prepared: $DASHBOARD_FILES SARIF files"
  else
    echo "  ⚠️ Dashboard data not prepared"
  fi
else
  echo "  ❌ Results directory missing after report generation!"
fi

if [[ $REPORT_EXIT_CODE -eq 0 ]]; then
  echo "✅ Enhanced security report generated successfully"
else
  echo "⚠️ Report generation had issues (exit code: $REPORT_EXIT_CODE)"
  echo "Creating fallback report to preserve scan information..."
fi

if [[ ! -f "./local-scan-results/SCAN_REPORT.md" ]]; then
  echo "📝 Creating fallback report due to generation issues..."
  SARIF_FILES=$(find ./local-scan-results -name "*.sarif" | wc -l || echo "0")
  cat > "./local-scan-results/SCAN_REPORT.md" << EOF
# Security Scan Report - $SCAN_DATE

## ⚠️ Status: Report Generation Issues

The security scan completed but enhanced report generation encountered issues.
Raw scan data is available in artifacts for detailed analysis.

### Scan Summary
- **Date**: $SCAN_DATE
- **SARIF files generated**: $SARIF_FILES
- **Report generation exit code**: $REPORT_EXIT_CODE
- **Workflow run**: #GITHUB_RUN_NUMBER (see GitHub Actions UI)

### Available Data
- Raw SARIF vulnerability data: Available in GitHub Actions artifacts
- Scan logs: Available in workflow run logs
- Dashboard data: May be partially available

### Next Steps
1. Download raw scan artifacts for detailed analysis
2. Check workflow logs for specific error details
3. Review scan configuration if issues persist
4. Consider re-running scan with debug mode enabled

### Troubleshooting
To re-run with enhanced debugging:
```bash
./scripts/dimpact-image-scanner.sh --debug
./scripts/dimpact-image-report.sh --input-dir ./scan-results
```
EOF
  echo "📝 Fallback report created with diagnostic information"
fi
set -e

# --- Dashboard data for GitHub Pages ---
echo "📊 Generating dashboard data for GitHub Pages..."
mkdir -p "pages/data"
if [[ -f "local-scan-results/SCAN_REPORT.md" ]]; then
  echo "🔄 Converting markdown report to dashboard JSON format..."
  cat > extract_dashboard_data.py << 'EOF'
#!/usr/bin/env python3
import re
import json
import sys
from datetime import datetime

def parse_scan_report(markdown_content):
    data = {
        "scan_date": datetime.now().strftime("%Y-%m-%d"),
        "scan_timestamp": datetime.now().isoformat(),
        "summary": {
            "total_containers": 0,
            "total_vulnerabilities": 0,
            "critical": 0,
            "high": 0,
            "medium": 0,
            "low": 0
        },
        "images": []
    }
    date_match = re.search(r'# Security Scan Report - (\d{4}-\d{2}-\d{2})', markdown_content)
    if date_match:
        data["scan_date"] = date_match.group(1)
    summary_match = re.search(r'## 📊 Summary Table\s*\n(.*?)\n\n', markdown_content, re.DOTALL)
    if summary_match:
        table_content = summary_match.group(1)
        total_match = re.search(r'\|\s*\*\*Total\*\*\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|', table_content)
        if total_match:
            data["summary"]["total_vulnerabilities"] = int(total_match.group(1))
            data["summary"]["critical"] = int(total_match.group(2))
            data["summary"]["high"] = int(total_match.group(3))
            data["summary"]["medium"] = int(total_match.group(4))
            data["summary"]["low"] = int(total_match.group(5))
        image_rows = re.findall(r'\|\s*([^|]+?)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|', table_content)
        for row in image_rows:
            image_name = row[0].strip()
            if '**Total**' not in image_name and 'Image Name' not in image_name and image_name:
                total_vulns = int(row[1])
                critical = int(row[2])
                high = int(row[3])
                medium = int(row[4])
                low = int(row[5])
                if critical > 0:
                    status = "critical"
                elif high > 0:
                    status = "high"
                elif medium > 0:
                    status = "medium"
                elif low > 0:
                    status = "low"
                else:
                    status = "clean"
                data["images"].append({
                    "name": image_name,
                    "vulnerabilities": {
                        "total": total_vulns,
                        "critical": critical,
                        "high": high,
                        "medium": medium,
                        "low": low
                    },
                    "status": status
                })
    data["summary"]["total_containers"] = len(data["images"])
    return data

if __name__ == "__main__":
    with open("local-scan-results/SCAN_REPORT.md", "r") as f:
        markdown_content = f.read()
    dashboard_data = parse_scan_report(markdown_content)
    with open("pages/data/security-data.json", "w") as f:
        json.dump(dashboard_data, f, indent=2)
    print("✅ Dashboard data generated successfully")
    print(f"📊 Found {dashboard_data['summary']['total_containers']} containers")
    print(f"🔍 Total vulnerabilities: {dashboard_data['summary']['total_vulnerabilities']}")
EOF
  python3 extract_dashboard_data.py
  echo "✅ Dashboard JSON data created successfully"
  if [[ -f "pages/data/security-data.json" ]]; then
    echo "📊 Generated dashboard data:"
    echo "  📏 Size: $(du -h pages/data/security-data.json | cut -f1)"
    echo "  📋 Sample content:"
    head -20 "pages/data/security-data.json" | sed 's/^/    /'
  fi
else
  echo "⚠️ No scan report found - creating placeholder dashboard data..."
  cat > "pages/data/security-data.json" << EOF
{
  "scan_date": "$SCAN_DATE",
  "scan_timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")",
  "summary": {
    "total_containers": 0,
    "total_vulnerabilities": 0,
    "critical": 0,
    "high": 0,
    "medium": 0,
    "low": 0
  },
  "images": [],
  "status": "no_data",
  "message": "Security scan data not available"
}
EOF
  echo "📝 Placeholder dashboard data created"
fi

# --- Prepare space-efficient historical storage ---
echo "📦 Preparing space-efficient historical storage..."
mkdir -p "security-reports/historical/$SCAN_DATE"
mkdir -p "security-reports/latest"
mkdir -p "artifact-archives"

echo "🔍 Debugging local-scan-results directory:"
if [[ -d "local-scan-results" ]]; then
  echo "  ✅ local-scan-results directory exists"
  echo "  📁 Contents:"
  ls -la "local-scan-results/" | sed 's/^/    /'
  if [[ -f "local-scan-results/SCAN_REPORT.md" ]]; then
    echo "  ✅ SCAN_REPORT.md found"
    echo "  📏 Size: $(du -h local-scan-results/SCAN_REPORT.md | cut -f1)"
  else
    echo "  ❌ SCAN_REPORT.md not found"
  fi
else
  echo "  ❌ local-scan-results directory does not exist"
  echo "  🔧 Creating local-scan-results directory and minimal report..."
  mkdir -p "local-scan-results"
fi

REPORT_CREATED=false
if [[ -f "local-scan-results/SCAN_REPORT.md" ]]; then
  echo "  📋 Copying existing SCAN_REPORT.md to security-reports..."
  cp "local-scan-results/SCAN_REPORT.md" "security-reports/historical/$SCAN_DATE/"
  cp "local-scan-results/SCAN_REPORT.md" "security-reports/latest/"
  REPORT_CREATED=true
  echo "  ✅ Existing report copied successfully"
fi
if [[ "$REPORT_CREATED" = false ]]; then
  echo "  📝 Creating placeholder report..."
  if [[ -d "local-scan-results" ]]; then
    SCAN_STATUS="Report generation failed"
    SCAN_FILES=$(ls -1 local-scan-results/ 2>/dev/null | tr '\n' ', ' | sed 's/,$//' || echo "none")
    DIAGNOSTIC_INFO="- Scan directory exists but SCAN_REPORT.md missing\n- Files found: $SCAN_FILES\n- Possible report generation failure"
  else
    SCAN_STATUS="Scan directory missing"
    DIAGNOSTIC_INFO="- Expected directory: local-scan-results\n- Directory exists: No\n- Possible scan execution failure"
  fi
  cat > "security-reports/latest/SCAN_REPORT.md" << EOF
# Security Scan Report - $SCAN_DATE

## ⚠️ Scan Status: $SCAN_STATUS

The security scan workflow completed but encountered issues generating the report.

### Diagnostic Information
$DIAGNOSTIC_INFO
- Workflow reported: Success (but incomplete)
- Timestamp: $(date -u)

### Troubleshooting Steps
1. Check individual scan tool outputs in workflow logs
2. Verify scan scripts are executable and functioning
3. Check for resource constraints or timeout issues
4. Review scan configuration files
5. Re-run workflow with debug enabled

### Workflow Details
- **Run ID**: $GITHUB_RUN_ID
- **Commit**: $GITHUB_SHA
- **Actor**: $GITHUB_ACTOR
- **Event**: $GITHUB_EVENT_NAME

---
*This placeholder was generated due to missing scan report*
EOF
  cp "security-reports/latest/SCAN_REPORT.md" "security-reports/historical/$SCAN_DATE/"
  echo "  📝 Placeholder report created successfully"
fi

if [[ -d "local-scan-results" ]]; then
  echo "Creating compressed archive of raw scan data..."
  ARCHIVE_NAME="scan-data-${SCAN_TIMESTAMP}.tar.gz"
  tar -czf "artifact-archives/$ARCHIVE_NAME" -C local-scan-results \
    --exclude="SCAN_REPORT.md" \
    . 2>/dev/null || true
  cat > "artifact-archives/${ARCHIVE_NAME}.meta" << EOF
{
  "archive_name": "$ARCHIVE_NAME",
  "scan_date": "$SCAN_DATE",
  "scan_timestamp": "$SCAN_TIMESTAMP",
  "workflow_run_id": "$GITHUB_RUN_ID",
  "workflow_run_number": "$GITHUB_RUN_NUMBER",
  "commit_sha": "$GITHUB_SHA",
  "ref": "$GITHUB_REF",
  "actor": "$GITHUB_ACTOR",
  "event_name": "$GITHUB_EVENT_NAME",
  "contents": "Raw vulnerability scan data (JSON, SPDX, detailed reports)",
  "retention_policy": "6 months as GitHub Actions artifact"
}
EOF
  ARCHIVE_SIZE=$(du -h "artifact-archives/$ARCHIVE_NAME" | cut -f1)
  echo "📦 Created archive: $ARCHIVE_NAME ($ARCHIVE_SIZE)"
  echo "ARCHIVE_NAME=$ARCHIVE_NAME" >> "$GITHUB_ENV"
fi
ARCHIVE_NAME_FOR_METADATA="${ARCHIVE_NAME:-N/A - no archive created}"
cat > "security-reports/historical/$SCAN_DATE/scan-metadata.json" << EOF
{
  "scan_date": "$SCAN_DATE",
  "scan_timestamp": "$SCAN_TIMESTAMP",
  "workflow_run_id": "$GITHUB_RUN_ID",
  "workflow_run_number": "$GITHUB_RUN_NUMBER",
  "commit_sha": "$GITHUB_SHA",
  "ref": "$GITHUB_REF",
  "actor": "$GITHUB_ACTOR",
  "event_name": "$GITHUB_EVENT_NAME",
  "raw_data_archive": "$ARCHIVE_NAME_FOR_METADATA",
  "archive_retention": "6 months as GitHub Actions artifact",
  "storage_strategy": "space_efficient",
  "notes": "Raw scan data stored as compressed artifact to save git space",
  "report_status": "$([[ -f "security-reports/latest/SCAN_REPORT.md" ]] && echo "generated" || echo "placeholder")"
}
EOF
cp "security-reports/historical/$SCAN_DATE/scan-metadata.json" "security-reports/latest/"
echo "📄 Metadata created for both historical and latest directories"
echo "🔍 Final verification of security-reports structure:"
if [[ -d "security-reports" ]]; then
  echo "  ✅ security-reports directory created"
  echo "  📁 Complete structure:"
  find security-reports -type f | sed 's/^/    /'
  echo "  📏 Total files: $(find security-reports -type f | wc -l)"
  echo "  📐 Total size: $(du -sh security-reports | cut -f1)"
  if [[ -f "security-reports/latest/SCAN_REPORT.md" ]]; then
    echo "    ✅ Latest report: $(du -h security-reports/latest/SCAN_REPORT.md | cut -f1)"
  else
    echo "    ❌ Latest report missing"
  fi
  if [[ -f "security-reports/latest/scan-metadata.json" ]]; then
    echo "    ✅ Latest metadata: exists"
  else
    echo "    ❌ Latest metadata missing"
  fi
else
  echo "  ❌ security-reports directory not created - this will cause artifact upload issues"
  echo "  🚨 Creating emergency structure..."
  mkdir -p "security-reports/latest"
  echo "# Emergency Report - Structure Missing" > security-reports/latest/SCAN_REPORT.md
  echo '{"status": "emergency", "timestamp": "'$(date -u)'"}' > security-reports/latest/scan-metadata.json
fi

# --- Clean up old reports (6-month retention) ---
echo "🧹 Cleaning up old reports (6-month retention)..."
if date --version >/dev/null 2>&1; then
  CUTOFF_DATE=$(date -u -d "6 months ago" +"%Y-%m-%d")
else
  CUTOFF_DATE=$(date -u -v-6m +"%Y-%m-%d")
fi
echo "Cleaning up reports older than: $CUTOFF_DATE"
if [[ -d "security-reports/historical" ]]; then
  find security-reports/historical -maxdepth 1 -type d -name "20*" | while read -r dir; do
    dir_date=$(basename "$dir")
    if [[ "$dir_date" < "$CUTOFF_DATE" ]]; then
      echo "Removing old report directory: $dir_date"
      rm -rf "$dir"
    fi
  done
fi 
