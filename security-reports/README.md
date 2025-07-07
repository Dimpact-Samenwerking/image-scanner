# Security Scan Reports - Space-Efficient Storage

This directory contains historical security scan reports optimized for space efficiency.

## 🏗️ Storage Architecture

### Git Repository (This Directory)
- **Purpose**: Quick access, trend analysis, compliance tracking
- **Contents**: Summary reports and metadata only
- **Size**: ~50KB per scan (99% space savings)
- **Retention**: Permanent (6 months of reports)

### GitHub Actions Artifacts  
- **Purpose**: Detailed analysis, compliance evidence
- **Contents**: Raw JSON, SPDX, detailed logs
- **Size**: 1-50MB per scan  
- **Retention**: 6 months auto-cleanup

## 📁 Directory Structure

- `latest/` - Most recent scan results
- `historical/YYYY-MM-DD/` - Historical scan results by date
- `STORAGE_STRATEGY.md` - Detailed storage explanation

## 📋 Files in Each Report

### Git Repository Files
- `SCAN_REPORT.md` - Comprehensive security analysis and summary
- `scan-metadata.json` - Scan metadata with archive references

### Archived Files (GitHub Actions Artifacts)
- `trivy-*.json` - Raw Trivy vulnerability scan results
- `grype-*.json` - Raw Grype vulnerability scan results  
- `syft-*.spdx.json` - Software Bill of Materials (SPDX format)
- Detailed logs and additional scan artifacts

## 🔍 Accessing Raw Data

### For Recent Scans (within 6 months):
1. Navigate to **Actions** → **Container Security Scan**
2. Select the workflow run for your target date
3. Download `raw-scan-data-XXXXXX` artifact
4. Extract and analyze detailed files

### Archive Reference
Each `scan-metadata.json` includes the archive name:
```json
{
  "raw_data_archive": "scan-data-20240607_143022.tar.gz",
  "archive_retention": "6 months as GitHub Actions artifact"
}
```

## 📊 Recent Scans

| Date | Summary Report | Metadata | Archive Status |
|------|----------------|----------|----------------|
| 2025-06-11 | [View Report](./historical/2025-06-11/SCAN_REPORT.md) | [Metadata](./historical/2025-06-11/scan-metadata.json) | scan-data-20250611_040854.tar.gz |
| 2025-06-10 | [View Report](./historical/2025-06-10/SCAN_REPORT.md) | [Metadata](./historical/2025-06-10/scan-metadata.json) | scan-data-20250610_041425.tar.gz |
| 2025-06-09 | [View Report](./historical/2025-06-09/SCAN_REPORT.md) | [Metadata](./historical/2025-06-09/scan-metadata.json) | scan-data-20250609_215208.tar.gz |
| 2025-06-08 | [View Report](./historical/2025-06-08/SCAN_REPORT.md) | [Metadata](./historical/2025-06-08/scan-metadata.json) | scan-data-20250608_230555.tar.gz |

## 💾 Space Efficiency Benefits

- **Repository Size**: 99% reduction vs storing raw data in git
- **Clone Speed**: Faster repository operations
- **History**: All summaries preserved permanently
- **Raw Data**: Available when needed (6 months)
- **Cost**: Optimized storage costs

## ⚡ Quick Actions

- **Latest Report**: [View Latest](./latest/SCAN_REPORT.md)
- **Trend Analysis**: Compare historical summaries
- **Raw Data**: Download from GitHub Actions artifacts
- **Configuration**: [Scan Settings](../scan-config/)

