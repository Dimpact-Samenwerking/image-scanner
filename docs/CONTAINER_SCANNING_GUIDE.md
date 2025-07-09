# Container Image Security Scanning Guide

This repository provides a comprehensive container image security scanning solution using GitHub Actions and industry-standard open-source tools.

## 🔍 Overview

The scanning workflow uses multiple tools to provide comprehensive vulnerability detection:

- **Trivy**: Comprehensive vulnerability scanner for containers and other artifacts
- **Grype**: Fast vulnerability scanner for container images and filesystems
- **Syft**: Software Bill of Materials (SBOM) generator
- **Docker Scout**: Docker's native security scanning (when available)

## 🚀 Quick Start

### Manual Scan

1. Go to the **Actions** tab in your GitHub repository
2. Select **Container Image Security Scan**
3. Click **Run workflow**
4. Optionally modify the list of images to scan
5. Configure severity threshold and failure behavior
6. Click **Run workflow**

### Default Images

The workflow comes pre-configured with these images:
```
ghcr.io/sunningdale-it/sidp-celery:latest
ghcr.io/sunningdale-it/sidp-web:latest
ghcr.io/sunningdale-it/sidp-celery-beat:latest
ghcr.io/sunningdale-it/sidp-flower:latest
ghcr.io/sunningdale-it/sidp-test:latest
```

## ⚙️ Configuration Options

### Workflow Inputs

| Input | Description | Default | Options |
|-------|-------------|---------|---------|
| `images` | Container images to scan (one per line) | See default list above | Any valid container image |
| `severity_threshold` | Minimum severity level to report | `MEDIUM` | `LOW`, `MEDIUM`, `HIGH`, `CRITICAL` |
| `fail_on_critical` | Fail workflow if critical vulnerabilities found | `true` | `true`, `false` |

### Scheduled Scans

The workflow automatically runs daily at 2 AM UTC to ensure continuous monitoring of your container images.

## 📊 Understanding Results

### Artifact Downloads

After each scan, you can download detailed results:

1. **Individual scan results**: `scan-results-{image-name}`
   - Trivy JSON and text reports
   - Grype JSON and text reports
   - SBOM files in SPDX format
   - Docker Scout results (if available)

2. **Consolidated results**: `consolidated-scan-results`
   - Combined reports from all scanned images
   - Security summary with overall vulnerability counts
   - Comprehensive README with scan details

### File Types

- **`.json` files**: Machine-readable scan results for integration with other tools
- **`.txt` files**: Human-readable reports for manual review
- **`.spdx.json` files**: Software Bill of Materials in SPDX format
- **`summary-*.md` files**: Markdown summaries for each image
- **`SECURITY_SUMMARY.md`**: Overall security assessment

## 🛠️ Customization

### Adding New Images

To scan additional images:

1. **Manual run**: Edit the images list in the workflow dispatch interface
2. **Permanent addition**: Modify the default list in `.github/workflows/container-scan.yml`

### Configuring Scan Tools

#### Trivy Configuration

Edit `scan-config/trivy.yaml` to customize Trivy behavior:
- Database update settings
- Vulnerability types and severities
- Output formats
- Timeout settings

#### Grype Configuration

Edit `scan-config/grype.yaml` to customize Grype behavior:
- Database settings
- Scan scope
- Failure thresholds
- Registry configuration

#### Ignoring Vulnerabilities

Use `.trivyignore` to suppress specific vulnerabilities:
```
# Example: Ignore a specific CVE
CVE-2021-44228

# Example: Ignore a GitHub Security Advisory
GHSA-xxxx-xxxx-xxxx
```

**⚠️ Important**: Only ignore vulnerabilities after proper security assessment and documentation.

## 🔒 Security Best Practices

### 1. Regular Scanning
- Enable scheduled scans to catch new vulnerabilities
- Scan images before deployment
- Monitor base image updates

### 2. Vulnerability Management
- Prioritize critical and high severity vulnerabilities
- Establish SLAs for vulnerability remediation
- Track vulnerability trends over time

### 3. SBOM Management
- Use generated SBOMs for compliance and auditing
- Track software components and licenses
- Monitor for supply chain vulnerabilities

### 4. CI/CD Integration
- Fail builds on critical vulnerabilities
- Generate security reports for each release
- Automate vulnerability notifications

## 🚨 Responding to Vulnerabilities

### Critical Vulnerabilities
1. **Immediate Action Required**
   - Stop deploying affected images
   - Assess impact on running systems
   - Apply patches or updates immediately

### High Severity Vulnerabilities
1. **Urgent Review**
   - Prioritize for next maintenance window
   - Assess exploitability in your environment
   - Plan remediation within 7 days

### Medium/Low Severity
1. **Planned Remediation**
   - Include in regular update cycles
   - Monitor for exploit development
   - Document risk acceptance if needed

## 📈 Metrics and Reporting

### Key Metrics to Track
- Total vulnerability count by severity
- Time to remediation
- Vulnerability trends over time
- SBOM component counts

### Integration Options
- Export JSON results to security dashboards
- Integrate with SIEM systems
- Generate compliance reports

## 🔧 Troubleshooting

### Common Issues

#### Authentication Errors
- Ensure `GITHUB_TOKEN` has appropriate permissions
- Check if images are in private registries requiring authentication

#### Scan Failures
- Verify image names and tags are correct
- Check if images are accessible from GitHub Actions runners
- Review tool-specific error messages in logs

#### Large Images
- Consider using `--timeout` flags for large images
- Monitor runner resource usage
- Split large scans into smaller batches

### Getting Help

1. Check the workflow logs for detailed error messages
2. Review tool documentation:
   - [Trivy Documentation](https://aquasecurity.github.io/trivy/)
   - [Grype Documentation](https://github.com/anchore/grype)
   - [Syft Documentation](https://github.com/anchore/syft)
3. Open an issue in this repository for workflow-specific problems

## 🔄 Workflow Triggers

The scanning workflow runs on:

1. **Manual dispatch**: Run on-demand with custom parameters
2. **Schedule**: Daily at 2 AM UTC for continuous monitoring
3. **Push to main**: When workflow files are modified
4. **Configuration changes**: When scan-config files are updated

## 📝 Compliance and Auditing

### Standards Supported
- **NIST Cybersecurity Framework**
- **OWASP Container Security**
- **CIS Docker Benchmarks**
- **SPDX SBOM Format**

### Audit Trail
- All scans are logged with timestamps
- Results are retained for 90 days (consolidated) / 30 days (individual)
- Vulnerability decisions can be tracked through ignore files

## 🎯 Advanced Usage

### Custom Scanning Policies
Create custom policies by modifying the configuration files to:
- Focus on specific vulnerability types
- Adjust severity thresholds per image
- Implement custom ignore rules

### Integration with External Tools
The JSON output can be integrated with:
- Security orchestration platforms
- Vulnerability management systems
- Compliance reporting tools
- Custom dashboards and analytics

### Multi-Environment Scanning
Adapt the workflow for different environments:
- Development: Lower thresholds, informational only
- Staging: Medium thresholds, warnings
- Production: High thresholds, fail on critical

---

## 📚 Additional Resources

- [Container Security Best Practices](https://kubernetes.io/docs/concepts/security/)
- [OWASP Container Security Guide](https://owasp.org/www-project-container-security/)
- [NIST Container Security Guide](https://csrc.nist.gov/publications/detail/sp/800-190/final) 
