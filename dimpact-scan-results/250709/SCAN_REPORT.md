# Container Image Security Scan Report

Generated on: Wed Jul  9 10:44:44 UTC 2025

*This report is generated from SARIF (Static Analysis Results Interchange Format) data*

## 📊 Summary Table

| Image | 🔴 Critical | 🟠 High | 🟡 Medium | 🔵 Low | 🛡️ Suppressed | ❌ Failed |
|-------|------------|---------|-----------|--------|--------------|-----------|
| docker-io-pravega-zookeeper-0-2-15-sha256-c498ebfb76a66f038075e2fa6148528d74d31ca1664f3257fdf82ee779eec9c8 | 16 | 67 | 68 | 72 | 4 | - |
| docker-io-bitnami-kibana-8-6-1-debian-11-r0 | 13 | 88 | 104 | 86 | 4 | - |
| docker-io-bitnami-elasticsearch-8-6-2-debian-11-r0 | 10 | 800 | 2337 | 196 | 5 | - |
| docker-io-lachlanevenson-k8s-kubectl-v1-23-2 | 9 | 56 | 50 | 4 | 2 | - |
| ghcr-io-eugenmayer-kontextwork-converter-1-8-0-sha256-48da70902307f27ad92a27ddf5875310464fd4d4a2f53ce53e1a6f9b3b4c3355 | 8 | 43 | 115 | 176 | 5 | - |
| docker-io-maykinmedia-open-archiefbeheer-latest | 8 | 25 | 90 | 305 | 1 | - |
| docker-io-bitnami-redis-sentinel-7-0-5-debian-11-r24 | 8 | 65 | 68 | 56 | 2 | - |
| docker-io-bitnami-redis-7-0-5-debian-11-r25 | 8 | 65 | 68 | 56 | 2 | - |
| docker-io-bitnami-rabbitmq-3-11-8-debian-11-r0 | 8 | 65 | 77 | 67 | 4 | - |
| docker-io-bitnami-redis-exporter-1-45-0-debian-11-r11 | 7 | 41 | 60 | 54 | 2 | - |
| docker-io-lachlanevenson-k8s-kubectl-v1-25-4-sha256-af5cea3f2e40138df90660c0c073d8b1506fb76c8602a9f48aceb5f4fb052ddc | 6 | 40 | 65 | 5 | 2 | - |
| docker-io-bitnami-elasticsearch-exporter-1-5-0-debian-11-r70 | 6 | 42 | 59 | 54 | 2 | - |
| docker-io-openzaak-open-zaak-latest | 5 | 180 | 507 | 242 | 6 | - |
| docker-io-openformulieren-open-forms-latest | 5 | 20 | 73 | 145 | 5 | - |
| docker-io-nginxinc-nginx-unprivileged-1-28-0-sha256-3e5f030818c3782a35b6f621458a21f3e526a35267b2b4505d225684d5eac7c4 | 5 | 18 | 23 | 65 | 2 | - |
| docker-io-nginx-1-27-4 | 5 | 18 | 23 | 65 | 2 | - |
| docker-io-maykinmedia-open-inwoner-latest | 5 | 183 | 514 | 217 | 5 | - |
| docker-io-maykinmedia-objecttypes-api-latest | 5 | 187 | 516 | 267 | 6 | - |
| docker-io-maykinmedia-objects-api-latest | 5 | 180 | 507 | 243 | 6 | - |
| docker-io-nginxinc-nginx-unprivileged-stable | 4 | 10 | 11 | 63 | 2 | - |
| docker-io-pravega-zookeeper-operator-0-2-15-sha256-b2bc4042fdd8fea6613b04f2f602ba4aff1201e79ba35cd0e2df9f3327111b0e | 3 | 11 | 26 | 0 | 0 | - |
| docker-io-pravega-zookeeper-operator-0-2-15 | 3 | 11 | 26 | 0 | 0 | - |
| docker-io-openzaak-open-notificaties-latest | 3 | 6 | 6 | 50 | 5 | - |
| docker-io-maykinmedia-open-klant-latest | 3 | 6 | 6 | 74 | 5 | - |
| docker-io-bitnami-zookeeper-3-9-3-debian-12-r10 | 3 | 18 | 22 | 49 | 5 | - |
| docker-io-bitnami-postgresql-17-2-0-debian-12-r2 | 3 | 19 | 17 | 49 | 5 | - |
| ghcr-io-brp-api-personen-mock-2-6-0-202502261446 | 2 | 7 | 14 | 45 | 1 | - |
| docker-io-bitnami-postgres-exporter-0-16-0-debian-12-r1 | 2 | 7 | 19 | 36 | 5 | - |
| ghcr-io-klantinteractie-servicesysteem-kiss-frontend-release-1-0-x-20250418091744-8936963 | 1 | 5 | 8 | 35 | 2 | - |
| ghcr-io-klantinteractie-servicesysteem-kiss-elastic-sync-latest | 1 | 4 | 5 | 33 | 2 | - |
| ghcr-io-icatt-menselijk-digitaal-podiumd-adapter-v0-6-x-20250225135230-fc9468b | 1 | 7 | 9 | 35 | 2 | - |
| docker-io-library-solr-9-8-1-sha256-16983468366aaf62417bb6a2a4b703b486b199b8461192df131455071c263916 | 1 | 8 | 31 | 20 | 0 | - |
| docker-io-bitnami-solr-9-8-1-debian-12-r5 | 1 | 10 | 21 | 46 | 5 | - |
| docker-io-bitnami-os-shell-12-debian-12-r42 | 1 | 7 | 15 | 46 | 5 | - |
| docker-io-bitnami-os-shell-12-debian-12-r40 | 1 | 8 | 16 | 46 | 5 | - |
| docker-io-bitnami-os-shell-12-debian-12-r33 | 1 | 8 | 24 | 47 | 5 | - |
| docker-io-bitnami-keycloak-config-cli-6-1-6-debian-12-r6 | 1 | 10 | 15 | 39 | 5 | - |
| docker-io-bitnami-keycloak-26-0-7-debian-12-r0 | 1 | 12 | 31 | 47 | 5 | - |
| ghcr-io-infonl-zaakafhandelcomponent-latest | 0 | 2 | 16 | 44 | 0 | - |
| docker-io-otel-opentelemetry-collector-contrib-0-123-0-sha256-e39311df1f3d941923c00da79ac7ba6269124a870ee87e3c3ad24d60f8aee4d2 | 0 | 1 | 5 | 1 | 0 | - |
| docker-io-openpolicyagent-opa-1-3-0-static-sha256-44f0f4b1c09260eaf5e24fc3931fe10f80cffd13054ef3ef62cef775d5cbd272 | 0 | 2 | 4 | 0 | 0 | - |
| docker-io-curlimages-curl-8-13-0-sha256-d43bdb28bae0be0998f3be83199bfb2b81e0a30b034b6d7586ce7e05de34c3fd | 0 | 0 | 0 | 0 | 0 | - |
| docker-io-clamav-clamav-latest | 0 | 0 | 0 | 0 | 0 | - |
| docker-io-apache-solr-operator-v0-9-1-sha256-4db34508137f185d3cad03c7cf7c2b5d6533fb590822effcde9125cff5a90aa2 | 0 | 0 | 5 | 0 | 0 | - |
| docker-io-apache-solr-operator-v0-9-1 | 0 | 0 | 5 | 0 | 0 | - |
| docker-io-alpine-3-20 | 0 | 0 | 0 | 0 | 0 | - |
| docker-elastic-co-eck-eck-operator-latest | 0 | 1 | 3 | 0 | 0 | - |
| ghcr-io-infonl-zaakafhandelcomponent-3-5-0 | - | - | - | - | - | ❌ |
| docker-io-keycloak-config-cli-latest | - | - | - | - | - | ❌ |
| docker-io-keycloak-25-0-6 | - | - | - | - | - | ❌ |
| docker-io-bitnami-bitnami-shell-11-debian-11-r86 | - | - | - | - | - | ❌ |
| docker-io-bitnami-bitnami-shell-11-debian-11-r78 | - | - | - | - | - | ❌ |
| docker-io-bitnami-bitnami-shell-11-debian-11-r76 | - | - | - | - | - | ❌ |
| docker-io-bitnami-bitnami-shell-11-debian-11-r58 | - | - | - | - | - | ❌ |
|-------|------------|---------|-----------|--------|--------------|-----------|
| **Total** | **178** | **2363** | **5684** | **3180** | **131** | **7** |

## 🚨 Overall Security Status

### Total Vulnerabilities Across All Images
- 🔴 **Critical:** 178
- 🟠 **High:** 2363
- 🟡 **Medium:** 5684
- 🔵 **Low:** 3180
- 🛡️ **Suppressed:** 131
- ❌ **Failed Scans:** 7

## 📝 Image Summary

### docker-io-pravega-zookeeper-0-2-15-sha256-c498ebfb76a66f038075e2fa6148528d74d31ca1664f3257fdf82ee779eec9c8
- **Status:** ✅ Scan Completed
- **Critical:** 16
- **High:** 67
- **Medium:** 68
- **Low:** 72
- **Suppressed:** 4

### docker-io-bitnami-kibana-8-6-1-debian-11-r0
- **Status:** ✅ Scan Completed
- **Critical:** 13
- **High:** 88
- **Medium:** 104
- **Low:** 86
- **Suppressed:** 4

### docker-io-bitnami-elasticsearch-8-6-2-debian-11-r0
- **Status:** ✅ Scan Completed
- **Critical:** 10
- **High:** 800
- **Medium:** 2337
- **Low:** 196
- **Suppressed:** 5

### docker-io-lachlanevenson-k8s-kubectl-v1-23-2
- **Status:** ✅ Scan Completed
- **Critical:** 9
- **High:** 56
- **Medium:** 50
- **Low:** 4
- **Suppressed:** 2

### ghcr-io-eugenmayer-kontextwork-converter-1-8-0-sha256-48da70902307f27ad92a27ddf5875310464fd4d4a2f53ce53e1a6f9b3b4c3355
- **Status:** ✅ Scan Completed
- **Critical:** 8
- **High:** 43
- **Medium:** 115
- **Low:** 176
- **Suppressed:** 5

### docker-io-maykinmedia-open-archiefbeheer-latest
- **Status:** ✅ Scan Completed
- **Critical:** 8
- **High:** 25
- **Medium:** 90
- **Low:** 305
- **Suppressed:** 1

### docker-io-bitnami-redis-sentinel-7-0-5-debian-11-r24
- **Status:** ✅ Scan Completed
- **Critical:** 8
- **High:** 65
- **Medium:** 68
- **Low:** 56
- **Suppressed:** 2

### docker-io-bitnami-redis-7-0-5-debian-11-r25
- **Status:** ✅ Scan Completed
- **Critical:** 8
- **High:** 65
- **Medium:** 68
- **Low:** 56
- **Suppressed:** 2

### docker-io-bitnami-rabbitmq-3-11-8-debian-11-r0
- **Status:** ✅ Scan Completed
- **Critical:** 8
- **High:** 65
- **Medium:** 77
- **Low:** 67
- **Suppressed:** 4

### docker-io-bitnami-redis-exporter-1-45-0-debian-11-r11
- **Status:** ✅ Scan Completed
- **Critical:** 7
- **High:** 41
- **Medium:** 60
- **Low:** 54
- **Suppressed:** 2

### docker-io-lachlanevenson-k8s-kubectl-v1-25-4-sha256-af5cea3f2e40138df90660c0c073d8b1506fb76c8602a9f48aceb5f4fb052ddc
- **Status:** ✅ Scan Completed
- **Critical:** 6
- **High:** 40
- **Medium:** 65
- **Low:** 5
- **Suppressed:** 2

### docker-io-bitnami-elasticsearch-exporter-1-5-0-debian-11-r70
- **Status:** ✅ Scan Completed
- **Critical:** 6
- **High:** 42
- **Medium:** 59
- **Low:** 54
- **Suppressed:** 2

### docker-io-openzaak-open-zaak-latest
- **Status:** ✅ Scan Completed
- **Critical:** 5
- **High:** 180
- **Medium:** 507
- **Low:** 242
- **Suppressed:** 6

### docker-io-openformulieren-open-forms-latest
- **Status:** ✅ Scan Completed
- **Critical:** 5
- **High:** 20
- **Medium:** 73
- **Low:** 145
- **Suppressed:** 5

### docker-io-nginxinc-nginx-unprivileged-1-28-0-sha256-3e5f030818c3782a35b6f621458a21f3e526a35267b2b4505d225684d5eac7c4
- **Status:** ✅ Scan Completed
- **Critical:** 5
- **High:** 18
- **Medium:** 23
- **Low:** 65
- **Suppressed:** 2

### docker-io-nginx-1-27-4
- **Status:** ✅ Scan Completed
- **Critical:** 5
- **High:** 18
- **Medium:** 23
- **Low:** 65
- **Suppressed:** 2

### docker-io-maykinmedia-open-inwoner-latest
- **Status:** ✅ Scan Completed
- **Critical:** 5
- **High:** 183
- **Medium:** 514
- **Low:** 217
- **Suppressed:** 5

### docker-io-maykinmedia-objecttypes-api-latest
- **Status:** ✅ Scan Completed
- **Critical:** 5
- **High:** 187
- **Medium:** 516
- **Low:** 267
- **Suppressed:** 6

### docker-io-maykinmedia-objects-api-latest
- **Status:** ✅ Scan Completed
- **Critical:** 5
- **High:** 180
- **Medium:** 507
- **Low:** 243
- **Suppressed:** 6

### docker-io-nginxinc-nginx-unprivileged-stable
- **Status:** ✅ Scan Completed
- **Critical:** 4
- **High:** 10
- **Medium:** 11
- **Low:** 63
- **Suppressed:** 2

### docker-io-pravega-zookeeper-operator-0-2-15-sha256-b2bc4042fdd8fea6613b04f2f602ba4aff1201e79ba35cd0e2df9f3327111b0e
- **Status:** ✅ Scan Completed
- **Critical:** 3
- **High:** 11
- **Medium:** 26
- **Low:** 0
- **Suppressed:** 0

### docker-io-pravega-zookeeper-operator-0-2-15
- **Status:** ✅ Scan Completed
- **Critical:** 3
- **High:** 11
- **Medium:** 26
- **Low:** 0
- **Suppressed:** 0

### docker-io-openzaak-open-notificaties-latest
- **Status:** ✅ Scan Completed
- **Critical:** 3
- **High:** 6
- **Medium:** 6
- **Low:** 50
- **Suppressed:** 5

### docker-io-maykinmedia-open-klant-latest
- **Status:** ✅ Scan Completed
- **Critical:** 3
- **High:** 6
- **Medium:** 6
- **Low:** 74
- **Suppressed:** 5

### docker-io-bitnami-zookeeper-3-9-3-debian-12-r10
- **Status:** ✅ Scan Completed
- **Critical:** 3
- **High:** 18
- **Medium:** 22
- **Low:** 49
- **Suppressed:** 5

### docker-io-bitnami-postgresql-17-2-0-debian-12-r2
- **Status:** ✅ Scan Completed
- **Critical:** 3
- **High:** 19
- **Medium:** 17
- **Low:** 49
- **Suppressed:** 5

### ghcr-io-brp-api-personen-mock-2-6-0-202502261446
- **Status:** ✅ Scan Completed
- **Critical:** 2
- **High:** 7
- **Medium:** 14
- **Low:** 45
- **Suppressed:** 1

### docker-io-bitnami-postgres-exporter-0-16-0-debian-12-r1
- **Status:** ✅ Scan Completed
- **Critical:** 2
- **High:** 7
- **Medium:** 19
- **Low:** 36
- **Suppressed:** 5

### ghcr-io-klantinteractie-servicesysteem-kiss-frontend-release-1-0-x-20250418091744-8936963
- **Status:** ✅ Scan Completed
- **Critical:** 1
- **High:** 5
- **Medium:** 8
- **Low:** 35
- **Suppressed:** 2

### ghcr-io-klantinteractie-servicesysteem-kiss-elastic-sync-latest
- **Status:** ✅ Scan Completed
- **Critical:** 1
- **High:** 4
- **Medium:** 5
- **Low:** 33
- **Suppressed:** 2

### ghcr-io-icatt-menselijk-digitaal-podiumd-adapter-v0-6-x-20250225135230-fc9468b
- **Status:** ✅ Scan Completed
- **Critical:** 1
- **High:** 7
- **Medium:** 9
- **Low:** 35
- **Suppressed:** 2

### docker-io-library-solr-9-8-1-sha256-16983468366aaf62417bb6a2a4b703b486b199b8461192df131455071c263916
- **Status:** ✅ Scan Completed
- **Critical:** 1
- **High:** 8
- **Medium:** 31
- **Low:** 20
- **Suppressed:** 0

### docker-io-bitnami-solr-9-8-1-debian-12-r5
- **Status:** ✅ Scan Completed
- **Critical:** 1
- **High:** 10
- **Medium:** 21
- **Low:** 46
- **Suppressed:** 5

### docker-io-bitnami-os-shell-12-debian-12-r42
- **Status:** ✅ Scan Completed
- **Critical:** 1
- **High:** 7
- **Medium:** 15
- **Low:** 46
- **Suppressed:** 5

### docker-io-bitnami-os-shell-12-debian-12-r40
- **Status:** ✅ Scan Completed
- **Critical:** 1
- **High:** 8
- **Medium:** 16
- **Low:** 46
- **Suppressed:** 5

### docker-io-bitnami-os-shell-12-debian-12-r33
- **Status:** ✅ Scan Completed
- **Critical:** 1
- **High:** 8
- **Medium:** 24
- **Low:** 47
- **Suppressed:** 5

### docker-io-bitnami-keycloak-config-cli-6-1-6-debian-12-r6
- **Status:** ✅ Scan Completed
- **Critical:** 1
- **High:** 10
- **Medium:** 15
- **Low:** 39
- **Suppressed:** 5

### docker-io-bitnami-keycloak-26-0-7-debian-12-r0
- **Status:** ✅ Scan Completed
- **Critical:** 1
- **High:** 12
- **Medium:** 31
- **Low:** 47
- **Suppressed:** 5

### ghcr-io-infonl-zaakafhandelcomponent-latest
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 2
- **Medium:** 16
- **Low:** 44
- **Suppressed:** 0

### docker-io-otel-opentelemetry-collector-contrib-0-123-0-sha256-e39311df1f3d941923c00da79ac7ba6269124a870ee87e3c3ad24d60f8aee4d2
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 1
- **Medium:** 5
- **Low:** 1
- **Suppressed:** 0

### docker-io-openpolicyagent-opa-1-3-0-static-sha256-44f0f4b1c09260eaf5e24fc3931fe10f80cffd13054ef3ef62cef775d5cbd272
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 2
- **Medium:** 4
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
- **High:** 0
- **Medium:** 5
- **Low:** 0
- **Suppressed:** 0

### docker-io-apache-solr-operator-v0-9-1
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 0
- **Medium:** 5
- **Low:** 0
- **Suppressed:** 0

### docker-io-alpine-3-20
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 0
- **Medium:** 0
- **Low:** 0
- **Suppressed:** 0

### docker-elastic-co-eck-eck-operator-latest
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 1
- **Medium:** 3
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
