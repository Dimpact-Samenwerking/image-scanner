# Container Image Security Scan Report

Generated on: Sun Jun  8 09:25:11 UTC 2025

## 📊 Summary Table

| Image | 🔴 Critical | 🟠 High | 🟡 Medium | 🔵 Low | 🛡️ Suppressed | ❌ Failed |
|-------|------------|---------|-----------|--------|--------------|-----------|
| wordpress-critical | 2 | 1 | 1 | 0 | 0 | - |
| postgres-mixed | 1 | 1 | 1 | 2 | 2 | - |
| redis-low | 0 | 0 | 0 | 4 | 0 | - |
| nginx-high | 0 | 2 | 1 | 1 | 0 | - |
| mysql-medium | 0 | 0 | 3 | 1 | 0 | - |
| apache-failed | - | - | - | - | - | ❌ |
|-------|------------|---------|-----------|--------|--------------|-----------|
| **Total** | **3** | **4** | **6** | **8** | **2** | **1** |

## 🚨 Overall Security Status

### Total Vulnerabilities Across All Images
- 🔴 **Critical:** 3
- 🟠 **High:** 4
- 🟡 **Medium:** 6
- 🔵 **Low:** 8
- 🛡️ **Suppressed:** 2
- ❌ **Failed Scans:** 1

## 📝 Image Summary

### wordpress-critical
- **Status:** ✅ Scan Completed
- **Critical:** 2
- **High:** 1
- **Medium:** 1
- **Low:** 0
- **Suppressed:** 0

### postgres-mixed
- **Status:** ✅ Scan Completed
- **Critical:** 1
- **High:** 1
- **Medium:** 1
- **Low:** 2
- **Suppressed:** 2

### redis-low
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 0
- **Medium:** 0
- **Low:** 4
- **Suppressed:** 0

### nginx-high
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 2
- **Medium:** 1
- **Low:** 1
- **Suppressed:** 0

### mysql-medium
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 0
- **Medium:** 3
- **Low:** 1
- **Suppressed:** 0

### apache-failed
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan

## 🔍 Detailed CVE Analysis

The following section lists all vulnerabilities found in each image, sorted by severity.

### 🖼️ wordpress-critical
**Helm Chart:** wordpress

#### 🔴 CRITICAL Vulnerabilities (2)

**CVE:** CVE-2023-4321
**Image:** wordpress-critical
**Helm Chart:** wordpress
**Title:** SSL Library Buffer Overflow
**Fix:** 1.1.1n-0+deb11u4
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-4321
**Description:** Buffer overflow vulnerability in SSL library that can lead to arbitrary code execution when processing specially crafted SSL handshakes....

**CVE:** CVE-2023-5678
**Image:** wordpress-critical
**Helm Chart:** wordpress
**Title:** OpenSSL Remote Code Execution Vulnerability
**Fix:** 1.1.1n-0+deb11u4
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-5678
**Description:** A critical vulnerability in OpenSSL that allows remote code execution through malformed certificates. This vulnerability can be exploited by attackers to gain full control of the system....

---

#### 🟠 HIGH Vulnerabilities (1)

**CVE:** CVE-2023-3456
**Image:** wordpress-critical
**Helm Chart:** wordpress
**Title:** Curl Authentication Bypass
**Fix:** 7.74.0-1.3+deb11u7
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-3456
**Description:** Authentication bypass vulnerability in curl that allows attackers to access protected resources without proper credentials....

---

#### 🟡 MEDIUM Vulnerabilities (1)

**CVE:** CVE-2023-2345
**Image:** wordpress-critical
**Helm Chart:** wordpress
**Title:** GNU C Library Memory Corruption
**Fix:** 2.31-13+deb11u4
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-2345
**Description:** Memory corruption vulnerability in GNU C Library that may lead to denial of service or information disclosure....

---


### 🖼️ postgres-mixed
**Helm Chart:** postgres

#### 🟠 HIGH Vulnerabilities (1)

**CVE:** CVE-2023-5555
**Image:** postgres-mixed
**Helm Chart:** postgres
**Title:** PostgreSQL Client Authentication Bypass
**Fix:** 14.7-1.pgdg110+1
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-5555
**Description:** Authentication bypass vulnerability in PostgreSQL client library that allows unauthorized access under specific conditions....

---

#### 🟡 MEDIUM Vulnerabilities (1)

**CVE:** CVE-2023-4444
**Image:** postgres-mixed
**Helm Chart:** postgres
**Title:** OpenSSL Cipher Weakness
**Fix:** 1.1.1n-0+deb11u5
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-4444
**Description:** Medium severity vulnerability in OpenSSL related to cipher strength that may allow cryptographic attacks....

---

#### 🔵 LOW Vulnerabilities (1)

**CVE:** CVE-2023-3333
**Image:** postgres-mixed
**Helm Chart:** postgres
**Title:** GCC Base Package Minor Issue
**Fix:** 
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-3333
**Description:** Minor vulnerability in GCC base package with very low security impact and limited exploit potential....

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-1234** (CRITICAL) - PostgreSQL SQL Injection
- **CVE-2023-2222** (LOW) - GNU C Library Information Disclosure


### 🖼️ redis-low
**Helm Chart:** redis

#### 🔵 LOW Vulnerabilities (4)

**CVE:** CVE-2023-6345
**Image:** redis-low
**Helm Chart:** redis
**Title:** Alpine Base Layout Minor Issue
**Fix:** 
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-6345
**Description:** Minor issue in Alpine base layout that has minimal security impact and requires local access to exploit....

**CVE:** CVE-2023-7234
**Image:** redis-low
**Helm Chart:** redis
**Title:** Redis Configuration Exposure
**Fix:** 7.0.8-r0
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-7234
**Description:** Low severity vulnerability in Redis that may expose configuration details through debug commands when debug mode is enabled....

**CVE:** CVE-2023-8123
**Image:** redis-low
**Helm Chart:** redis
**Title:** Musl C Library Edge Case
**Fix:** 1.2.3-r2
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-8123
**Description:** Edge case vulnerability in musl C library that may cause minor issues in very specific usage scenarios....

**CVE:** CVE-2023-9012
**Image:** redis-low
**Helm Chart:** redis
**Title:** BusyBox Minor Information Disclosure
**Fix:** 1.35.0-r18
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-9012
**Description:** Minor information disclosure vulnerability in BusyBox that may leak limited system information through error messages....

---


### 🖼️ nginx-high
**Helm Chart:** nginx

#### 🟠 HIGH Vulnerabilities (2)

**CVE:** CVE-2023-6789
**Image:** nginx-high
**Helm Chart:** nginx
**Title:** PCRE Regular Expression DoS
**Fix:** 2:8.39-13ubuntu0.22.04.2
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-6789
**Description:** Denial of service vulnerability in PCRE library through specially crafted regular expressions that can cause excessive CPU consumption....

**CVE:** CVE-2023-7890
**Image:** nginx-high
**Helm Chart:** nginx
**Title:** Nginx HTTP Request Smuggling
**Fix:** 1.21.6-2~bullseye
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-7890
**Description:** HTTP request smuggling vulnerability in nginx that allows attackers to bypass security controls and access restricted resources....

---

#### 🟡 MEDIUM Vulnerabilities (1)

**CVE:** CVE-2023-5432
**Image:** nginx-high
**Helm Chart:** nginx
**Title:** Zlib Compression Vulnerability
**Fix:** 1:1.2.11.dfsg-2ubuntu9.3
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-5432
**Description:** Vulnerability in zlib compression library that may lead to information disclosure through decompression attacks....

---

#### 🔵 LOW Vulnerabilities (1)

**CVE:** CVE-2023-4321
**Image:** nginx-high
**Helm Chart:** nginx
**Title:** Bash Command Injection
**Fix:** 5.1-6ubuntu2
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-4321
**Description:** Minor command injection vulnerability in bash that requires local access and specific conditions to exploit....

---


### 🖼️ mysql-medium
**Helm Chart:** mysql

#### 🟡 MEDIUM Vulnerabilities (3)

**CVE:** CVE-2023-6723
**Image:** mysql-medium
**Helm Chart:** mysql
**Title:** OpenSSL Certificate Validation
**Fix:** 1.1.1f-1ubuntu2.19
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-6723
**Description:** Certificate validation vulnerability in OpenSSL that may allow man-in-the-middle attacks under specific configurations....

**CVE:** CVE-2023-7812
**Image:** mysql-medium
**Helm Chart:** mysql
**Title:** MySQL Client Library Buffer Overflow
**Fix:** 8.0.33-0ubuntu0.20.04.1
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-7812
**Description:** Buffer overflow vulnerability in MySQL client library that can be exploited through malformed server responses....

**CVE:** CVE-2023-8901
**Image:** mysql-medium
**Helm Chart:** mysql
**Title:** MySQL Privilege Escalation
**Fix:** 8.0.33-0ubuntu0.20.04.1
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-8901
**Description:** Privilege escalation vulnerability in MySQL server that allows authenticated users to gain elevated privileges under specific conditions....

---

#### 🔵 LOW Vulnerabilities (1)

**CVE:** CVE-2023-5634
**Image:** mysql-medium
**Helm Chart:** mysql
**Title:** Systemd Service Manipulation
**Fix:** 245.4-4ubuntu3.21
**Reference:** https://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2023-5634
**Description:** Low impact vulnerability in systemd that allows local users to manipulate service states under certain conditions....

---


## 🎯 Recommendations
❌ **FAILED SCANS**: 1 images could not be scanned. Please check image accessibility and try again.
⚠️ **CRITICAL**: Immediate action required! 3 critical vulnerabilities found.
🔴 **HIGH**: High priority action required! 4 high vulnerabilities found.
🟡 **MEDIUM**: Plan to address 6 medium vulnerabilities.
🟢 **LOW**: Consider addressing 8 low vulnerabilities.
ℹ️ **SUPPRESSED**: 2 vulnerabilities have been suppressed based on CVE suppressions list.

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
