# 🚀 Quick Reference Guide
## Container Image Security Scanner

### 🔥 Most Common Commands

```bash
# Quick scan of all images
./scripts/dimpact-image-scanner.sh

# Scan specific image with debug
./scripts/dimpact-image-scanner.sh --debug --image nginx:latest

# High-performance scan with strict mode
./scripts/dimpact-image-scanner.sh --performance max --strict

# Test mode (first 3 images only)
./scripts/dimpact-image-scanner.sh --testmode

# Generate reports from existing scans
./scripts/dimpact-image-report.sh --output-dir ./my-scans
```

### ⚙️ Configuration Quick Setup

```bash
# Set up environment
export SEVERITY_THRESHOLD=HIGH
export PERFORMANCE_MODE=max
export OUTPUT_DIR=./security-scans

# Update vulnerability databases
./scripts/dimpact-image-scanner.sh --update-db

# Clean caches and temp files
./scripts/dimpact-image-scanner.sh --clean-cache
```

### 📊 Understanding Severity Levels

| Level | Description | Action Required |
|-------|-------------|-----------------|
| `CRITICAL` | 🔴 Immediate threat | Fix immediately |
| `HIGH` | 🟠 Serious risk | Fix within 7 days |
| `MEDIUM` | 🟡 Moderate risk | Fix within 30 days |
| `LOW` | 🔵 Minor issue | Fix when convenient |

### 🛡️ CVE Suppression Template

```markdown
| CVE-2024-XXXX | HIGH | Brief description | Your Name | 2024-01-01 | Business justification | 2024-04-01 |
```

### 🔧 Performance Modes

| Mode | CPU Usage | Memory Usage | Best For |
|------|-----------|--------------|----------|
| `normal` | 50% | 50% | Development/Testing |
| `high` | 75% | 75% | CI/CD Pipelines |
| `max` | 100% | 100% | Dedicated Servers |

### 📁 Output Directory Structure

```
YYMMDD-scan-results/
├── SECURITY_SUMMARY.md         # Executive dashboard
├── DETAILED_REPORT.md          # Complete analysis  
├── nginx-latest/               # Per-image results
│   ├── trivy-results.json
│   ├── grype-results.json
│   └── sbom.spdx.json
└── metadata/
    └── scan-metadata.json
```

### 🚨 Troubleshooting Checklist

- [ ] **Docker running?** `docker ps`
- [ ] **Permissions OK?** `docker run hello-world`
- [ ] **Network access?** `curl -I https://registry-1.docker.io/v2/`
- [ ] **Disk space?** `df -h`
- [ ] **Memory available?** `free -h`

### 🤖 GitHub Actions Quick Setup

```yaml
# .github/workflows/security-scan.yml
on:
  schedule:
    - cron: '0 2 * * 1'  # Weekly Monday 2 AM
jobs:
  scan:
    uses: ./.github/workflows/container-scan.yml
```

### 📈 Report Types Generated

| File | Purpose | Audience |
|------|---------|----------|
| `SECURITY_SUMMARY.md` | Executive overview | Management/Teams |
| `DETAILED_REPORT.md` | Technical analysis | Security Engineers |
| `*.json` | Raw scan data | Automation/Tools |
| `*.spdx.json` | Software inventory | Compliance |

### 🔍 Exit Codes

| Code | Meaning | Action |
|------|---------|--------|
| `0` | Success | Continue normally |
| `1` | General error | Check logs and debug |
| `2` | Missing dependencies | Install required tools |
| `3` | Configuration error | Fix config files |
| `4` | Network/timeout error | Check connectivity |

### 💡 Pro Tips

1. **Use test mode first**: `--testmode` for quick validation
2. **Debug issues with**: `--debug` for verbose output  
3. **Save resources with**: `--performance normal` on limited systems
4. **Clean up regularly**: `--clean-cache` to free disk space
5. **Update databases**: `--update-db` for latest vulnerabilities
6. **Use strict mode**: `--strict` in CI/CD for fail-fast behavior

### 📞 Getting Help

```bash
# Show all options
./scripts/dimpact-image-scanner.sh --help

# Show report options  
./scripts/dimpact-image-report.sh --help

# Debug mode for troubleshooting
./scripts/dimpact-image-scanner.sh --debug --testmode
``` 
