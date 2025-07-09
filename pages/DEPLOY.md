# Deployment Guide

Guide for deploying the security dashboard to GitHub Pages using the `pages/` directory.

## 🚀 Quick Deployment

### 1. Update Dashboard Data
From the **project root directory**:
```bash
# Generate report and update dashboard data from latest scan results
./scripts/dimpact-image-report.sh --input-dir dimpact-scan-results/250627

# Or use environment variable
INPUT_DIR="dimpact-scan-results/250627" ./scripts/dimpact-image-report.sh
```

### 2. Deploy to GitHub Pages
```bash
git add pages/data/
git commit -m "📊 Update security scan results"
git push origin main
```

## 📁 Project Structure

```
project-root/
├── scripts/
│   └── dimpact-image-report.sh     # Report generation and dashboard update script
├── pages/
│   ├── index.html                  # Dashboard page
│   ├── *.css, *.js                 # Dashboard assets
│   ├── data/                       # Scan result data
│   │   ├── container-1/
│   │   └── container-2/
│   └── README.md                   # Dashboard documentation
└── dimpact-scan-results/           # Source scan results
    └── 250627/                     # Date-specific results
        ├── container-1/
        └── container-2/
```

## 🔧 GitHub Pages Configuration

1. **Repository Settings**: Go to Settings → Pages
2. **Source**: Deploy from branch
3. **Branch**: main
4. **Folder**: `/pages` ⚠️ **Important: Select pages folder**
5. **Save**: Click Save

## ✅ Verification Steps

After deployment:

1. Check that `pages/data/` contains SARIF files
2. Verify GitHub Pages deployment status
3. Visit your GitHub Pages URL
4. Confirm dashboard loads with security data

## 🔍 Troubleshooting

### Dashboard Not Loading
- Verify GitHub Pages is configured to use `pages` folder
- Check that `pages/index.html` exists
- Wait 5-10 minutes for deployment

### No Security Data
- Ensure SARIF files are in `pages/data/*/`
- Check that report script ran successfully
- Verify file permissions and formats

---

*Deployment guide for the new `pages/` directory structure* 
