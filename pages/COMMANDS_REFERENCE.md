# Commands Reference

Quick reference for updating the security dashboard with scan results.

## 🚀 Dashboard Update Commands

### 1. Update Dashboard Data
```bash
# Generate report and auto-update dashboard data from latest scan results
./scripts/dimpact-image-report.sh --input-dir dimpact-scan-results/250627

# Or use environment variable
INPUT_DIR="dimpact-scan-results/250627" ./scripts/dimpact-image-report.sh
```

### 2. Commit Dashboard Changes
```bash
git add pages/data/
git commit -m "📊 Update security scan results"
git push origin main
```

## 📁 Directory Structure Reference

```
project-root/                              ← YOU ARE HERE
├── scripts/
│   └── dimpact-image-report.sh            ← Report script (also updates dashboard)
├── pages/                                 ← GitHub Pages directory
│   ├── index.html                         ← Dashboard page  
│   ├── data/                              ← Scan results
│   │   ├── container-1/
│   │   │   └── trivy-results.sarif
│   │   └── container-2/
│   │       └── trivy-results.sarif
│   └── README.md
└── dimpact-scan-results/                  ← Source scan results
    └── 250627/                            ← Date-specific results
        ├── container-1/
        │   └── trivy-results.sarif
        └── container-2/
            └── trivy-results.sarif
```

## 🔧 Report Script Location
The report generation script that also updates dashboard data is located at: `./scripts/dimpact-image-report.sh`

## 📚 Step-by-Step Workflow

From the **project root directory**:

1. **Update data** (from project root):
   ```bash
   ./scripts/dimpact-image-report.sh --input-dir dimpact-scan-results/250627
   ```

2. **Commit changes**:
   ```bash
   git add pages/data/
   git commit -m "📊 Update security scan results"
   git push origin main
   ```

3. **View dashboard**: Visit your GitHub Pages URL

## 🔍 Troubleshooting

### Script Permission Denied
```bash
# Make script executable
chmod +x scripts/dimpact-image-report.sh
```

### No Data in Dashboard
1. Check that `pages/data/` contains SARIF files
2. Verify script ran successfully without errors
3. Check GitHub Pages is configured correctly

### Dashboard Not Updating
1. Clear browser cache
2. Wait 5-10 minutes for GitHub Pages to update
3. Check repository Pages settings

---

*Commands for the new `pages/` directory structure* 
