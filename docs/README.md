# 🛡️ Dimpact Container Security Scanner & Dashboard

A modern, friendly toolkit for discovering, scanning, and reporting on
container image security in Dimpact Helm charts. Results are visualized
in a beautiful dashboard—locally or via GitHub Pages.

---

## 📦 How It Works

```mermaid
flowchart TD
    A[Discovery\n(dimpact-image-discovery.sh)] --> B[Scanning\n(dimpact-image-scanner.sh)]
    B --> C[Reporting\n(dimpact-image-report.sh)]
    C --> D[Dashboard\n(docs/index.html)]
```

- **Discovery**: Finds all container images in your Helm charts.
- **Scanning**: Runs security scans on each image.
- **Reporting**: Aggregates results and prepares dashboard data.
- **Dashboard**: Interactive web UI for exploring vulnerabilities.

---

## 🚀 Quick Start

### 1. Discover Images

```bash
./scripts/dimpact-image-discovery.sh
```

- Outputs a list of images to scan.

### 2. Scan Images

```bash
./scripts/dimpact-image-scanner.sh --use-discovered
```

- Scans all discovered images for vulnerabilities.
- Results are saved in `dimpact-scan-results/YYMMDD/`.

### 3. Generate Report & Dashboard Data

```bash
./scripts/dimpact-image-report.sh
```

- Aggregates scan results.
- Copies SARIF files to `docs/data/` for dashboard display.

### 4. View Dashboard Locally

```bash
cd docs
python3 -m http.server 8080
```

- Open your browser at [http://localhost:8080](http://localhost:8080)
- Explore vulnerabilities interactively!

---

## 🔄 Full Workflow Example

```bash
./scripts/dimpact-image-discovery.sh
./scripts/dimpact-image-scanner.sh --use-discovered
./scripts/dimpact-image-report.sh
cd docs && python3 -m http.server 8080
```

---

## 🤖 GitHub Actions & Pages

- The GitHub Actions workflow runs all scripts automatically:
  - Discovers images
  - Scans for vulnerabilities
  - Generates reports
  - Publishes the dashboard to GitHub Pages
- Find your dashboard at:
  - `https://<your-username>.github.io/<your-repo>/`
- See `.github/workflows/` for workflow details.

---

## ⚙️ Advanced Usage

- **Quickmode**: Reuse cached scan data for speed

  ```bash
  ./scripts/dimpact-image-scanner.sh --quickmode --use-discovered
  ```

- **Test Mode**: Scan only 3 images (for fast testing)

  ```bash
  ./scripts/dimpact-image-scanner.sh --testmode --use-discovered
  ```

- **Custom Output**:

  ```bash
  SEVERITY_THRESHOLD=HIGH OUTPUT_DIR=./my-results \
    ./scripts/dimpact-image-scanner.sh
  ```

---

## 📁 Project Structure

- `scripts/` — All automation scripts
- `dimpact-scan-results/` — Raw scan results (by date)
- `docs/data/` — Dashboard data (SARIF files)
- `docs/index.html` — Dashboard UI

---

## 📚 More Documentation

- [Commands Reference](COMMANDS_REFERENCE.md)
- [GitHub Pages Setup](GITHUB_PAGES_SETUP.md)
- [Quickmode Guide](QUICKMODE_GUIDE.md)
- [Container Config Examples](CONTAINER_CONFIG_EXAMPLES.md)

---

## 📝 License

See the main repository LICENSE file for details.
