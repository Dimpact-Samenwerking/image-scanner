# 🧪 Test Report Workflow Guide

This guide explains how to use the enhanced GitHub workflows that support test reports with sample data.

## ⚠️ Important Notice

**Test data is only created when explicitly requested.** The workflows will only generate test reports when:
- You manually trigger a workflow with test options enabled
- You explicitly choose to run test-only mode

No test data is generated during normal production scans or automated triggers.

## Overview

We've added test report functionality to the existing GitHub workflows, allowing you to:

1. **Generate test reports** using realistic sample vulnerability data
2. **Deploy test dashboards** to GitHub Pages showing sample results
3. **Prototype and validate** report formats without running real scans
4. **Demonstrate the reporting system** to stakeholders

## Available Workflows

### 1. 🧪 Test Report Demo (`test-report-demo.yml`)

**Purpose**: Dedicated workflow for testing report generation and GitHub Pages deployment.

**How to Run**:
1. Go to **Actions** → **🧪 Test Report Demo**
2. Click **Run workflow**
3. Choose whether to deploy to GitHub Pages (default: yes)
4. Click **Run workflow**

**What it does**:
- ✅ Runs the complete test report suite
- ✅ Generates comprehensive security report with sample data
- ✅ Creates test dashboard with 6 realistic scenarios
- ✅ Deploys to GitHub Pages with test mode banner
- ✅ Provides artifact downloads

### 2. 🔒 Container Security Scan (Enhanced)

**Purpose**: Main production workflow now supports test mode parameters.

**How to Run**:
1. Go to **Actions** → **Container Security Scan**
2. Click **Run workflow**
3. Configure test options:
   - **Run test report**: Include test report alongside production scan
   - **Test report only**: Skip production scans, only generate test report
4. Click **Run workflow**

## Test Data Scenarios

The test framework includes 6 realistic scenarios:

| Scenario | Description | Vulnerabilities |
|----------|-------------|-----------------|
| `wordpress-critical` | Critical security issues | 2 critical, 1 high, 1 medium |
| `nginx-high` | High priority patches needed | 2 high, 1 medium, 1 low |
| `mysql-medium` | Medium severity database issues | 3 medium, 1 low |
| `redis-low` | Low severity cache issues | 4 low |
| `postgres-mixed` | Mixed severities + suppressions | Mixed + 2 suppressed CVEs |
| `apache-failed` | Failed scan scenario | No scan results |

## GitHub Pages Integration

When test reports are deployed to GitHub Pages, you'll see:

### 🌐 Enhanced Dashboard
- **Test mode banner**: Orange banner indicating sample data
- **Realistic metrics**: Dashboard populated with test scenario data
- **Interactive elements**: All dashboard features work with test data
- **Link to detailed report**: Direct access to comprehensive test report

### 📋 Test Report Page
- **Formatted HTML report**: Professional vulnerability report layout
- **Complete CVE details**: Individual CVE listings with descriptions
- **Suppression handling**: Demonstrates CVE suppression functionality
- **Navigation**: Easy return to main dashboard

## Usage Examples

### Scenario 1: Demo for Stakeholders (Manual Trigger Required)
```bash
# MANUAL: Run test-only workflow to show capabilities
Actions → Test Report Demo → Run workflow → Run workflow
```
**Result**: Clean test dashboard deployed to GitHub Pages
**Trigger**: Only when manually started

### Scenario 2: Validate Report Changes (Manual Trigger Required)
```bash
# MANUAL: Test report generation alongside production
Actions → Container Security Scan → Run workflow
✅ Run test report: true
✅ Test report only: false
```
**Result**: Both production and test reports generated
**Trigger**: Only when manually started with inputs

### Scenario 3: Development Testing
```bash
# Local testing of report scripts
./scripts/test-report.sh
```
**Result**: Local test report generation and validation

## Output Locations

### GitHub Pages
- **Main Dashboard**: `https://your-org.github.io/image-scanner/`
- **Test Report**: `https://your-org.github.io/image-scanner/reports/SCAN_REPORT.html`
- **Raw Data**: `https://your-org.github.io/image-scanner/data/latest-scan.json`

### Artifacts
- **Complete Test Report**: Downloadable markdown report
- **Test Metadata**: JSON metadata about test execution
- **Dashboard Data**: JSON data used to populate dashboard

## Customization

### Adding New Test Scenarios

1. **Create test data directory**:
   ```bash
   mkdir test-data/sample-scan-results/your-scenario
   ```

2. **Add sample Trivy results**:
   ```bash
   # Create realistic trivy-results.json with CVE data
   ```

3. **Update test script**:
   ```bash
   # Add scenario to scripts/test-report.sh validation
   ```

### Modifying Dashboard

1. **Update dashboard data**: Modify JSON generation in workflow
2. **Add new metrics**: Enhance vulnerability tracking
3. **Custom styling**: Update CSS for test mode indicators

## Best Practices

### 🎯 When to Use Test Mode
- **Development**: Testing report format changes
- **Demonstrations**: Showing capabilities to stakeholders
- **Validation**: Ensuring scripts work correctly
- **Documentation**: Creating examples for users

### ⚠️ Important Notes
- Test mode uses **sample data only** - not real vulnerability information
- Test reports are clearly marked with orange banners
- Real production scans should use the standard workflow
- Test data includes realistic CVE IDs and descriptions

## Troubleshooting

### Test Report Not Generating
```bash
# Check script permissions
chmod +x scripts/test-report.sh
chmod +x scripts/dimpact-image-report.sh

# Validate test data
ls -la test-data/sample-scan-results/*/
```

### GitHub Pages Not Updating
- Ensure workflow has `pages: write` permission
- Check that `github-pages` environment is configured
- Verify main branch is set as Pages source

### Missing Dashboard Data
- Confirm `data/` directory is created in Pages content
- Check JSON syntax in generated dashboard data
- Verify script execution completed successfully

## Support

For issues with test workflows:
1. Check workflow logs in GitHub Actions
2. Validate test data integrity with `scripts/test-report.sh`
3. Review sample data in `test-data/README.md`
4. Test locally before running in GitHub Actions 
