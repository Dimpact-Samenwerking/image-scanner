# Container Image Security Scan Report

Generated on: Tue Jul  8 13:19:15 UTC 2025

*This report is generated from SARIF (Static Analysis Results Interchange Format) data*

## 📊 Summary Table

| Image | 🔴 Critical | 🟠 High | 🟡 Medium | 🔵 Low | 🛡️ Suppressed | ❌ Failed |
|-------|------------|---------|-----------|--------|--------------|-----------|
| docker-elastic-co-eck-eck-operator-latest | 0 | 1 | 3 | 0 | 0 | - |
|-------|------------|---------|-----------|--------|--------------|-----------|
| **Total** | **0** | **1** | **3** | **0** | **0** | **0** |

## 🚨 Overall Security Status

### Total Vulnerabilities Across All Images
- 🔴 **Critical:** 0
- 🟠 **High:** 1
- 🟡 **Medium:** 3
- 🔵 **Low:** 0
- 🛡️ **Suppressed:** 0
- ❌ **Failed Scans:** 0

## 📝 Image Summary

### docker-elastic-co-eck-eck-operator-latest
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 1
- **Medium:** 3
- **Low:** 0
- **Suppressed:** 0

## 🔍 Detailed CVE Analysis

The following section lists all vulnerabilities found in each image, sorted by severity.

*Data extracted from SARIF (Static Analysis Results Interchange Format) files for standardized vulnerability reporting.*

### 🖼️ docker-elastic-co-eck-eck-operator-latest
**Helm Chart:** docker-elastic-co-eck-eck-operator

#### 🟠 HIGH Vulnerabilities (1)

**CVE:** CVE-2025-22874
**Image:** docker-elastic-co-eck-eck-operator-latest
**Helm Chart:** docker-elastic-co-eck-eck-operator
**Message:** Package: stdlib
**Location:** 
**Reference:** 

---

#### 🟡 MEDIUM Vulnerabilities (3)

**CVE:** CVE-2025-0913
**Image:** docker-elastic-co-eck-eck-operator-latest
**Helm Chart:** docker-elastic-co-eck-eck-operator
**Message:** Package: stdlib
**Location:** 
**Reference:** 

**CVE:** CVE-2025-22871
**Image:** docker-elastic-co-eck-eck-operator-latest
**Helm Chart:** docker-elastic-co-eck-eck-operator
**Message:** Package: stdlib
**Location:** 
**Reference:** 

**CVE:** CVE-2025-4673
**Image:** docker-elastic-co-eck-eck-operator-latest
**Helm Chart:** docker-elastic-co-eck-eck-operator
**Message:** Package: stdlib
**Location:** 
**Reference:** 

---


## 🎯 Recommendations
🔴 **HIGH**: High priority action required! 1 high vulnerabilities found.
🟡 **MEDIUM**: Plan to address 3 medium vulnerabilities.

## 📁 Files Generated
For each scanned image, the following files are generated in its directory:

- `trivy-results.sarif`: Trivy vulnerability scan results (SARIF format)
- `trivy-results.txt`: Trivy vulnerability scan results (text format)
- `sbom.spdx.json`: Software Bill of Materials (SPDX JSON format)
- `sbom.txt`: Software Bill of Materials (text format)
- `summary.md`: Per-image vulnerability summary
- `vulnerabilities.md`: Detailed vulnerability report

### 📊 SARIF Format Benefits
- **Standardized Format**: SARIF (Static Analysis Results Interchange Format) is an industry standard
- **Better Integration**: Compatible with GitHub Security Tab, Azure DevOps, and other platforms
- **Rich Metadata**: Includes detailed location information and rule descriptions
- **Interoperability**: Can be consumed by multiple security tools and dashboards
