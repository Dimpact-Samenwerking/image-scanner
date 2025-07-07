# Container Image Security Scan Report

Generated on: Fri Jun 27 23:12:08 UTC 2025

*This report is generated from SARIF (Static Analysis Results Interchange Format) data*

## 📊 Summary Table

| Image | 🔴 Critical | 🟠 High | 🟡 Medium | 🔵 Low | 🛡️ Suppressed | ❌ Failed |
|-------|------------|---------|-----------|--------|--------------|-----------|
| docker-io-bitnami-elasticsearch-8-6-2-debian-11-r0 | 846 | 2412 | 267 | 0 | 3 | - |
| docker-io-maykinmedia-objects-api-latest | 244 | 839 | 732 | 0 | 6 | - |
| docker-io-maykinmedia-objecttypes-api-latest | 174 | 551 | 587 | 0 | 6 | - |
| docker-io-maykinmedia-open-inwoner-latest | 171 | 542 | 319 | 0 | 5 | - |
| docker-io-pravega-zookeeper-0-2-15-sha256-c498ebfb76a66f038075e2fa6148528d74d31ca1664f3257fdf82ee779eec9c8 | 170 | 130 | 143 | 0 | 2 | - |
| docker-io-openzaak-open-zaak-latest | 167 | 544 | 502 | 0 | 6 | - |
| docker-io-bitnami-kibana-8-6-1-debian-11-r0 | 159 | 188 | 136 | 0 | 2 | - |
| docker-io-bitnami-redis-7-0-5-debian-11-r25 | 117 | 139 | 99 | 0 | 2 | - |
| docker-io-bitnami-rabbitmq-3-11-8-debian-11-r0 | 113 | 147 | 131 | 0 | 2 | - |
| ghcr-io-eugenmayer-kontextwork-converter-1-8-0-sha256-48da70902307f27ad92a27ddf5875310464fd4d4a2f53ce53e1a6f9b3b4c3355 | 103 | 334 | 501 | 0 | 5 | - |
| docker-io-bitnami-redis-sentinel-7-0-5-debian-11-r24 | 98 | 116 | 99 | 0 | 2 | - |
| docker-io-lachlanevenson-k8s-kubectl-v1-23-2 | 88 | 73 | 7 | 0 | 0 | - |
| docker-io-bitnami-redis-exporter-1-45-0-debian-11-r11 | 73 | 107 | 97 | 0 | 2 | - |
| docker-io-bitnami-elasticsearch-exporter-1-5-0-debian-11-r70 | 70 | 104 | 97 | 0 | 2 | - |
| docker-io-lachlanevenson-k8s-kubectl-v1-25-4-sha256-af5cea3f2e40138df90660c0c073d8b1506fb76c8602a9f48aceb5f4fb052ddc | 68 | 107 | 9 | 0 | 0 | - |
| docker-io-maykinmedia-open-archiefbeheer-latest | 49 | 164 | 814 | 0 | 1 | - |
| docker-io-openformulieren-open-forms-latest | 48 | 148 | 220 | 0 | 5 | - |
| docker-io-bitnami-postgresql-17-2-0-debian-12-r2 | 34 | 34 | 101 | 0 | 5 | - |
| docker-io-bitnami-zookeeper-3-9-3-debian-12-r10 | 31 | 48 | 98 | 0 | 5 | - |
| docker-io-bitnami-keycloak-config-cli-6-1-6-debian-12-r6 | 29 | 36 | 83 | 0 | 5 | - |
| docker-io-nginxinc-nginx-unprivileged-1-28-0-sha256-3e5f030818c3782a35b6f621458a21f3e526a35267b2b4505d225684d5eac7c4 | 27 | 42 | 106 | 0 | 2 | - |
| docker-io-nginx-1-27-4 | 27 | 42 | 106 | 0 | 2 | - |
| docker-io-bitnami-keycloak-26-0-7-debian-12-r0 | 26 | 78 | 112 | 0 | 5 | - |
| docker-io-bitnami-solr-9-8-1-debian-12-r5 | 24 | 44 | 94 | 0 | 5 | - |
| docker-io-openzaak-open-notificaties-latest | 23 | 29 | 97 | 0 | 5 | - |
| docker-io-bitnami-postgres-exporter-0-16-0-debian-12-r1 | 21 | 42 | 74 | 0 | 5 | - |
| docker-io-bitnami-os-shell-12-debian-12-r40 | 20 | 62 | 96 | 0 | 5 | - |
| docker-io-bitnami-os-shell-12-debian-12-r33 | 20 | 94 | 98 | 0 | 5 | - |
| docker-io-bitnami-os-shell-12-debian-12-r42 | 19 | 54 | 96 | 0 | 5 | - |
| docker-io-nginxinc-nginx-unprivileged-stable | 18 | 22 | 101 | 0 | 2 | - |
| docker-io-maykinmedia-open-klant-latest | 16 | 25 | 269 | 0 | 5 | - |
| docker-io-pravega-zookeeper-operator-0-2-15-sha256-b2bc4042fdd8fea6613b04f2f602ba4aff1201e79ba35cd0e2df9f3327111b0e | 15 | 27 | 0 | 0 | 0 | - |
| docker-io-pravega-zookeeper-operator-0-2-15 | 15 | 27 | 0 | 0 | 0 | - |
| ghcr-io-brp-api-personen-mock-2-6-0-202502261446 | 13 | 34 | 84 | 0 | 1 | - |
| docker-io-library-solr-9-8-1-sha256-16983468366aaf62417bb6a2a4b703b486b199b8461192df131455071c263916 | 13 | 52 | 47 | 0 | 0 | - |
| ghcr-io-icatt-menselijk-digitaal-podiumd-adapter-v0-6-x-20250225135230-fc9468b | 12 | 21 | 65 | 0 | 2 | - |
| ghcr-io-klantinteractie-servicesysteem-kiss-frontend-release-1-0-x-20250418091744-8936963 | 10 | 19 | 65 | 0 | 2 | - |
| ghcr-io-klantinteractie-servicesysteem-kiss-elastic-sync-latest | 9 | 14 | 60 | 0 | 2 | - |
| ghcr-io-infonl-zaakafhandelcomponent-latest | 3 | 33 | 81 | 0 | 0 | - |
| docker-io-openpolicyagent-opa-1-3-0-static-sha256-44f0f4b1c09260eaf5e24fc3931fe10f80cffd13054ef3ef62cef775d5cbd272 | 2 | 4 | 0 | 0 | 0 | - |
| docker-io-otel-opentelemetry-collector-contrib-0-123-0-sha256-e39311df1f3d941923c00da79ac7ba6269124a870ee87e3c3ad24d60f8aee4d2 | 1 | 4 | 1 | 0 | 0 | - |
| docker-elastic-co-eck-eck-operator-latest | 1 | 3 | 0 | 0 | 0 | - |
| docker-io-curlimages-curl-8-13-0-sha256-d43bdb28bae0be0998f3be83199bfb2b81e0a30b034b6d7586ce7e05de34c3fd | 0 | 0 | 0 | 0 | 0 | - |
| docker-io-clamav-clamav-latest | 0 | 0 | 0 | 0 | 0 | - |
| docker-io-apache-solr-operator-v0-9-1-sha256-4db34508137f185d3cad03c7cf7c2b5d6533fb590822effcde9125cff5a90aa2 | 0 | 5 | 0 | 0 | 0 | - |
| docker-io-apache-solr-operator-v0-9-1 | 0 | 5 | 0 | 0 | 0 | - |
| docker-io-alpine-3-20 | 0 | 0 | 0 | 0 | 0 | - |
| ghcr-io-infonl-zaakafhandelcomponent-3-5-0 | - | - | - | - | - | ❌ |
| docker-io-keycloak-config-cli-latest | - | - | - | - | - | ❌ |
| docker-io-keycloak-25-0-6 | - | - | - | - | - | ❌ |
| docker-io-bitnami-bitnami-shell-11-debian-11-r86 | - | - | - | - | - | ❌ |
| docker-io-bitnami-bitnami-shell-11-debian-11-r78 | - | - | - | - | - | ❌ |
| docker-io-bitnami-bitnami-shell-11-debian-11-r76 | - | - | - | - | - | ❌ |
| docker-io-bitnami-bitnami-shell-11-debian-11-r58 | - | - | - | - | - | ❌ |
|-------|------------|---------|-----------|--------|--------------|-----------|
| **Total** | **3187** | **7545** | **6694** | **0** | **119** | **7** |

## 🚨 Overall Security Status

### Total Vulnerabilities Across All Images
- 🔴 **Critical:** 3187
- 🟠 **High:** 7545
- 🟡 **Medium:** 6694
- 🔵 **Low:** 0
- 🛡️ **Suppressed:** 119
- ❌ **Failed Scans:** 7

## 📝 Image Summary

### docker-io-bitnami-elasticsearch-8-6-2-debian-11-r0
- **Status:** ✅ Scan Completed
- **Critical:** 846
- **High:** 2412
- **Medium:** 267
- **Low:** 0
- **Suppressed:** 3

### docker-io-maykinmedia-objects-api-latest
- **Status:** ✅ Scan Completed
- **Critical:** 244
- **High:** 839
- **Medium:** 732
- **Low:** 0
- **Suppressed:** 6

### docker-io-maykinmedia-objecttypes-api-latest
- **Status:** ✅ Scan Completed
- **Critical:** 174
- **High:** 551
- **Medium:** 587
- **Low:** 0
- **Suppressed:** 6

### docker-io-maykinmedia-open-inwoner-latest
- **Status:** ✅ Scan Completed
- **Critical:** 171
- **High:** 542
- **Medium:** 319
- **Low:** 0
- **Suppressed:** 5

### docker-io-pravega-zookeeper-0-2-15-sha256-c498ebfb76a66f038075e2fa6148528d74d31ca1664f3257fdf82ee779eec9c8
- **Status:** ✅ Scan Completed
- **Critical:** 170
- **High:** 130
- **Medium:** 143
- **Low:** 0
- **Suppressed:** 2

### docker-io-openzaak-open-zaak-latest
- **Status:** ✅ Scan Completed
- **Critical:** 167
- **High:** 544
- **Medium:** 502
- **Low:** 0
- **Suppressed:** 6

### docker-io-bitnami-kibana-8-6-1-debian-11-r0
- **Status:** ✅ Scan Completed
- **Critical:** 159
- **High:** 188
- **Medium:** 136
- **Low:** 0
- **Suppressed:** 2

### docker-io-bitnami-redis-7-0-5-debian-11-r25
- **Status:** ✅ Scan Completed
- **Critical:** 117
- **High:** 139
- **Medium:** 99
- **Low:** 0
- **Suppressed:** 2

### docker-io-bitnami-rabbitmq-3-11-8-debian-11-r0
- **Status:** ✅ Scan Completed
- **Critical:** 113
- **High:** 147
- **Medium:** 131
- **Low:** 0
- **Suppressed:** 2

### ghcr-io-eugenmayer-kontextwork-converter-1-8-0-sha256-48da70902307f27ad92a27ddf5875310464fd4d4a2f53ce53e1a6f9b3b4c3355
- **Status:** ✅ Scan Completed
- **Critical:** 103
- **High:** 334
- **Medium:** 501
- **Low:** 0
- **Suppressed:** 5

### docker-io-bitnami-redis-sentinel-7-0-5-debian-11-r24
- **Status:** ✅ Scan Completed
- **Critical:** 98
- **High:** 116
- **Medium:** 99
- **Low:** 0
- **Suppressed:** 2

### docker-io-lachlanevenson-k8s-kubectl-v1-23-2
- **Status:** ✅ Scan Completed
- **Critical:** 88
- **High:** 73
- **Medium:** 7
- **Low:** 0
- **Suppressed:** 0

### docker-io-bitnami-redis-exporter-1-45-0-debian-11-r11
- **Status:** ✅ Scan Completed
- **Critical:** 73
- **High:** 107
- **Medium:** 97
- **Low:** 0
- **Suppressed:** 2

### docker-io-bitnami-elasticsearch-exporter-1-5-0-debian-11-r70
- **Status:** ✅ Scan Completed
- **Critical:** 70
- **High:** 104
- **Medium:** 97
- **Low:** 0
- **Suppressed:** 2

### docker-io-lachlanevenson-k8s-kubectl-v1-25-4-sha256-af5cea3f2e40138df90660c0c073d8b1506fb76c8602a9f48aceb5f4fb052ddc
- **Status:** ✅ Scan Completed
- **Critical:** 68
- **High:** 107
- **Medium:** 9
- **Low:** 0
- **Suppressed:** 0

### docker-io-maykinmedia-open-archiefbeheer-latest
- **Status:** ✅ Scan Completed
- **Critical:** 49
- **High:** 164
- **Medium:** 814
- **Low:** 0
- **Suppressed:** 1

### docker-io-openformulieren-open-forms-latest
- **Status:** ✅ Scan Completed
- **Critical:** 48
- **High:** 148
- **Medium:** 220
- **Low:** 0
- **Suppressed:** 5

### docker-io-bitnami-postgresql-17-2-0-debian-12-r2
- **Status:** ✅ Scan Completed
- **Critical:** 34
- **High:** 34
- **Medium:** 101
- **Low:** 0
- **Suppressed:** 5

### docker-io-bitnami-zookeeper-3-9-3-debian-12-r10
- **Status:** ✅ Scan Completed
- **Critical:** 31
- **High:** 48
- **Medium:** 98
- **Low:** 0
- **Suppressed:** 5

### docker-io-bitnami-keycloak-config-cli-6-1-6-debian-12-r6
- **Status:** ✅ Scan Completed
- **Critical:** 29
- **High:** 36
- **Medium:** 83
- **Low:** 0
- **Suppressed:** 5

### docker-io-nginxinc-nginx-unprivileged-1-28-0-sha256-3e5f030818c3782a35b6f621458a21f3e526a35267b2b4505d225684d5eac7c4
- **Status:** ✅ Scan Completed
- **Critical:** 27
- **High:** 42
- **Medium:** 106
- **Low:** 0
- **Suppressed:** 2

### docker-io-nginx-1-27-4
- **Status:** ✅ Scan Completed
- **Critical:** 27
- **High:** 42
- **Medium:** 106
- **Low:** 0
- **Suppressed:** 2

### docker-io-bitnami-keycloak-26-0-7-debian-12-r0
- **Status:** ✅ Scan Completed
- **Critical:** 26
- **High:** 78
- **Medium:** 112
- **Low:** 0
- **Suppressed:** 5

### docker-io-bitnami-solr-9-8-1-debian-12-r5
- **Status:** ✅ Scan Completed
- **Critical:** 24
- **High:** 44
- **Medium:** 94
- **Low:** 0
- **Suppressed:** 5

### docker-io-openzaak-open-notificaties-latest
- **Status:** ✅ Scan Completed
- **Critical:** 23
- **High:** 29
- **Medium:** 97
- **Low:** 0
- **Suppressed:** 5

### docker-io-bitnami-postgres-exporter-0-16-0-debian-12-r1
- **Status:** ✅ Scan Completed
- **Critical:** 21
- **High:** 42
- **Medium:** 74
- **Low:** 0
- **Suppressed:** 5

### docker-io-bitnami-os-shell-12-debian-12-r40
- **Status:** ✅ Scan Completed
- **Critical:** 20
- **High:** 62
- **Medium:** 96
- **Low:** 0
- **Suppressed:** 5

### docker-io-bitnami-os-shell-12-debian-12-r33
- **Status:** ✅ Scan Completed
- **Critical:** 20
- **High:** 94
- **Medium:** 98
- **Low:** 0
- **Suppressed:** 5

### docker-io-bitnami-os-shell-12-debian-12-r42
- **Status:** ✅ Scan Completed
- **Critical:** 19
- **High:** 54
- **Medium:** 96
- **Low:** 0
- **Suppressed:** 5

### docker-io-nginxinc-nginx-unprivileged-stable
- **Status:** ✅ Scan Completed
- **Critical:** 18
- **High:** 22
- **Medium:** 101
- **Low:** 0
- **Suppressed:** 2

### docker-io-maykinmedia-open-klant-latest
- **Status:** ✅ Scan Completed
- **Critical:** 16
- **High:** 25
- **Medium:** 269
- **Low:** 0
- **Suppressed:** 5

### docker-io-pravega-zookeeper-operator-0-2-15-sha256-b2bc4042fdd8fea6613b04f2f602ba4aff1201e79ba35cd0e2df9f3327111b0e
- **Status:** ✅ Scan Completed
- **Critical:** 15
- **High:** 27
- **Medium:** 0
- **Low:** 0
- **Suppressed:** 0

### docker-io-pravega-zookeeper-operator-0-2-15
- **Status:** ✅ Scan Completed
- **Critical:** 15
- **High:** 27
- **Medium:** 0
- **Low:** 0
- **Suppressed:** 0

### ghcr-io-brp-api-personen-mock-2-6-0-202502261446
- **Status:** ✅ Scan Completed
- **Critical:** 13
- **High:** 34
- **Medium:** 84
- **Low:** 0
- **Suppressed:** 1

### docker-io-library-solr-9-8-1-sha256-16983468366aaf62417bb6a2a4b703b486b199b8461192df131455071c263916
- **Status:** ✅ Scan Completed
- **Critical:** 13
- **High:** 52
- **Medium:** 47
- **Low:** 0
- **Suppressed:** 0

### ghcr-io-icatt-menselijk-digitaal-podiumd-adapter-v0-6-x-20250225135230-fc9468b
- **Status:** ✅ Scan Completed
- **Critical:** 12
- **High:** 21
- **Medium:** 65
- **Low:** 0
- **Suppressed:** 2

### ghcr-io-klantinteractie-servicesysteem-kiss-frontend-release-1-0-x-20250418091744-8936963
- **Status:** ✅ Scan Completed
- **Critical:** 10
- **High:** 19
- **Medium:** 65
- **Low:** 0
- **Suppressed:** 2

### ghcr-io-klantinteractie-servicesysteem-kiss-elastic-sync-latest
- **Status:** ✅ Scan Completed
- **Critical:** 9
- **High:** 14
- **Medium:** 60
- **Low:** 0
- **Suppressed:** 2

### ghcr-io-infonl-zaakafhandelcomponent-latest
- **Status:** ✅ Scan Completed
- **Critical:** 3
- **High:** 33
- **Medium:** 81
- **Low:** 0
- **Suppressed:** 0

### docker-io-openpolicyagent-opa-1-3-0-static-sha256-44f0f4b1c09260eaf5e24fc3931fe10f80cffd13054ef3ef62cef775d5cbd272
- **Status:** ✅ Scan Completed
- **Critical:** 2
- **High:** 4
- **Medium:** 0
- **Low:** 0
- **Suppressed:** 0

### docker-io-otel-opentelemetry-collector-contrib-0-123-0-sha256-e39311df1f3d941923c00da79ac7ba6269124a870ee87e3c3ad24d60f8aee4d2
- **Status:** ✅ Scan Completed
- **Critical:** 1
- **High:** 4
- **Medium:** 1
- **Low:** 0
- **Suppressed:** 0

### docker-elastic-co-eck-eck-operator-latest
- **Status:** ✅ Scan Completed
- **Critical:** 1
- **High:** 3
- **Medium:** 0
- **Low:** 0
- **Suppressed:** 0

### docker-io-curlimages-curl-8-13-0-sha256-d43bdb28bae0be0998f3be83199bfb2b81e0a30b034b6d7586ce7e05de34c3fd
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 0
- **Medium:** 0
- **Low:** 0
- **Suppressed:** 0

### docker-io-clamav-clamav-latest
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 0
- **Medium:** 0
- **Low:** 0
- **Suppressed:** 0

### docker-io-apache-solr-operator-v0-9-1-sha256-4db34508137f185d3cad03c7cf7c2b5d6533fb590822effcde9125cff5a90aa2
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 5
- **Medium:** 0
- **Low:** 0
- **Suppressed:** 0

### docker-io-apache-solr-operator-v0-9-1
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 5
- **Medium:** 0
- **Low:** 0
- **Suppressed:** 0

### docker-io-alpine-3-20
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 0
- **Medium:** 0
- **Low:** 0
- **Suppressed:** 0

### ghcr-io-infonl-zaakafhandelcomponent-3-5-0
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan or result file missing

### docker-io-keycloak-config-cli-latest
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan or result file missing

### docker-io-keycloak-25-0-6
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan or result file missing

### docker-io-bitnami-bitnami-shell-11-debian-11-r86
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan or result file missing

### docker-io-bitnami-bitnami-shell-11-debian-11-r78
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan or result file missing

### docker-io-bitnami-bitnami-shell-11-debian-11-r76
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan or result file missing

### docker-io-bitnami-bitnami-shell-11-debian-11-r58
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan or result file missing

## 🔍 Detailed CVE Analysis

The following section lists all vulnerabilities found in each image, sorted by severity.

*Data extracted from SARIF (Static Analysis Results Interchange Format) files for standardized vulnerability reporting.*

### 🖼️ docker-io-bitnami-elasticsearch-8-6-2-debian-11-r0
**Helm Chart:** docker-io-bitnami-elasticsearch-8-6-2-debian-11

#### 🔴 CRITICAL Vulnerabilities (843)

---

#### 🟠 HIGH Vulnerabilities (2412)

---

#### 🟡 MEDIUM Vulnerabilities (267)

---

#### 🛡️ Suppressed Vulnerabilities (3)

- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g-dev
Fixed Version: 
Fixed Version: 5.32.1-4+deb11u4
Installed Version: 1:1.2.11.dfsg-2+deb11u2
Installed Version: 5.32.1-4+deb11u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-maykinmedia-objects-api-latest
**Helm Chart:** docker-io-maykinmedia-objects-api

#### 🔴 CRITICAL Vulnerabilities (238)

---

#### 🟠 HIGH Vulnerabilities (839)

---

#### 🟡 MEDIUM Vulnerabilities (732)

---

#### 🛡️ Suppressed Vulnerabilities (6)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g-dev
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-maykinmedia-objecttypes-api-latest
**Helm Chart:** docker-io-maykinmedia-objecttypes-api

#### 🔴 CRITICAL Vulnerabilities (168)

---

#### 🟠 HIGH Vulnerabilities (551)

---

#### 🟡 MEDIUM Vulnerabilities (587)

---

#### 🛡️ Suppressed Vulnerabilities (6)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g-dev
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-maykinmedia-open-inwoner-latest
**Helm Chart:** docker-io-maykinmedia-open-inwoner

#### 🔴 CRITICAL Vulnerabilities (166)

---

#### 🟠 HIGH Vulnerabilities (542)

---

#### 🟡 MEDIUM Vulnerabilities (319)

---

#### 🛡️ Suppressed Vulnerabilities (5)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-pravega-zookeeper-0-2-15-sha256-c498ebfb76a66f038075e2fa6148528d74d31ca1664f3257fdf82ee779eec9c8
**Helm Chart:** docker-io-pravega-zookeeper-0-2-15-sha256

#### 🔴 CRITICAL Vulnerabilities (168)

---

#### 🟠 HIGH Vulnerabilities (130)

---

#### 🟡 MEDIUM Vulnerabilities (143)

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Fixed Version: 5.32.1-4+deb11u4
Installed Version: 1:1.2.11.dfsg-2+deb11u1
Installed Version: 5.32.1-4+deb11u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-openzaak-open-zaak-latest
**Helm Chart:** docker-io-openzaak-open-zaak

#### 🔴 CRITICAL Vulnerabilities (161)

---

#### 🟠 HIGH Vulnerabilities (544)

---

#### 🟡 MEDIUM Vulnerabilities (502)

---

#### 🛡️ Suppressed Vulnerabilities (6)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g-dev
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-bitnami-kibana-8-6-1-debian-11-r0
**Helm Chart:** docker-io-bitnami-kibana-8-6-1-debian-11

#### 🔴 CRITICAL Vulnerabilities (157)

---

#### 🟠 HIGH Vulnerabilities (188)

---

#### 🟡 MEDIUM Vulnerabilities (136)

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Fixed Version: 5.32.1-4+deb11u4
Installed Version: 1:1.2.11.dfsg-2+deb11u2
Installed Version: 5.32.1-4+deb11u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-bitnami-redis-7-0-5-debian-11-r25
**Helm Chart:** docker-io-bitnami-redis-7-0-5-debian-11

#### 🔴 CRITICAL Vulnerabilities (115)

---

#### 🟠 HIGH Vulnerabilities (139)

---

#### 🟡 MEDIUM Vulnerabilities (99)

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Fixed Version: 5.32.1-4+deb11u4
Installed Version: 1:1.2.11.dfsg-2+deb11u2
Installed Version: 5.32.1-4+deb11u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-bitnami-rabbitmq-3-11-8-debian-11-r0
**Helm Chart:** docker-io-bitnami-rabbitmq-3-11-8-debian-11

#### 🔴 CRITICAL Vulnerabilities (111)

---

#### 🟠 HIGH Vulnerabilities (147)

---

#### 🟡 MEDIUM Vulnerabilities (131)

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Fixed Version: 5.32.1-4+deb11u4
Installed Version: 1:1.2.11.dfsg-2+deb11u2
Installed Version: 5.32.1-4+deb11u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ ghcr-io-eugenmayer-kontextwork-converter-1-8-0-sha256-48da70902307f27ad92a27ddf5875310464fd4d4a2f53ce53e1a6f9b3b4c3355
**Helm Chart:** ghcr-io-eugenmayer-kontextwork-converter-1-8-0-sha256

#### 🔴 CRITICAL Vulnerabilities (98)

---

#### 🟠 HIGH Vulnerabilities (334)

---

#### 🟡 MEDIUM Vulnerabilities (501)

---

#### 🛡️ Suppressed Vulnerabilities (5)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u1
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-bitnami-redis-sentinel-7-0-5-debian-11-r24
**Helm Chart:** docker-io-bitnami-redis-sentinel-7-0-5-debian-11

#### 🔴 CRITICAL Vulnerabilities (96)

---

#### 🟠 HIGH Vulnerabilities (116)

---

#### 🟡 MEDIUM Vulnerabilities (99)

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Fixed Version: 5.32.1-4+deb11u4
Installed Version: 1:1.2.11.dfsg-2+deb11u2
Installed Version: 5.32.1-4+deb11u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-lachlanevenson-k8s-kubectl-v1-23-2
**Helm Chart:** docker-io-lachlanevenson-k8s-kubectl-v1-23

#### 🔴 CRITICAL Vulnerabilities (88)

---

#### 🟠 HIGH Vulnerabilities (73)

---

#### 🟡 MEDIUM Vulnerabilities (7)

---


### 🖼️ docker-io-bitnami-redis-exporter-1-45-0-debian-11-r11
**Helm Chart:** docker-io-bitnami-redis-exporter-1-45-0-debian-11

#### 🔴 CRITICAL Vulnerabilities (71)

---

#### 🟠 HIGH Vulnerabilities (107)

---

#### 🟡 MEDIUM Vulnerabilities (97)

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Fixed Version: 5.32.1-4+deb11u4
Installed Version: 1:1.2.11.dfsg-2+deb11u2
Installed Version: 5.32.1-4+deb11u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-bitnami-elasticsearch-exporter-1-5-0-debian-11-r70
**Helm Chart:** docker-io-bitnami-elasticsearch-exporter-1-5-0-debian-11

#### 🔴 CRITICAL Vulnerabilities (68)

---

#### 🟠 HIGH Vulnerabilities (104)

---

#### 🟡 MEDIUM Vulnerabilities (97)

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Fixed Version: 5.32.1-4+deb11u4
Installed Version: 1:1.2.11.dfsg-2+deb11u2
Installed Version: 5.32.1-4+deb11u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-lachlanevenson-k8s-kubectl-v1-25-4-sha256-af5cea3f2e40138df90660c0c073d8b1506fb76c8602a9f48aceb5f4fb052ddc
**Helm Chart:** docker-io-lachlanevenson-k8s-kubectl-v1-25-4-sha256

#### 🔴 CRITICAL Vulnerabilities (68)

---

#### 🟠 HIGH Vulnerabilities (107)

---

#### 🟡 MEDIUM Vulnerabilities (9)

---


### 🖼️ docker-io-maykinmedia-open-archiefbeheer-latest
**Helm Chart:** docker-io-maykinmedia-open-archiefbeheer

#### 🔴 CRITICAL Vulnerabilities (48)

---

#### 🟠 HIGH Vulnerabilities (164)

---

#### 🟡 MEDIUM Vulnerabilities (814)

---

#### 🛡️ Suppressed Vulnerabilities (1)

- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.11.dfsg-2+deb11u2
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Vulnerability CVE-2023-45853


### 🖼️ docker-io-openformulieren-open-forms-latest
**Helm Chart:** docker-io-openformulieren-open-forms

#### 🔴 CRITICAL Vulnerabilities (43)

---

#### 🟠 HIGH Vulnerabilities (148)

---

#### 🟡 MEDIUM Vulnerabilities (220)

---

#### 🛡️ Suppressed Vulnerabilities (5)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-bitnami-postgresql-17-2-0-debian-12-r2
**Helm Chart:** docker-io-bitnami-postgresql-17-2-0-debian-12

#### 🔴 CRITICAL Vulnerabilities (29)

---

#### 🟠 HIGH Vulnerabilities (34)

---

#### 🟡 MEDIUM Vulnerabilities (101)

---

#### 🛡️ Suppressed Vulnerabilities (5)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u1
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-bitnami-zookeeper-3-9-3-debian-12-r10
**Helm Chart:** docker-io-bitnami-zookeeper-3-9-3-debian-12

#### 🔴 CRITICAL Vulnerabilities (26)

---

#### 🟠 HIGH Vulnerabilities (48)

---

#### 🟡 MEDIUM Vulnerabilities (98)

---

#### 🛡️ Suppressed Vulnerabilities (5)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u1
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-bitnami-keycloak-config-cli-6-1-6-debian-12-r6
**Helm Chart:** docker-io-bitnami-keycloak-config-cli-6-1-6-debian-12

#### 🔴 CRITICAL Vulnerabilities (24)

---

#### 🟠 HIGH Vulnerabilities (36)

---

#### 🟡 MEDIUM Vulnerabilities (83)

---

#### 🛡️ Suppressed Vulnerabilities (5)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u1
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-nginxinc-nginx-unprivileged-1-28-0-sha256-3e5f030818c3782a35b6f621458a21f3e526a35267b2b4505d225684d5eac7c4
**Helm Chart:** docker-io-nginxinc-nginx-unprivileged-1-28-0-sha256

#### 🔴 CRITICAL Vulnerabilities (25)

---

#### 🟠 HIGH Vulnerabilities (42)

---

#### 🟡 MEDIUM Vulnerabilities (106)

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u1
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-nginx-1-27-4
**Helm Chart:** docker-io-nginx-1-27

#### 🔴 CRITICAL Vulnerabilities (25)

---

#### 🟠 HIGH Vulnerabilities (42)

---

#### 🟡 MEDIUM Vulnerabilities (106)

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u1
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-bitnami-keycloak-26-0-7-debian-12-r0
**Helm Chart:** docker-io-bitnami-keycloak-26-0-7-debian-12

#### 🔴 CRITICAL Vulnerabilities (21)

---

#### 🟠 HIGH Vulnerabilities (78)

---

#### 🟡 MEDIUM Vulnerabilities (112)

---

#### 🛡️ Suppressed Vulnerabilities (5)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u1
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-bitnami-solr-9-8-1-debian-12-r5
**Helm Chart:** docker-io-bitnami-solr-9-8-1-debian-12

#### 🔴 CRITICAL Vulnerabilities (19)

---

#### 🟠 HIGH Vulnerabilities (44)

---

#### 🟡 MEDIUM Vulnerabilities (94)

---

#### 🛡️ Suppressed Vulnerabilities (5)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u1
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-openzaak-open-notificaties-latest
**Helm Chart:** docker-io-openzaak-open-notificaties

#### 🔴 CRITICAL Vulnerabilities (18)

---

#### 🟠 HIGH Vulnerabilities (29)

---

#### 🟡 MEDIUM Vulnerabilities (97)

---

#### 🛡️ Suppressed Vulnerabilities (5)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-bitnami-postgres-exporter-0-16-0-debian-12-r1
**Helm Chart:** docker-io-bitnami-postgres-exporter-0-16-0-debian-12

#### 🔴 CRITICAL Vulnerabilities (16)

---

#### 🟠 HIGH Vulnerabilities (42)

---

#### 🟡 MEDIUM Vulnerabilities (74)

---

#### 🛡️ Suppressed Vulnerabilities (5)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u1
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-bitnami-os-shell-12-debian-12-r40
**Helm Chart:** docker-io-bitnami-os-shell-12-debian-12

#### 🔴 CRITICAL Vulnerabilities (15)

---

#### 🟠 HIGH Vulnerabilities (62)

---

#### 🟡 MEDIUM Vulnerabilities (96)

---

#### 🛡️ Suppressed Vulnerabilities (5)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u1
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-bitnami-os-shell-12-debian-12-r33
**Helm Chart:** docker-io-bitnami-os-shell-12-debian-12

#### 🔴 CRITICAL Vulnerabilities (15)

---

#### 🟠 HIGH Vulnerabilities (94)

---

#### 🟡 MEDIUM Vulnerabilities (98)

---

#### 🛡️ Suppressed Vulnerabilities (5)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u1
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-bitnami-os-shell-12-debian-12-r42
**Helm Chart:** docker-io-bitnami-os-shell-12-debian-12

#### 🔴 CRITICAL Vulnerabilities (14)

---

#### 🟠 HIGH Vulnerabilities (54)

---

#### 🟡 MEDIUM Vulnerabilities (96)

---

#### 🛡️ Suppressed Vulnerabilities (5)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u1
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-nginxinc-nginx-unprivileged-stable
**Helm Chart:** docker-io-nginxinc-nginx-unprivileged

#### 🔴 CRITICAL Vulnerabilities (16)

---

#### 🟠 HIGH Vulnerabilities (22)

---

#### 🟡 MEDIUM Vulnerabilities (101)

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-maykinmedia-open-klant-latest
**Helm Chart:** docker-io-maykinmedia-open-klant

#### 🔴 CRITICAL Vulnerabilities (11)

---

#### 🟠 HIGH Vulnerabilities (25)

---

#### 🟡 MEDIUM Vulnerabilities (269)

---

#### 🛡️ Suppressed Vulnerabilities (5)

- **CVE-2023-31484** (CRITICAL) - Package: libperl5.36
- **CVE-2023-31484** (CRITICAL) - Package: perl
- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-31484** (CRITICAL) - Package: perl-modules-5.36
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ docker-io-pravega-zookeeper-operator-0-2-15-sha256-b2bc4042fdd8fea6613b04f2f602ba4aff1201e79ba35cd0e2df9f3327111b0e
**Helm Chart:** docker-io-pravega-zookeeper-operator-0-2-15-sha256

#### 🔴 CRITICAL Vulnerabilities (15)

---

#### 🟠 HIGH Vulnerabilities (27)

---


### 🖼️ docker-io-pravega-zookeeper-operator-0-2-15
**Helm Chart:** docker-io-pravega-zookeeper-operator-0-2

#### 🔴 CRITICAL Vulnerabilities (15)

---

#### 🟠 HIGH Vulnerabilities (27)

---


### 🖼️ ghcr-io-brp-api-personen-mock-2-6-0-202502261446
**Helm Chart:** ghcr-io-brp-api-personen-mock-2-6-0

#### 🔴 CRITICAL Vulnerabilities (12)

---

#### 🟠 HIGH Vulnerabilities (34)

---

#### 🟡 MEDIUM Vulnerabilities (84)

---

#### 🛡️ Suppressed Vulnerabilities (1)

- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.11.dfsg-2+deb11u2
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Vulnerability CVE-2023-45853


### 🖼️ docker-io-library-solr-9-8-1-sha256-16983468366aaf62417bb6a2a4b703b486b199b8461192df131455071c263916
**Helm Chart:** docker-io-library-solr-9-8-1-sha256

#### 🔴 CRITICAL Vulnerabilities (13)

---

#### 🟠 HIGH Vulnerabilities (52)

---

#### 🟡 MEDIUM Vulnerabilities (47)

---


### 🖼️ ghcr-io-icatt-menselijk-digitaal-podiumd-adapter-v0-6-x-20250225135230-fc9468b
**Helm Chart:** ghcr-io-icatt-menselijk-digitaal-podiumd-adapter-v0-6-x-20250225135230

#### 🔴 CRITICAL Vulnerabilities (10)

---

#### 🟠 HIGH Vulnerabilities (21)

---

#### 🟡 MEDIUM Vulnerabilities (65)

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u1
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ ghcr-io-klantinteractie-servicesysteem-kiss-frontend-release-1-0-x-20250418091744-8936963
**Helm Chart:** ghcr-io-klantinteractie-servicesysteem-kiss-frontend-release-1-0-x-20250418091744

#### 🔴 CRITICAL Vulnerabilities (8)

---

#### 🟠 HIGH Vulnerabilities (19)

---

#### 🟡 MEDIUM Vulnerabilities (65)

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u1
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ ghcr-io-klantinteractie-servicesysteem-kiss-elastic-sync-latest
**Helm Chart:** ghcr-io-klantinteractie-servicesysteem-kiss-elastic-sync

#### 🔴 CRITICAL Vulnerabilities (7)

---

#### 🟠 HIGH Vulnerabilities (14)

---

#### 🟡 MEDIUM Vulnerabilities (60)

---

#### 🛡️ Suppressed Vulnerabilities (2)

- **CVE-2023-31484** (CRITICAL) - Package: perl-base
- **CVE-2023-45853** (CRITICAL) - Package: zlib1g
Fixed Version: 
Installed Version: 1:1.2.13.dfsg-1
Installed Version: 5.36.0-7+deb12u2
Link: [CVE-2023-31484](https://avd.aquasec.com/nvd/cve-2023-31484)
Link: [CVE-2023-45853](https://avd.aquasec.com/nvd/cve-2023-45853)
Severity: CRITICAL
Severity: HIGH
Vulnerability CVE-2023-31484
Vulnerability CVE-2023-45853


### 🖼️ ghcr-io-infonl-zaakafhandelcomponent-latest
**Helm Chart:** ghcr-io-infonl-zaakafhandelcomponent

#### 🔴 CRITICAL Vulnerabilities (3)

---

#### 🟠 HIGH Vulnerabilities (33)

---

#### 🟡 MEDIUM Vulnerabilities (81)

---


### 🖼️ docker-io-openpolicyagent-opa-1-3-0-static-sha256-44f0f4b1c09260eaf5e24fc3931fe10f80cffd13054ef3ef62cef775d5cbd272
**Helm Chart:** docker-io-openpolicyagent-opa-1-3-0-static-sha256

#### 🔴 CRITICAL Vulnerabilities (2)

---

#### 🟠 HIGH Vulnerabilities (4)

---


### 🖼️ docker-io-otel-opentelemetry-collector-contrib-0-123-0-sha256-e39311df1f3d941923c00da79ac7ba6269124a870ee87e3c3ad24d60f8aee4d2
**Helm Chart:** docker-io-otel-opentelemetry-collector-contrib-0-123-0-sha256

#### 🔴 CRITICAL Vulnerabilities (1)

---

#### 🟠 HIGH Vulnerabilities (4)

---

#### 🟡 MEDIUM Vulnerabilities (1)

---


### 🖼️ docker-elastic-co-eck-eck-operator-latest
**Helm Chart:** docker-elastic-co-eck-eck-operator

#### 🔴 CRITICAL Vulnerabilities (1)

---

#### 🟠 HIGH Vulnerabilities (3)

---


### 🖼️ docker-io-curlimages-curl-8-13-0-sha256-d43bdb28bae0be0998f3be83199bfb2b81e0a30b034b6d7586ce7e05de34c3fd
**Helm Chart:** docker-io-curlimages-curl-8-13-0-sha256


### 🖼️ docker-io-clamav-clamav-latest
**Helm Chart:** docker-io-clamav-clamav


### 🖼️ docker-io-apache-solr-operator-v0-9-1-sha256-4db34508137f185d3cad03c7cf7c2b5d6533fb590822effcde9125cff5a90aa2
**Helm Chart:** docker-io-apache-solr-operator-v0-9-1-sha256

#### 🟠 HIGH Vulnerabilities (5)

---


### 🖼️ docker-io-apache-solr-operator-v0-9-1
**Helm Chart:** docker-io-apache-solr-operator-v0-9

#### 🟠 HIGH Vulnerabilities (5)

---


### 🖼️ docker-io-alpine-3-20
**Helm Chart:** docker-io-alpine-3


## 🎯 Recommendations
❌ **FAILED SCANS**: 7 images could not be scanned. Please check image accessibility and try again.
⚠️ **CRITICAL**: Immediate action required! 3187 critical vulnerabilities found.
🔴 **HIGH**: High priority action required! 7545 high vulnerabilities found.
🟡 **MEDIUM**: Plan to address 6694 medium vulnerabilities.
ℹ️ **SUPPRESSED**: 119 vulnerabilities have been suppressed based on CVE suppressions list.

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
