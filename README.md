# Dimpact Container Security Scanner

A comprehensive security scanning solution for container images used in Dimpact Helm charts. This tool automatically discovers, scans, and generates detailed security reports with interactive dashboards.

## 🚀 Quick Start

### Prerequisites
- Docker installed and running
- Internet connection for downloading images
- Bash shell (Linux/macOS) or WSL (Windows)

### Basic Usage

1. **Discover and scan all container images**:
   ```bash
   ./scripts/dimpact-image-scanner.sh --use-discovered
   ```

2. **Generate enhanced report**:
   ```bash
   ./scripts/dimpact-image-report.sh
   ```

3. **View dashboard**: Open the security dashboard at your GitHub Pages URL after setting up GitHub Pages in repository settings.

## 📁 Output Structure

```
project-root/
├── dimpact-scan-results/YYMMDD/     # Scan results (new structure)
│   ├── container-1/
│   │   └── trivy-results.sarif
│   └── SCAN_REPORT.md
├── pages/                           # GitHub Pages dashboard
│   ├── index.html                   # Interactive dashboard
│   ├── data/                        # Dashboard data
│   │   ├── container-1/
│   │   │   └── trivy-results.sarif
│   │   └── security-data.json
│   └── README.md
└── scripts/                         # Scanner scripts
    ├── dimpact-image-scanner.sh
    └── dimpact-image-report.sh
```

## 🔧 Advanced Features

### Quickmode (10x Faster)
Reuse existing scan data for dramatically faster scans:
```bash
./scripts/dimpact-image-scanner.sh --quickmode --use-discovered
```

### Test Mode
Scan only first 3 images for testing:
```bash
./scripts/dimpact-image-scanner.sh --testmode --use-discovered
```

### Custom Configuration
```bash
# Custom severity threshold and output directory
SEVERITY_THRESHOLD=HIGH OUTPUT_DIR=./my-results ./scripts/dimpact-image-scanner.sh
```

## 📊 Dashboard Features

The security dashboard provides:
- **Interactive Charts**: Vulnerability trends and severity distributions
- **Container Details**: Drill-down into specific vulnerabilities
- **EPSS Integration**: Exploit Prediction Scoring System
- **GitHub Pages Ready**: No server required

### Setting Up GitHub Pages

1. Go to repository **Settings** → **Pages**
2. Set source to **Deploy from branch**
3. Select **main** branch and **pages** folder
4. Dashboard will be available at your GitHub Pages URL

### Updating Dashboard Data

From project root:
```bash
# Copy latest scan results to dashboard
./scripts/dimpact-image-report.sh --input-dir dimpact-scan-results/250627

# Commit and deploy
git add pages/data/
git commit -m "📊 Update security scan results"
git push origin main
```

## 🎯 Use Cases

### Daily Security Monitoring
```bash
# Quick daily scan (using cached data)
./scripts/dimpact-image-scanner.sh --quickmode --use-discovered
./scripts/dimpact-image-report.sh
```

### Weekly Deep Scan
```bash
# Full weekly scan (refresh all data)
./scripts/dimpact-image-scanner.sh --use-discovered
./scripts/dimpact-image-report.sh
```

### CI/CD Integration
```bash
# Fast scan for pull requests
./scripts/dimpact-image-scanner.sh --quickmode --testmode --use-discovered
```

## 📚 Documentation

- [Commands Reference](pages/COMMANDS_REFERENCE.md) - Quick command guide
- [GitHub Pages Setup](pages/GITHUB_PAGES_SETUP.md) - Dashboard deployment
- [Quickmode Guide](QUICKMODE_GUIDE.md) - Fast scanning with caching
- [Container Configuration](CONTAINER_CONFIG_EXAMPLES.md) - Image discovery setup

## 🔍 File Locations

Key files and their purposes:
- `scripts/dimpact-image-scanner.sh` - Main scanning engine
- `scripts/dimpact-image-report.sh` - Report generation and dashboard updates
- `pages/` - GitHub Pages dashboard files
- `dimpact-scan-results/` - Organized scan results by date
- `config.sh` - Scanner configuration

---

*Comprehensive container security scanning with intelligent caching and interactive dashboards*
