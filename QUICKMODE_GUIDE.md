# 🚀 Quickmode Guide

## Overview
Quickmode is a new feature that dramatically speeds up image scanning by reusing existing scan data from the `docs/data/` directory. Instead of re-scanning all images, it intelligently copies existing SARIF files when available and only scans new or missing images.

## 📊 Performance Benefits

### Before Quickmode
- **Fresh scan**: 30-60 minutes for 47 images
- **Every run**: Downloads databases, pulls images, performs full scans
- **Resource intensive**: High CPU, memory, and network usage

### With Quickmode
- **Mixed processing**: 3-5 minutes for existing data + scan time for new images only
- **Intelligent reuse**: Copies existing validated SARIF files in seconds
- **Minimal resources**: Only scans truly new or missing images

## 🔧 Usage Examples

### Basic Quickmode
```bash
# Reuse all existing data, scan only new images
./scripts/dimpact-image-scanner.sh --quickmode
```

### Quickmode with Test Mode
```bash
# Test with first 3 images using existing data when available
./scripts/dimpact-image-scanner.sh --quickmode --testmode
```

### Single Image Quickmode
```bash
# Check for existing nginx data, scan only if not found
./scripts/dimpact-image-scanner.sh --quickmode --image nginx:latest
```

### Quickmode with Discovered Images
```bash
# Use discovered.yaml and apply quickmode optimization
./scripts/dimpact-image-scanner.sh --quickmode --use-discovered
```

## 🛠️ How It Works

### 1. **Validation Check**
- Checks if `docs/data/$image_safe_name/trivy-results.sarif` exists
- Validates SARIF file structure using `jq`
- Ensures file is not empty and contains required fields

### 2. **Age Detection**
- Displays age warnings for data older than 7 days
- Recommends fresh scans for data older than 30 days
- Shows file modification dates for transparency

### 3. **Intelligent Processing**
```
For each image:
├── Has existing valid data? 
│   ├── YES → Copy existing SARIF to output directory ⚡
│   └── NO → Perform fresh scan 🔍
└── Continue to next image
```

### 4. **Mixed Reporting**
- Tracks reused vs. scanned counts
- Shows time savings achieved
- Maintains same report quality

## 📁 Data Structure

### Expected Structure
```
docs/data/
├── docker-io-nginx-1-27/
│   └── trivy-results.sarif
├── docker-io-alpine-3-20/
│   └── trivy-results.sarif
└── ...
```

### Safe Name Conversion
Image names are converted to safe directory names:
- `docker.io/nginx:1.27` → `docker-io-nginx-1-27`
- `ghcr.io/user/app:latest` → `ghcr-io-user-app-latest`
- Special characters become hyphens

## ⚡ Performance Comparison

| Scenario | Normal Mode | Quickmode | Time Saved |
|----------|-------------|-----------|------------|
| 47 existing images | 45-60 min | 3-5 min | ~90% |
| 5 new + 42 existing | 45-60 min | 15-20 min | ~65% |
| All new images | 45-60 min | 45-60 min | 0% |

## 🔍 Output Examples

### Quickmode Processing
```
⚡ Quickmode enabled - will reuse existing scan data from docs/data/ when available
🚀 Starting quickmode processing (47 images)
Will reuse existing data from docs/data/ when available

⚡ Quickmode: Found existing data for nginx:1.27
✅ Reused existing scan data for nginx:1.27 (1 of 47)

⚡ Quickmode: No existing data found for new-app:latest, performing fresh scan
🚀 Scanning image 2 of 47: new-app:latest
```

### Final Summary
```
🎉 Quickmode processing completed!
📊 Processing Results Summary:
  • Successfully processed: 47 images
  • Reused existing data: 45 images
  • Fresh scans performed: 2 images
  • Failed operations: 0 images

⚡ Quickmode saved time by reusing 45 existing scan results!
```

## 🚨 Important Notes

### When to Use Quickmode
- ✅ **Development/Testing**: Fast iterations with mostly unchanged images
- ✅ **Incremental Scans**: Adding a few new images to existing set
- ✅ **Report Regeneration**: Need fresh reports with same scan data
- ✅ **CI/CD Optimization**: Speed up build pipelines

### When NOT to Use Quickmode
- ❌ **Security Audits**: Need guaranteed fresh vulnerability data
- ❌ **Compliance Scans**: Require current date timestamps
- ❌ **Fresh Database**: When vulnerability databases have major updates
- ❌ **Stale Data**: When existing data is >30 days old

### Data Validation
- SARIF files are validated for basic structure
- Corrupted files trigger fresh scans automatically
- Empty or invalid files are rejected
- Age warnings help identify stale data

## 🔧 Troubleshooting

### No Existing Data Found
```bash
# If no docs/data directory exists
mkdir -p docs/data
# Run a normal scan first to populate data
./scripts/dimpact-image-scanner.sh
# Then use quickmode on subsequent runs
./scripts/dimpact-image-scanner.sh --quickmode
```

### Corrupted SARIF Files
- Quickmode automatically detects invalid SARIF files
- Falls back to fresh scanning for corrupted data
- No manual intervention required

### Mixed Results
- Some images may have existing data while others don't
- Quickmode handles this seamlessly
- Progress indicators show which operation is being performed

## 🎯 Best Practices

1. **First Run**: Always do a complete scan first to populate `docs/data/`
2. **Regular Updates**: Refresh data weekly for active projects
3. **Monitor Age**: Pay attention to age warnings for critical scans
4. **Backup Data**: Keep `docs/data/` in version control for team sharing
5. **Selective Refresh**: Use `--image` flag to refresh specific outdated images

## 🔗 Integration with Reports

Quickmode works seamlessly with the existing report generation:
- Mixed data sources (existing + fresh) create unified reports
- All SARIF processing remains the same
- Dashboard updates work normally
- No changes needed to downstream processes 
