# 🛡️ Dimpact Container Security Scanner & Dashboard

A modern, end-to-end solution for discovering, scanning, and reporting vulnerabilities in container images used in Dimpact Helm charts. Results are visualized in a beautiful interactive dashboard, viewable locally or via GitHub Pages.

---

## 🚦 How It Works: End-to-End Flow

```
Discovery
   |
   v
Scanning
   |
   v
Reporting
   |
   v
Dashboard
```

---

## 🛠️ Script Details & Usage

### 1. Discovery: Find All Images
- **Script:** `./scripts/dimpact-image-discovery.sh`
- **Purpose:** Scans Helm charts to list all container images in use.
- **Usage:**
  ```bash
  ./scripts/dimpact-image-discovery.sh
  # Output: scan-config/repo_map.yaml (list of images)
  ```

### 2. Scanning: Vulnerability Analysis
- **Script:** `./scripts/dimpact-image-scanner.sh`
- **Purpose:** Pulls images and runs Trivy/Grype scans.
- **Usage:**
  ```bash
  ./scripts/dimpact-image-scanner.sh --use-discovered
  # Options:
  #   --quickmode   # Use cached data for speed
  #   --testmode    # Scan only 3 images for testing
  #   SEVERITY_THRESHOLD=HIGH OUTPUT_DIR=./my-results ...
  ```
- **Input:** Uses `scan-config/repo_map.yaml` (from discovery)
- **Output:** SARIF & JSON results in `dimpact-scan-results/<date>/`

### 3. Reporting: Generate Dashboard Data
- **Script:** `./scripts/dimpact-image-report.sh`
- **Purpose:** Aggregates scan results, applies suppressions, prepares dashboard data.
- **Usage:**
  ```bash
  ./scripts/dimpact-image-report.sh
  # Copies SARIF files to docs/data/ for dashboard
  ```

---

## 🖥️ Command Line Workflow: Step-by-Step

```bash
# 1. Discover images
./scripts/dimpact-image-discovery.sh

# 2. Scan images
./scripts/dimpact-image-scanner.sh --use-discovered

# 3. Generate report & dashboard data
./scripts/dimpact-image-report.sh
```

- **Advanced:**
  - Quick scan: `./scripts/dimpact-image-scanner.sh --quickmode --use-discovered`
  - Test mode: `./scripts/dimpact-image-scanner.sh --testmode --use-discovered`
  - Custom output: `OUTPUT_DIR=./my-results ./scripts/dimpact-image-scanner.sh ...`

---

## 🌐 View Dashboard Locally

1. Ensure you’ve run the report script to populate `docs/data/`.
2. Start a local web server:
   ```bash
   cd docs && python3 -m http.server 8080
   ```
3. Open your browser to [http://localhost:8080](http://localhost:8080)

---

## 🤖 GitHub Actions Workflow & GitHub Pages

- The GitHub Actions workflow runs all scripts automatically:
  - Discovers images
  - Scans for vulnerabilities
  - Generates reports
  - Publishes the dashboard to GitHub Pages
- Find your dashboard at:
  - `https://dimpact-samenwerking.github.io/image-scanner/`
- See `.github/workflows/` for workflow details.

---

## 📋 Summary Table

| Step      | Script                              | Output Location           |
|-----------|-------------------------------------|--------------------------|
| Discovery | `dimpact-image-discovery.sh`        | scan-config/repo_map.yaml|
| Scanning  | `dimpact-image-scanner.sh`          | dimpact-scan-results/    |
| Report    | `dimpact-image-report.sh`           | docs/data/               |
| Dashboard | (local server or GitHub Pages)      | docs/index.html          |

---

## 📚 Documentation & Advanced Topics

- [Commands Reference](COMMANDS_REFERENCE.md)
- [GitHub Pages Setup](GITHUB_PAGES_SETUP.md)
- [Quickmode Guide](QUICKMODE_GUIDE.md)
- [Container Config Examples](CONTAINER_CONFIG_EXAMPLES.md)

---

## 🖥️ Browser Support
- Chrome 60+, Firefox 55+, Safari 12+, Edge 79+

## 🔒 Security & Performance
- No external dependencies or CDNs
- All code is self-contained
- No data sent to external services
- Fast, supports 1000+ images

## 📝 License
See main repository LICENSE file for details.
