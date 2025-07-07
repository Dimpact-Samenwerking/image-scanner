# Container Image Security Scan Report

Generated on: Sat Jun  7 13:20:55 UTC 2025

## 📊 Summary Table

| Image | 🔴 Critical | 🟠 High | 🟡 Medium | 🔵 Low | 🛡️ Suppressed | ❌ Failed |
|-------|------------|---------|-----------|--------|--------------|-----------|
| ghcr-io-brp-api-personen-mock-2-6-0-202502261446 | 2 | 6 | 34 | 0 | 1 | - |
| docker-io-clamav-clamav-latest | 0 | 0 | 0 | 0 | 0 | - |
| docker-elastic-co-eck-eck-operator-latest | 0 | 0 | 1 | 0 | 0 | - |
|-------|------------|---------|-----------|--------|--------------|-----------|
| **Total** | **2** | **6** | **35** | **0** | **1** | **0** |

## 📝 Detailed Summary

### ghcr-io-brp-api-personen-mock-2-6-0-202502261446
- **Status:** ✅ Scan Completed
- **Critical:** 2
- **High:** 6
- **Medium:** 34
- **Low:** 0
- **Suppressed:** 1

### docker-io-clamav-clamav-latest
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 0
- **Medium:** 0
- **Low:** 0
- **Suppressed:** 0

### docker-elastic-co-eck-eck-operator-latest
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 0
- **Medium:** 1
- **Low:** 0
- **Suppressed:** 0

## 🎯 Recommendations
⚠️ **CRITICAL**: Immediate action required! 2 critical vulnerabilities found.
🔴 **HIGH**: High priority action required! 6 high vulnerabilities found.
🟡 **MEDIUM**: Plan to address 35 medium vulnerabilities.
ℹ️ **SUPPRESSED**: 1 vulnerabilities have been suppressed based on CVE suppressions list.

## 📁 Files Generated
For each scanned image, the following files are generated in its directory:

- `trivy-results.json`: Trivy vulnerability scan results (JSON format)
- `trivy-results.txt`: Trivy vulnerability scan results (text format)
- `grype-results.json`: Grype vulnerability scan results (JSON format)
- `grype-results.txt`: Grype vulnerability scan results (text format)
- `sbom.spdx.json`: Software Bill of Materials (SPDX JSON format)
- `sbom.txt`: Software Bill of Materials (text format)
- `summary.md`: Per-image vulnerability summary
- `vulnerabilities.md`: Detailed vulnerability report
