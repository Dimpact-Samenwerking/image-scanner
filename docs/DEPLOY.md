# 🚀 Quick Deployment Guide

## GitHub Pages Deployment

### 1. Update Dashboard Data
From the **project root directory**:
```bash
# Generate report and update dashboard data from latest scan results
./scripts/dimpact-image-report.sh --input-dir dimpact-scan-results/250627

# Or use environment variable
INPUT_DIR="dimpact-scan-results/250627" ./scripts/dimpact-image-report.sh
```

### 2. Commit and Push
```bash
# Add the updated data files
git add docs/data/

# Commit with descriptive message
git commit -m "📊 Update security dashboard data"

# Push to GitHub
git push origin main
```

### 3. Enable GitHub Pages
1. Go to your repository on GitHub
2. Navigate to **Settings** → **Pages**
3. Under **Source**, select **Deploy from a branch**
4. Choose **main** branch and **/docs** folder
5. Click **Save**

### 4. Access Your Dashboard
Your dashboard will be available at:
```
https://YOUR_USERNAME.github.io/YOUR_REPOSITORY/
```

## Local Testing

### Test Before Deployment
From the **project root directory**:
```bash
# Start local server from docs directory
cd docs && python3 -m http.server 8080
```

Then open: http://localhost:8080

### Kill Existing Server (if needed)
```bash
# Find and kill any existing server on port 8080
lsof -ti:8080 | xargs kill -9

# Or use a different port
cd docs && python3 -m http.server 8081
```

## File Structure
```
project-root/
├── scripts/
│   └── dimpact-image-report.sh     # Report generation and dashboard update script
├── docs/
│   ├── index.html                  # Dashboard
│   ├── data/                       # SARIF data files
│   │   ├── container-1/
│   │   │   └── trivy-results.sarif
│   │   └── container-2/
│   │       └── trivy-results.sarif
│   └── DEPLOY.md                   # This file
└── dimpact-scan-results/           # Source scan results
    └── 250627/                     # Date-specific results
        ├── container-1/
        └── container-2/
```

## Troubleshooting

### No Data Showing
1. Check that `docs/data/` contains SARIF files
2. Verify SARIF files are valid JSON
3. Check browser console for errors

### Server Already Running
```bash
# Kill existing server
lsof -ti:8080 | xargs kill -9

# Try different port
cd docs && python3 -m http.server 8081
```

### Large Files
GitHub has a 100MB file limit. If you have large SARIF files:
1. Use Git LFS for files >100MB
2. Or filter/compress the SARIF data

## Next Steps
- 📖 See `GITHUB_PAGES_SETUP.md` for detailed setup instructions
- 🔧 Customize the dashboard styling in `index.html`
- 📊 Automate updates with GitHub Actions
