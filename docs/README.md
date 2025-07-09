# 🛡️ Container Security Dashboard

A modern, colorful, and interactive web dashboard for visualizing container vulnerability scan results from SARIF (Static Analysis Results Interchange Format) data.

## ✨ Features

- **Modern Design**: Clean, colorful interface with gradient backgrounds and glass-morphism effects
- **Real-time Data**: Automatically loads and displays vulnerability data from SARIF scan results
- **Interactive Drill-down**: Click on any container image to see detailed vulnerability information
- **Search Functionality**: Quickly find specific container images using the search box
- **Responsive Design**: Works perfectly on desktop, tablet, and mobile devices
- **Self-contained**: Single HTML file with embedded CSS/JavaScript, no build process required

## 🎯 Dashboard Sections

### 1. Summary Cards
- **Critical**: 🔥 Immediate action required
- **High**: ⚠️ High priority patching needed
- **Medium**: 🔶 Schedule maintenance
- **Low**: 🔵 Monitor and review
- **Suppressed**: 🛡️ Known issues that are suppressed
- **Failed Scans**: ❌ Images that couldn't be scanned

### 2. Container Images List
- Sortable list of all scanned container images
- Color-coded vulnerability badges for quick assessment
- Status indicators (✅ Scanned / ❌ Failed)
- Click to drill down into detailed vulnerability information

### 3. Detailed Vulnerability Modal
- Comprehensive vulnerability details for each image
- CVE IDs with direct links to security advisories
- Vulnerability descriptions and locations
- Organized by severity level

## 🚀 Usage

### Local Development
1. Run your SARIF vulnerability scans
2. Copy scan results: `./scripts/update-dashboard-data.sh` (from project root)
3. Start a local HTTP server: `cd docs && python3 -m http.server 8080`
4. Open your browser to `http://localhost:8080`

### GitHub Pages Deployment  
1. Copy scan results to `docs/data/`: `./scripts/update-dashboard-data.sh` (from project root)
2. Commit and push: `git add docs/data/ && git commit -m "📊 Add scan results" && git push`
3. Enable GitHub Pages in repository Settings → Pages → docs folder
4. Access your dashboard at: `https://yourusername.github.io/yourrepository/`

📖 **Detailed GitHub Pages setup**: See [GitHub Pages Setup Guide](GITHUB_PAGES_SETUP.md)

### Expected Directory Structure
```
docs/data/  (for GitHub Pages)
├── image-name-1/
│   └── trivy-results.sarif
├── image-name-2/
│   └── trivy-results.sarif
└── ...
```

## 📊 Data Sources

The dashboard loads vulnerability data from:

**SARIF Files**: Vulnerability scan results from Trivy/Grype scans
- `trivy-results.sarif` files in scan result directories
- Automatic discovery from common scan result locations
- Full vulnerability details with CVE mappings

## 🎨 Color Scheme

- **Critical**: Red (#e74c3c) - Immediate attention required
- **High**: Orange (#f39c12) - High priority
- **Medium**: Yellow (#f1c40f) - Medium priority  
- **Low**: Blue (#3498db) - Low priority
- **Suppressed**: Purple (#9b59b6) - Suppressed issues
- **Failed**: Gray (#95a5a6) - Failed scans

## 🔧 Customization

### Adding New Data Sources
Modify the `discoverSarifFiles()` function in `index.html` to add new scan result locations:

```javascript
const possibleLocations = [
    'your-scan-results-directory',
    'another-directory',
    // ... existing locations
];
```

### Styling
All styles are contained within the `<style>` tag in `index.html`. The design uses:
- CSS Grid for responsive layouts
- Flexbox for component alignment
- CSS gradients for visual appeal
- Backdrop filters for glass-morphism effects
- CSS animations for smooth interactions



## 🌐 Deployment

1. Host the `docs/` folder on any web server
2. The dashboard will work with SARIF files in the relative directory structure
3. No build process or additional configuration required

## 📱 Browser Support

- Modern browsers with ES6+ support
- Chrome 60+
- Firefox 55+
- Safari 12+
- Edge 79+

## 🔒 Security

- No external dependencies or CDNs
- All code is self-contained
- No data transmission to external services
- SARIF files are loaded locally via fetch API

## 📈 Performance

- Lightweight: ~20KB total size
- Fast loading with minimal HTTP requests
- Efficient DOM manipulation
- Responsive to large datasets (1000+ images)

## 🛠️ Development

The dashboard is built with vanilla JavaScript and modern CSS. No build tools or frameworks required.

### File Structure
```
docs/
├── index.html          # Main dashboard (HTML, CSS, JavaScript)
├── README.md           # This file
└── ...                 # Other legacy files (optional)
```

### Key Components
- `SecurityDashboard` class: Main application logic
- SARIF file discovery and parsing
- Responsive UI components
- Modal system for detailed views
- Search and filtering functionality



## 📝 License

This dashboard is part of the Container Security Scanner project. See the main repository LICENSE file for details.
