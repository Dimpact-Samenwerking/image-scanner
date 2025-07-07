# 🧪 Test Data for Dimpact Image Report Generator

This directory contains sample test data for prototyping and testing the Dimpact Image Report Generator.

## 📁 Directory Structure

```
test-data/
├── README.md                    # This file
├── cve-suppressions.md         # Sample CVE suppressions file
└── sample-scan-results/        # Sample scan results directory
    ├── wordpress-critical/     # High-risk scenario (2 critical CVEs)
    │   └── trivy-results.json
    ├── nginx-high/             # High severity vulnerabilities
    │   └── trivy-results.json
    ├── mysql-medium/           # Medium severity vulnerabilities
    │   └── trivy-results.json
    ├── redis-low/              # Low severity vulnerabilities
    │   └── trivy-results.json
    ├── postgres-mixed/         # Mixed severities + suppressions
    │   └── trivy-results.json
    └── apache-failed/          # Failed scan scenario (no JSON file)
        └── .gitkeep
```

## 🎯 Test Scenarios

### 1. **wordpress-critical** 🔴
- **Critical:** 2 CVEs
- **High:** 1 CVE  
- **Medium:** 1 CVE
- **Low:** 0 CVEs
- **Purpose:** Tests handling of critical vulnerabilities

### 2. **nginx-high** 🟠
- **Critical:** 0 CVEs
- **High:** 2 CVEs
- **Medium:** 1 CVE
- **Low:** 1 CVE
- **Purpose:** Tests high severity vulnerability reporting

### 3. **mysql-medium** 🟡
- **Critical:** 0 CVEs
- **High:** 0 CVEs
- **Medium:** 3 CVEs
- **Low:** 1 CVE
- **Purpose:** Tests medium severity vulnerability handling

### 4. **redis-low** 🔵
- **Critical:** 0 CVEs
- **High:** 0 CVEs
- **Medium:** 0 CVEs
- **Low:** 4 CVEs
- **Purpose:** Tests low severity vulnerability processing

### 5. **postgres-mixed** 🌈
- **Critical:** 1 CVE (1 suppressed)
- **High:** 1 CVE
- **Medium:** 1 CVE
- **Low:** 2 CVEs (1 suppressed)
- **Purpose:** Tests CVE suppression functionality

### 6. **apache-failed** ❌
- **No trivy-results.json file**
- **Purpose:** Tests failed scan handling

## 🛡️ CVE Suppressions

The test includes a sample `cve-suppressions.md` file with:
- `CVE-2023-1234` - Critical PostgreSQL vulnerability (suppressed)
- `CVE-2023-2222` - Low GNU C Library vulnerability (suppressed)

## 🚀 Running Tests

### Quick Test
```bash
# Run with built-in test data
scripts/dimpact-image-report.sh --test
```

### Full Test Suite
```bash
# Run comprehensive test with validation and preview
scripts/test-report.sh
```

### Manual Testing
```bash
# Run with custom test data directory
scripts/dimpact-image-report.sh --output-dir test-data/sample-scan-results --cve-suppressions test-data/cve-suppressions.md
```

## 📊 Expected Results

The test should produce a report with:
- **Total Critical:** 3 (after suppressions)
- **Total High:** 4
- **Total Medium:** 6  
- **Total Low:** 8 (after suppressions)
- **Suppressed:** 2
- **Failed Scans:** 1

### Image Ranking (by critical vulnerabilities):
1. **wordpress-critical** (2 critical)
2. **postgres-mixed** (0 critical after suppression)
3. **nginx-high** (0 critical)
4. **mysql-medium** (0 critical)
5. **redis-low** (0 critical)
6. **apache-failed** (scan failed)

## 🔧 Customizing Test Data

### Adding New Test Scenarios

1. Create a new directory under `sample-scan-results/`
2. Add a `trivy-results.json` file with valid Trivy output format
3. Include various severity levels as needed
4. Update this README with the new scenario

### Modifying CVE Suppressions

Edit `cve-suppressions.md` and add CVE IDs in the markdown table format:

```markdown
| CVE-2023-XXXX | Reason for suppression | Date | Review Date |
```

### JSON Structure

Each `trivy-results.json` should follow this structure:

```json
{
  "SchemaVersion": 2,
  "ArtifactName": "image:tag",
  "ArtifactType": "container_image",
  "Results": [
    {
      "Target": "image:tag (OS)",
      "Class": "os-pkgs",
      "Type": "debian|ubuntu|alpine",
      "Vulnerabilities": [
        {
          "VulnerabilityID": "CVE-YYYY-XXXX",
          "PkgName": "package-name",
          "PkgVersion": "version",
          "FixedVersion": "fixed-version",
          "Severity": "CRITICAL|HIGH|MEDIUM|LOW",
          "Title": "Vulnerability title",
          "Description": "Detailed description",
          "References": ["https://cve.mitre.org/..."]
        }
      ]
    }
  ]
}
```

## 📝 Validation

The test suite automatically validates:
- ✅ JSON syntax correctness
- ✅ Required file structure
- ✅ CVE suppression file format
- ✅ Failed scan scenario (missing files)
- ✅ Report generation success
- ✅ Output file creation

## 🎓 Learning Objectives

This test framework helps understand:
- How vulnerability severity affects prioritization
- CVE suppression workflows
- Failed scan handling
- Report formatting and structure
- Helm chart name extraction patterns
- Security metrics aggregation

## 🔍 Troubleshooting

### Common Issues

1. **jq not found**: Install jq (`brew install jq` on macOS)
2. **Invalid JSON**: Validate JSON files with `jq . filename.json`
3. **Missing files**: Ensure all test scenario directories exist
4. **Permission errors**: Make scripts executable with `chmod +x`

### Debug Mode

Add debugging to the report script by modifying the jq commands:
```bash
# Add 2>/dev/null to suppress errors, or remove to see detailed errors
jq -r 'query' file.json 2>/dev/null
``` 
