# Container Image Security Scan Report

Generated on: Fri Jul 11 11:02:36 UTC 2025

*This report is generated from SARIF (Static Analysis Results Interchange Format) data*

## 📊 Summary Table

| Image | 🔴 Critical | 🟠 High | 🟡 Medium | 🔵 Low | 🛡️ Suppressed | ❌ Failed |
|-------|------------|---------|-----------|--------|--------------|-----------|
| docker-io-pravega-zookeeper-0-2-15 | 16 | 67 | 68 | 72 | 4 | - |
| docker-io-bitnami-kibana-8-6-1-debian-11-r0 | 13 | 88 | 104 | 86 | 4 | - |
| docker-io-bitnami-elasticsearch-8-6-2-debian-11-r0 | 10 | 796 | 2358 | 201 | 5 | - |
| docker-io-lachlanevenson-k8s-kubectl-v1-23-2 | 9 | 56 | 50 | 4 | 2 | - |
| docker-io-maykinmedia-open-archiefbeheer-latest | 8 | 25 | 89 | 305 | 1 | - |
| docker-io-bitnami-redis-sentinel-7-0-5-debian-11-r24 | 8 | 65 | 68 | 56 | 2 | - |
| docker-io-bitnami-redis-7-0-5-debian-11-r25 | 8 | 65 | 68 | 56 | 2 | - |
| docker-io-bitnami-rabbitmq-3-11-8-debian-11-r0 | 8 | 65 | 77 | 67 | 4 | - |
| docker-io-bitnami-redis-exporter-1-45-0-debian-11-r11 | 7 | 41 | 60 | 54 | 2 | - |
| docker-io-lachlanevenson-k8s-kubectl-v1-25-4 | 6 | 40 | 65 | 5 | 2 | - |
| docker-io-bitnami-elasticsearch-exporter-1-5-0-debian-11-r70 | 6 | 42 | 59 | 54 | 2 | - |
| docker-io-openzaak-open-zaak-latest | 5 | 187 | 534 | 243 | 6 | - |
| docker-io-openformulieren-open-forms-latest | 5 | 20 | 76 | 145 | 5 | - |
| docker-io-nginx-1-27-4 | 5 | 18 | 23 | 65 | 2 | - |
| docker-io-maykinmedia-open-inwoner-latest | 5 | 191 | 541 | 218 | 5 | - |
| docker-io-maykinmedia-objecttypes-api-latest | 5 | 187 | 535 | 268 | 6 | - |
| docker-io-maykinmedia-objects-api-latest | 5 | 187 | 534 | 244 | 6 | - |
| docker-io-nginxinc-nginx-unprivileged-stable | 4 | 10 | 11 | 63 | 2 | - |
| docker-io-nginxinc-nginx-unprivileged-1-28-0 | 4 | 10 | 11 | 63 | 2 | - |
| docker-io-pravega-zookeeper-operator-0-2-15 | 3 | 11 | 26 | 0 | 0 | - |
| docker-io-openzaak-open-notificaties-latest | 3 | 6 | 6 | 50 | 5 | - |
| docker-io-maykinmedia-open-klant-latest | 3 | 6 | 6 | 74 | 5 | - |
| docker-io-bitnami-zookeeper-3-9-3-debian-12-r10 | 3 | 18 | 22 | 49 | 5 | - |
| docker-io-bitnami-postgresql-17-2-0-debian-12-r2 | 3 | 19 | 17 | 49 | 5 | - |
| docker-io-bitnami-postgres-exporter-0-16-0-debian-12-r1 | 2 | 7 | 19 | 36 | 5 | - |
| docker-io-library-solr-9-8-1 | 1 | 8 | 21 | 16 | 0 | - |
| docker-io-bitnami-solr-9-8-1-debian-12-r5 | 1 | 10 | 21 | 46 | 5 | - |
| docker-io-bitnami-os-shell-12-debian-12-r42 | 1 | 7 | 15 | 46 | 5 | - |
| docker-io-bitnami-os-shell-12-debian-12-r40 | 1 | 8 | 16 | 46 | 5 | - |
| docker-io-bitnami-os-shell-12-debian-12-r33 | 1 | 8 | 24 | 47 | 5 | - |
| docker-io-bitnami-keycloak-config-cli-6-1-6-debian-12-r6 | 1 | 10 | 15 | 39 | 5 | - |
| docker-io-bitnami-keycloak-26-0-7-debian-12-r0 | 1 | 12 | 31 | 47 | 5 | - |
| docker-io-otel-opentelemetry-collector-contrib-0-123-0 | 0 | 1 | 5 | 1 | 0 | - |
| docker-io-openpolicyagent-opa-1-3-0-static | 0 | 2 | 4 | 0 | 0 | - |
| docker-io-curlimages-curl-8-13-0 | 0 | 0 | 0 | 0 | 0 | - |
| docker-io-clamav-clamav-latest | 0 | 0 | 0 | 0 | 0 | - |
| docker-io-apache-solr-operator-v0-9-1 | 0 | 0 | 5 | 0 | 0 | - |
| docker-io-alpine-3-20 | 0 | 0 | 0 | 0 | 0 | - |
| docker-elastic-co-eck-eck-operator-latest | 0 | 1 | 3 | 0 | 0 | - |
| ghcr-io-klantinteractie-servicesysteem-kiss-frontend-release-1-0-x-20250418091744-8936963 | - | - | - | - | - | ❌ |
| ghcr-io-klantinteractie-servicesysteem-kiss-elastic-sync-latest | - | - | - | - | - | ❌ |
| ghcr-io-infonl-zaakafhandelcomponent-latest | - | - | - | - | - | ❌ |
| ghcr-io-infonl-zaakafhandelcomponent-3-5-0 | - | - | - | - | - | ❌ |
| ghcr-io-icatt-menselijk-digitaal-podiumd-adapter-v0-6-x-20250225135230-fc9468b | - | - | - | - | - | ❌ |
| ghcr-io-eugenmayer-kontextwork-converter-1-8-0 | - | - | - | - | - | ❌ |
| ghcr-io-brp-api-personen-mock-2-6-0-202502261446 | - | - | - | - | - | ❌ |
| docker-io-keycloak-config-cli-latest | - | - | - | - | - | ❌ |
| docker-io-keycloak-25-0-6 | - | - | - | - | - | ❌ |
| docker-io-bitnami-bitnami-shell-11-debian-11-r86 | - | - | - | - | - | ❌ |
| docker-io-bitnami-bitnami-shell-11-debian-11-r78 | - | - | - | - | - | ❌ |
| docker-io-bitnami-bitnami-shell-11-debian-11-r76 | - | - | - | - | - | ❌ |
| docker-io-bitnami-bitnami-shell-11-debian-11-r58 | - | - | - | - | - | ❌ |
|-------|------------|---------|-----------|--------|--------------|-----------|
| **Total** | **161** | **2294** | **5587** | **2815** | **119** | **13** |

## 🚨 Overall Security Status

### Total Vulnerabilities Across All Images
- 🔴 **Critical:** 161
- 🟠 **High:** 2294
- 🟡 **Medium:** 5587
- 🔵 **Low:** 2815
- 🛡️ **Suppressed:** 119
- ❌ **Failed Scans:** 13

## 📝 Image Summary

### docker-io-pravega-zookeeper-0-2-15
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
- **High:** 796
- **Medium:** 2358
- **Low:** 201
- **Suppressed:** 5

### docker-io-lachlanevenson-k8s-kubectl-v1-23-2
- **Status:** ✅ Scan Completed
- **Critical:** 9
- **High:** 56
- **Medium:** 50
- **Low:** 4
- **Suppressed:** 2

### docker-io-maykinmedia-open-archiefbeheer-latest
- **Status:** ✅ Scan Completed
- **Critical:** 8
- **High:** 25
- **Medium:** 89
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

### docker-io-lachlanevenson-k8s-kubectl-v1-25-4
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
- **High:** 187
- **Medium:** 534
- **Low:** 243
- **Suppressed:** 6

### docker-io-openformulieren-open-forms-latest
- **Status:** ✅ Scan Completed
- **Critical:** 5
- **High:** 20
- **Medium:** 76
- **Low:** 145
- **Suppressed:** 5

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
- **High:** 191
- **Medium:** 541
- **Low:** 218
- **Suppressed:** 5

### docker-io-maykinmedia-objecttypes-api-latest
- **Status:** ✅ Scan Completed
- **Critical:** 5
- **High:** 187
- **Medium:** 535
- **Low:** 268
- **Suppressed:** 6

### docker-io-maykinmedia-objects-api-latest
- **Status:** ✅ Scan Completed
- **Critical:** 5
- **High:** 187
- **Medium:** 534
- **Low:** 244
- **Suppressed:** 6

### docker-io-nginxinc-nginx-unprivileged-stable
- **Status:** ✅ Scan Completed
- **Critical:** 4
- **High:** 10
- **Medium:** 11
- **Low:** 63
- **Suppressed:** 2

### docker-io-nginxinc-nginx-unprivileged-1-28-0
- **Status:** ✅ Scan Completed
- **Critical:** 4
- **High:** 10
- **Medium:** 11
- **Low:** 63
- **Suppressed:** 2

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

### docker-io-bitnami-postgres-exporter-0-16-0-debian-12-r1
- **Status:** ✅ Scan Completed
- **Critical:** 2
- **High:** 7
- **Medium:** 19
- **Low:** 36
- **Suppressed:** 5

### docker-io-library-solr-9-8-1
- **Status:** ✅ Scan Completed
- **Critical:** 1
- **High:** 8
- **Medium:** 21
- **Low:** 16
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

### docker-io-otel-opentelemetry-collector-contrib-0-123-0
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 1
- **Medium:** 5
- **Low:** 1
- **Suppressed:** 0

### docker-io-openpolicyagent-opa-1-3-0-static
- **Status:** ✅ Scan Completed
- **Critical:** 0
- **High:** 2
- **Medium:** 4
- **Low:** 0
- **Suppressed:** 0

### docker-io-curlimages-curl-8-13-0
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

### ghcr-io-klantinteractie-servicesysteem-kiss-frontend-release-1-0-x-20250418091744-8936963
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan or result file missing

### ghcr-io-klantinteractie-servicesysteem-kiss-elastic-sync-latest
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan or result file missing

### ghcr-io-infonl-zaakafhandelcomponent-latest
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan or result file missing

### ghcr-io-infonl-zaakafhandelcomponent-3-5-0
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan or result file missing

### ghcr-io-icatt-menselijk-digitaal-podiumd-adapter-v0-6-x-20250225135230-fc9468b
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan or result file missing

### ghcr-io-eugenmayer-kontextwork-converter-1-8-0
- **Status:** ❌ Scan Failed
- **Reason:** Unable to complete vulnerability scan or result file missing

### ghcr-io-brp-api-personen-mock-2-6-0-202502261446
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
