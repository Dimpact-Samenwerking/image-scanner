# 📋 Commands Reference Guide

## 🏠 Working Directory
All commands assume you're in the **project root directory**: `/Users/jim/src/image-scanner`

## 🔧 Helper Script Location
The update script is located at: `./scripts/update-dashboard-data.sh`

## 📊 Dashboard Commands

### 1. Update Dashboard Data
```bash
# Auto-detect latest scan results and copy to docs/data/
./scripts/update-dashboard-data.sh

# Or specify a specific scan results directory
./scripts/update-dashboard-data.sh 250627-dimpact-scan-results
```

### 2. Test Dashboard Locally
```bash
# Kill any existing server (if needed)
lsof -ti:8080 | xargs kill -9

# Start HTTP server from docs directory
cd docs && python3 -m http.server 8080
```

Then open: **http://localhost:8080**

### 3. Deploy to GitHub Pages
```bash
# After updating dashboard data, commit and push
git add docs/data/
git commit -m "📊 Update security dashboard data"
git push origin main
```

## 📁 Directory Structure
```
project-root/                              ← YOU ARE HERE
├── scripts/
│   └── update-dashboard-data.sh           ← Helper script
├── docs/
│   ├── index.html                         ← Dashboard
│   ├── data/                              ← SARIF data (generated)
│   │   ├── container-1/
│   │   │   └── trivy-results.sarif
│   │   └── container-2/
│   │       └── trivy-results.sarif
│   └── *.md                               ← Documentation
└── 250627-dimpact-scan-results/           ← Source scan results
    ├── container-1/
    │   └── trivy-results.sarif
    └── container-2/
        └── trivy-results.sarif
```

## ⚠️ Common Mistakes

### ❌ Wrong: Running from docs directory
```bash
cd docs
./update-dashboard-data.sh  # This won't work!
```

### ✅ Correct: Running from project root
```bash
# Stay in project root
./scripts/update-dashboard-data.sh  # This works!
```

### ❌ Wrong: Server from wrong directory
```bash
python3 -m http.server 8080  # From project root - won't find dashboard
```

### ✅ Correct: Server from docs directory
```bash
cd docs && python3 -m http.server 8080  # This works!
```

## 🚀 Quick Start Workflow

1. **Update data** (from project root):
   ```bash
   ./scripts/update-dashboard-data.sh
   ```

2. **Test locally** (from project root):
   ```bash
   cd docs && python3 -m http.server 8080
   ```

3. **Deploy to GitHub** (from project root):
   ```bash
   git add docs/data/
   git commit -m "📊 Update dashboard data"
   git push origin main
   ```

## 🛠️ Troubleshooting

### Server Port Already in Use
```bash
# Find and kill process using port 8080
lsof -ti:8080 | xargs kill -9

# Or use a different port
cd docs && python3 -m http.server 8081
```

### Script Permission Denied
```bash
# Make script executable
chmod +x scripts/update-dashboard-data.sh
```

### No Data Showing in Dashboard
1. Check `docs/data/` directory exists and has SARIF files
2. Verify you're running server from `docs/` directory
3. Check browser console for errors

## 📖 Documentation Links

- [Quick Deployment Guide](DEPLOY.md) - Step-by-step deployment
- [GitHub Pages Setup](GITHUB_PAGES_SETUP.md) - Detailed GitHub Pages configuration
- [Dashboard README](README.md) - Dashboard features and usage 
