# 🛡️ Dimpact Container Security Scanner & Dashboard

A comprehensive, modern, and interactive solution for scanning container images in Dimpact Helm charts. Automatically discovers, scans, and generates detailed security reports with a beautiful dashboard.

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

2. **Generate enhanced report and update dashboard data**:
   ```bash
   ./scripts/dimpact-image-report.sh
   ```

3. **View dashboard**: Open the dashboard locally or via GitHub Pages (see below).

## 📁 Output Structure

```
docs/
├── index.html          # Main dashboard (HTML, CSS, JavaScript)
├── data/               # Dashboard data (SARIF files)
│   ├── image-name-1/
│   │   └── trivy-results.sarif
│   └── ...
├── README.md           # This file
└── ...
```

Scan results are stored in `dimpact-scan-results/YYMMDD/` and copied to `docs/data/` for dashboard display.

## 📊 Dashboard Features

- **Modern Design**: Clean, colorful, responsive UI
- **Real-time Data**: Loads vulnerability data from SARIF scan results
- **Interactive Drill-down**: Click any image for detailed vulnerability info
- **Search & Filter**: Quickly find and filter images by severity
- **EPSS Integration**: Exploit Prediction Scoring System support
- **No Build Required**: Self-contained, works on any web server

### Local Development
1. Run your SARIF vulnerability scans
2. Copy scan results: `./scripts/dimpact-image-report.sh`
3. Start a local HTTP server:
   ```bash
   cd docs && python3 -m http.server 8080
   ```
4. Open your browser to `http://localhost:8080`

### GitHub Pages Deployment
1. Copy scan results to `docs/data/`: `./scripts/dimpact-image-report.sh`
2. Commit and push: `git add docs/data/ && git commit -m "📊 Add scan results" && git push`
3. Enable GitHub Pages in repository Settings → Pages → docs folder
4. Access your dashboard at: `https://yourusername.github.io/yourrepository/`

## 🔧 Advanced Features

- **Quickmode (10x Faster)**: Reuse existing scan data for faster scans
  ```bash
  ./scripts/dimpact-image-scanner.sh --quickmode --use-discovered
  ```
- **Test Mode**: Scan only first 3 images for testing
  ```bash
  ./scripts/dimpact-image-scanner.sh --testmode --use-discovered
  ```
- **Custom Configuration**:
  ```bash
  SEVERITY_THRESHOLD=HIGH OUTPUT_DIR=./my-results ./scripts/dimpact-image-scanner.sh
  ```

## 🎯 Use Cases

- **Daily Security Monitoring**:
  ```bash
  ./scripts/dimpact-image-scanner.sh --quickmode --use-discovered
  ./scripts/dimpact-image-report.sh
  ```
- **Weekly Deep Scan**:
  ```bash
  ./scripts/dimpact-image-scanner.sh --use-discovered
  ./scripts/dimpact-image-report.sh
  ```
- **CI/CD Integration**:
  ```bash
  ./scripts/dimpact-image-scanner.sh --quickmode --testmode --use-discovered
  ```

## 📚 Documentation

- [Commands Reference](COMMANDS_REFERENCE.md) - Quick command guide
- [GitHub Pages Setup](GITHUB_PAGES_SETUP.md) - Dashboard deployment
- [Quickmode Guide](QUICKMODE_GUIDE.md) - Fast scanning with caching
- [Container Configuration](CONTAINER_CONFIG_EXAMPLES.md) - Image discovery setup

## 📱 Browser Support

- Modern browsers with ES6+ support
- Chrome 60+, Firefox 55+, Safari 12+, Edge 79+

## 🔒 Security & Performance

- No external dependencies or CDNs
- All code is self-contained
- No data transmission to external services
- Lightweight, fast, and responsive (1000+ images supported)

## 🛠️ Development

- Built with vanilla JavaScript and modern CSS
- No build tools or frameworks required
- All styles in `index.html` for easy customization

## 📝 License

This dashboard is part of the Dimpact Container Security Scanner project. See the main repository LICENSE file for details.
