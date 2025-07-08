# Container Image Configuration Examples

This document provides examples of how to use the YAML-based container image configuration system.

## 📁 Configuration File: `container-images.yaml`

The main configuration file contains all available container images:

```yaml
images:
  - name: "SIDP Celery"
    repository: "ghcr.io/sunningdale-it/sidp-celery"
    tag: "latest"
    description: "SIDP Celery worker container"
    
  - name: "BRP Personen Mock"
    repository: "ghcr.io/brp-api/personen-mock"
    tag: "2.6.0-202502261446"
    description: "BRP Personen Mock service from Dimpact Helm charts"
```

## 🎯 Workflow Usage Examples

### Scan All Images (Default)
Leave the `images_to_scan` field **empty** when running the workflow manually.

### Scan Specific Images by Name
Enter comma-separated image names in the `images_to_scan` field:

```
SIDP Celery, SIDP Web, Keycloak
```

### Scan Specific Images by Repository
You can also use the exact repository names:

```
ghcr.io/sunningdale-it/sidp-celery, keycloak
```

### Mixed Selection
Combine names and repositories:

```
SIDP Celery, ghcr.io/brp-api/personen-mock, Nginx
```

## 📝 Adding New Images

To add a new container image to the configuration:

1. **Edit `container-images.yaml`**:
   ```yaml
   images:
     - name: "My Custom App"
       repository: "myregistry.io/my-app"
       tag: "v1.2.3"
       description: "My custom application container"
   ```

2. **Validate YAML syntax**:
   ```bash
   yq '.' container-images.yaml
   ```

3. **Image is immediately available** for scanning in the workflow

## 🔍 Image Discovery

### List All Available Images
```bash
yq eval '.images[] | "• " + .name + ": " + .repository + ":" + .tag' container-images.yaml
```

### Find Images by Pattern
```bash
# Find all SIDP images
yq eval '.images[] | select(.name | contains("SIDP")) | "• " + .name + ": " + .repository + ":" + .tag' container-images.yaml

# Find all latest tags
yq eval '.images[] | select(.tag == "latest") | "• " + .name + ": " + .repository + ":" + .tag' container-images.yaml
```

### Search by Repository
```bash
# Find all GitHub Container Registry images
yq eval '.images[] | select(.repository | contains("ghcr.io")) | "• " + .name + ": " + .repository + ":" + .tag' container-images.yaml
```

## 🏷️ Naming Conventions

### Image Names (for user selection)
- Use descriptive, human-readable names
- Follow title case: "SIDP Celery", "BRP Personen Mock"
- Keep names concise but clear
- Use spaces for readability

### Repository Names
- Use full registry paths: `ghcr.io/owner/image`
- For Docker Hub: just the image name or `owner/image`
- Always include the registry for private registries

### Tags
- Use specific versions when possible: `v1.2.3`, `2.6.0-202502261446`
- Use `latest` only for development/testing images
- Consider using semantic versioning tags

## 🔄 Image Sources

### Current Image Sources

1. **SIDP Platform Images**
   - Source: Sunningdale IT GitHub Container Registry
   - Pattern: `ghcr.io/sunningdale-it/sidp-*:latest`

2. **Dimpact Helm Charts Images**
   - Source: [Dimpact-Samenwerking/helm-charts](https://github.com/Dimpact-Samenwerking/helm-charts)
   - Various registries and tags based on chart requirements

### Adding Images from New Sources

When adding images from a new Helm chart or application:

1. **Analyze the source** (Helm values, Docker Compose, etc.)
2. **Extract image references** (repository + tag combinations)
3. **Add to YAML** with descriptive names and source documentation
4. **Test scanning** with a small subset first

## ⚠️ Best Practices

### Security
- **Review public images** carefully before adding
- **Use specific tags** instead of `latest` for production images
- **Document image sources** in the description field

### Maintenance
- **Regular updates**: Keep tags current with latest secure versions
- **Remove deprecated images**: Clean up unused or obsolete images
- **Group by purpose**: Organize images logically (platform, monitoring, etc.)

### Performance
- **Selective scanning**: Don't scan all images every time in development
- **Prioritize critical images**: Scan production images more frequently
- **Monitor scan duration**: Large image lists may hit GitHub Actions limits

## 🚨 Troubleshooting

### Common Issues

**Image not found**:
```
⚠️ Warning: Image 'My Image' not found in configuration
```
- Check spelling of image name
- Verify the image exists in `container-images.yaml`
- Try using the repository name instead

**No images selected**:
```
❌ No valid images found for scanning!
```
- Check that `container-images.yaml` exists
- Verify YAML syntax is valid
- Ensure at least one image matches your selection

**YAML syntax error**:
```
❌ container-images.yaml file not found!
```
- Ensure the file exists in the repository root
- Validate YAML syntax with `yq '.' container-images.yaml`
- Check for missing commas or brackets

### Debugging

**List available images during workflow**:
The workflow automatically displays available images when run, showing the current configuration.

**Test locally**:
```bash
# Test image selection logic
SELECTED="SIDP Celery,Keycloak"
IFS=',' read -ra SELECTED_ARRAY <<< "$SELECTED"
for selected in "${SELECTED_ARRAY[@]}"; do
  selected=$(echo "$selected" | xargs)  # trim whitespace
  yq eval '.images[] | select(.name == "'"$selected"'") | .repository + ":" + .tag' container-images.yaml
done
```

---

**Need help?** Check the [main documentation](docs/CONTAINER_SCANNING_GUIDE.md) or create an issue in the repository. 

# Container Configuration Examples & Usage Guide

This comprehensive guide shows you how to configure and use the Container Image Security Scanner for various scenarios.

## 📋 Vulnerability Summary Table

The scanner now generates a comprehensive **Vulnerability Summary Table** at the top of each security report, providing a clear overview of security findings across all scanned containers:

### What the Table Shows

| Container Image | 🔴 Critical | 🟠 High | 🟡 Medium | 🔵 Low | Total |
|-----------------|-------------|---------|-----------|--------|-------|
| `ghcr.io/example/app:latest` | 2 | 8 | 15 | 23 | **48** |
| `docker.io/library/nginx:1.27.4` | 0 | 1 | 3 | 7 | **11** |
| **TOTAL** | **2** | **9** | **18** | **30** | **59** |

### Benefits

- **Quick Overview**: See security posture of all containers at a glance
- **Risk Prioritization**: Identify which containers need immediate attention
- **Trend Tracking**: Compare vulnerability counts across scans over time
- **Compliance Reporting**: Easy to extract summary data for security reports
- **Team Communication**: Share high-level findings with stakeholders

The table is followed by detailed statistics and risk assessments to help you prioritize remediation efforts.

## 📋 CVE Checklist - Action-Oriented Security Review

Following the summary table, the scanner generates a comprehensive **CVE Checklist** that provides actionable details for each vulnerability found across all containers.

### What the CVE Checklist Includes

```markdown
## 📋 CVE Checklist - All Vulnerabilities

### Critical & High Severity CVEs

- [ ] **CVE-2024-1234** (CRITICAL) in `ghcr.io/example/app:latest`
  - **Issue**: Buffer overflow in authentication module allows remote code execution
  - **Package**: libssl1.1 (1.1.1f-1ubuntu2)
  - **Fix**: Update to 1.1.1f-1ubuntu2.22 or later

- [ ] **CVE-2024-5678** (HIGH) in `docker.io/library/nginx:1.27.4`
  - **Issue**: HTTP request smuggling vulnerability in proxy module
  - **Package**: nginx-core (1.27.4-1)
  - **Fix**: Update to 1.27.5 or later

### Medium Severity CVEs
<details>
<summary>Click to expand medium severity vulnerabilities (15 total)</summary>

- [ ] **CVE-2024-9012** (Medium) in `ghcr.io/example/app:latest`
  - **Issue**: Information disclosure through verbose error messages
  - **Package**: python3.9 (3.9.2-1)
  - **Fix**: Update to 3.9.2-3

</details>

### 📊 CVE Summary
- **Critical & High Priority CVEs**: 8 (require immediate attention)
- **Medium Priority CVEs**: 15 (plan for next maintenance window)
- **Total Unique CVEs**: 23

**Action Items:**
- [ ] Review and prioritize critical/high CVEs above
- [ ] Create tracking issues for CVEs requiring fixes
- [ ] Update affected packages where fixes are available
- [ ] Schedule follow-up scan after remediation
```

### Key Features

- **Checkbox Format**: Each CVE is a checkable task for tracking remediation progress
- **Container Context**: Shows exactly which container image is affected
- **Concise Descriptions**: One-line summaries of security issues
- **Clear Fix Instructions**: Specific version updates or remediation steps
- **Prioritized Layout**: Critical/High CVEs prominently displayed, Medium CVEs collapsible
- **Progress Tracking**: Use checkboxes to mark completed remediation tasks

### How to Use the CVE Checklist

1. **Immediate Attention**: Focus on Critical & High severity CVEs first
2. **Create Issues**: Copy CVE entries to your issue tracker for remediation planning
3. **Track Progress**: Check off completed items as you apply fixes
4. **Plan Maintenance**: Use Medium severity section for maintenance window planning
5. **Verify Fixes**: Re-run scanner after updates to confirm vulnerability resolution

This actionable format makes it easy to:
- **Assign Tasks**: Each CVE can be assigned to team members
- **Track Status**: Visual progress through checkbox completion
- **Communicate**: Share clear, specific remediation requirements
- **Prioritize Work**: Severity-based organization guides effort allocation

---
