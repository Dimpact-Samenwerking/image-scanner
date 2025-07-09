# GitHub Pages Setup Guide

This guide explains how to deploy the security dashboard to GitHub Pages using the new `pages/` directory structure.

## 🚀 Quick Setup

### 1. Enable GitHub Pages

1. Go to your repository **Settings** → **Pages**
2. Under **Source**, select **Deploy from a branch**
3. Choose **main** branch and **/ (root)** folder
4. Save the settings

### 2. Copy Scan Results to pages/data

From the **project root directory**:

```bash
# Generate report and update dashboard data from latest scan results
./scripts/dimpact-image-report.sh --input-dir dimpact-scan-results/250627

# Or use environment variable
INPUT_DIR="dimpact-scan-results/250627" ./scripts/dimpact-image-report.sh
```

#### Manual Copy (Alternative)
```bash
# Copy your latest scan results to pages/data directory
mkdir -p pages/data
cp -r your-scan-results-directory/* pages/data/

# For example, if using the default naming:
cp -r dimpact-scan-results/250627/* pages/data/
```

### 3. Commit and Push

```bash
git add pages/data/
git commit -m "📊 Update security dashboard data"
git push origin main
```

#### Using Report Script (Recommended)
From the **project root directory**:
```bash
# Generate report and update dashboard data
./scripts/dimpact-image-report.sh --input-dir dimpact-scan-results/250627

# Commit and push
git add pages/data/
git commit -m "📊 Update security scan results"
git push origin main
```

#### Manual Copy (Alternative)
```bash
# Manually copy scan results if needed
mkdir -p pages/data
cp -r scan-results/* pages/data/
git add pages/data/
git commit -m "📊 Update scan data"
git push origin main
```

### 4. Configure GitHub Pages

1. In repository settings, go to **Pages**
2. Set source to **Deploy from a branch**
3. Select **main** branch
4. Select **pages** folder (⚠️ **Important:** Select the pages folder, not docs)
5. Click **Save**

## 📁 Expected Directory Structure

After setup, your repository should have:

```
your-repo/
├── pages/                           # GitHub Pages root directory
│   ├── index.html                   # Dashboard page
│   ├── *.css, *.js                  # Dashboard assets
│   ├── data/                        # Scan results
│   │   ├── container-1/
│   │   │   └── trivy-results.sarif
│   │   └── container-2/
│   │       └── trivy-results.sarif
│   └── README.md                    # Dashboard documentation
└── ... (other project files)
```

Expected directory structure in `pages/data/`:

```
pages/data/
├── container-1/
│   └── trivy-results.sarif
├── container-2/
│   └── trivy-results.sarif
└── security-data.json              # Auto-generated dashboard data
```

## 🔧 Troubleshooting

### Dashboard Not Loading
1. Check that files are in `pages/data/` directory
2. Verify GitHub Pages is configured to use `pages` folder
3. Check GitHub Pages deployment status in repository settings
4. Wait 5-10 minutes for GitHub Pages to update

### No Security Data Displayed
1. Verify SARIF files exist in `pages/data/*/trivy-results.sarif`
2. Check that files are valid JSON format
3. Ensure scan results were copied correctly

### 404 Error
1. Confirm GitHub Pages source is set to `pages` folder
2. Check that `pages/index.html` exists
3. Verify repository name and URL configuration

## 🎯 Best Practices

1. **Automate Updates**: Use GitHub Actions to automatically update dashboard data
2. **Regular Updates**: Update dashboard data after each security scan
3. **File Size**: Keep SARIF files under 100MB for optimal GitHub Pages performance
4. **Version Control**: Keep scan results in git for historical tracking

## 📚 Additional Resources

- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Security Dashboard User Guide](README.md)

---

*Using the new `pages/` directory structure for improved organization* 
