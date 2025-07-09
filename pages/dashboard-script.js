// Dashboard Script - Security Report Data Parser with SARIF Support
class SecurityDashboard {
    constructor() {
        this.securityData = null;
        this.filteredData = null;
        this.dataFormat = 'sarif'; // SARIF-only format
        this.init();
    }

    async init() {
        try {
            await this.loadSecurityData();
            this.renderDashboard();
            this.setupEventListeners();
        } catch (error) {
            console.error('Dashboard initialization failed:', error);
            this.showError('Failed to load security data. Please try again later.');
        }
    }

    async loadSecurityData() {
        const loadingOverlay = document.getElementById('loadingOverlay');
        loadingOverlay.style.display = 'flex';

        try {
            // Load SARIF data directly from scan results
            console.log('Loading SARIF data from scan results...');
            const sarifData = await this.loadSarifData();
            
            if (sarifData && sarifData.images && sarifData.images.length > 0) {
                console.log('Successfully loaded SARIF data');
                this.securityData = sarifData;
                this.filteredData = [...this.securityData.images];
                this.dataFormat = 'sarif';
                return;
            }
            
            throw new Error('No SARIF data found in scan directories');
            
        } catch (error) {
            console.error('Error loading SARIF data:', error);
            // Load sample data for demo purposes
            console.log('Loading sample data for demonstration');
            this.securityData = this.createSampleData();
            this.filteredData = [...this.securityData.images];
            this.dataFormat = 'demo';
        } finally {
            loadingOverlay.style.display = 'none';
        }
    }

    async loadSarifData() {
        // Try to load SARIF files from common scan result directories
        const possibleDirs = [
            '../results/', 
            '../security-reports/latest/',
            '../local-scan-results/',
            './' + new Date().toISOString().slice(2,10).replace(/-/g, '') + '-dimpact-scan-results/'
        ];

        let allSarifData = [];
        let scanMetadata = null;
        
        for (const baseDir of possibleDirs) {
            try {
                // Try to get directory listing or known image patterns
                const commonImages = await this.discoverSarifFiles(baseDir);
                if (commonImages.length > 0) {
                    console.log(`Found SARIF files in ${baseDir}`);
                    allSarifData = await this.loadMultipleSarifFiles(baseDir, commonImages);
                    break;
                }
            } catch (error) {
                console.debug(`No SARIF data found in ${baseDir}:`, error);
                continue;
            }
        }

        if (allSarifData.length === 0) {
            throw new Error('No SARIF data found in any scan directories');
        }

        return this.aggregateSarifData(allSarifData, scanMetadata);
    }

    async discoverSarifFiles(baseDir) {
        // Common container image name patterns to look for
        const commonImagePatterns = [
            'docker-io-library-nginx-*',
            'docker-io-library-alpine-*', 
            'bitnami-*',
            'ghcr-io-*',
            'docker-io-*'
        ];

        const foundFiles = [];
        
        // Try known patterns and some common image directories
        for (const pattern of commonImagePatterns) {
            try {
                const response = await fetch(`${baseDir}${pattern}/trivy-results.sarif`);
                if (response.ok) {
                    foundFiles.push(pattern.replace('*', ''));
                }
            } catch (error) {
                // Continue checking other patterns
            }
        }

        // If no patterns work, try a few specific known directories
        const knownDirs = [
            'docker-io-library-nginx-1-27-4',
            'docker-io-library-alpine-3-20',
            'ghcr-io-infonl-zaakafhandelcomponent-3-5-0'
        ];

        for (const dir of knownDirs) {
            try {
                const response = await fetch(`${baseDir}${dir}/trivy-results.sarif`);
                if (response.ok) {
                    foundFiles.push(dir);
                }
            } catch (error) {
                // Continue checking
            }
        }

        return foundFiles;
    }

    async loadMultipleSarifFiles(baseDir, imageNames) {
        const sarifPromises = imageNames.map(async (imageName) => {
            try {
                const response = await fetch(`${baseDir}${imageName}/trivy-results.sarif`);
                if (!response.ok) return null;
                
                const sarifData = await response.json();
                return {
                    imageName: imageName,
                    sarif: sarifData
                };
            } catch (error) {
                console.warn(`Failed to load SARIF for ${imageName}:`, error);
                return null;
            }
        });

        const results = await Promise.all(sarifPromises);
        return results.filter(result => result !== null);
    }

    aggregateSarifData(sarifResults, metadata = null) {
        const data = {
            summary: {
                totalContainers: sarifResults.length,
                totalVulnerabilities: 0,
                critical: 0,
                high: 0,
                medium: 0,
                low: 0,
                scanDate: new Date().toISOString().split('T')[0],
                scanDuration: 'Unknown'
            },
            images: [],
            metadata: metadata,
            dataFormat: 'sarif'
        };

        sarifResults.forEach(({ imageName, sarif }) => {
            const imageData = this.parseSarifToImageData(imageName, sarif);
            data.images.push(imageData);
            
            // Add to summary totals
            data.summary.totalVulnerabilities += imageData.vulnerabilities.total;
            data.summary.critical += imageData.vulnerabilities.critical;
            data.summary.high += imageData.vulnerabilities.high;
            data.summary.medium += imageData.vulnerabilities.medium;
            data.summary.low += imageData.vulnerabilities.low;
        });

        return data;
    }

    parseSarifToImageData(imageName, sarifData) {
        const vulnerabilities = {
            critical: 0,
            high: 0,
            medium: 0,
            low: 0,
            total: 0
        };

        const detailedVulns = [];
        let imageMetadata = {};

        // Extract image metadata from SARIF properties (including age and EPSS information)
        let epssData = null;
        if (sarifData.runs && Array.isArray(sarifData.runs) && sarifData.runs[0]?.properties) {
            const props = sarifData.runs[0].properties;
            imageMetadata = {
                imageID: props.imageID || 'Unknown',
                imageName: props.imageName || imageName,
                createdDate: props.imageCreatedDate || null,
                ageDays: props.imageAgeDays || null,
                ageSeconds: props.imageAgeSeconds || null,
                ageText: props.imageAgeText || null,
                ageStatus: props.imageAgeStatus || 'unknown',
                scanTimestamp: props.scanTimestamp || null,
                ageMetadataVersion: props.ageMetadataVersion || null,
                repoDigests: props.repoDigests || [],
                repoTags: props.repoTags || []
            };
            
            // Extract EPSS data if available
            if (props.epss) {
                epssData = {
                    totalCves: props.epss.total_cves || 0,
                    highRiskCount: props.epss.high_risk_count || 0,
                    veryHighRiskCount: props.epss.very_high_risk_count || 0,
                    averageScore: props.epss.average_score || 0,
                    highRiskCves: props.epss.high_risk_cves || [],
                    veryHighRiskCves: props.epss.very_high_risk_cves || []
                };
            }
        }

        // Process SARIF results - iterate through all runs and their results
        if (sarifData.runs && Array.isArray(sarifData.runs)) {
            sarifData.runs.forEach(run => {
                if (run.results && Array.isArray(run.results)) {
                    run.results.forEach(result => {
                        // Map SARIF levels to our severity system
                        let severity = 'low';
                        switch (result.level) {
                            case 'error':
                                severity = 'critical';
                                vulnerabilities.critical++;
                                break;
                            case 'warning':
                                severity = 'high';
                                vulnerabilities.high++;
                                break;
                            case 'note':
                                severity = 'medium';
                                vulnerabilities.medium++;
                                break;
                            case 'info':
                            default:
                                severity = 'low';
                                vulnerabilities.low++;
                                break;
                        }

                        vulnerabilities.total++;

                        // Extract CVE ID from rule ID
                        const cveId = this.extractCveFromRuleId(result.ruleId || 'Unknown');
                        
                        // Build detailed vulnerability info
                        detailedVulns.push({
                            id: cveId,
                            severity: severity,
                            message: result.message?.text || 'No description available',
                            location: result.locations?.[0]?.physicalLocation?.artifactLocation?.uri || 'Unknown',
                            helpUri: this.getHelpUriFromSarif(run, result),
                            ruleId: result.ruleId
                        });
                    });
                }
            });
        }

        return {
            name: this.cleanImageName(imageName),
            vulnerabilities: vulnerabilities,
            status: this.getImageStatus(vulnerabilities.critical, vulnerabilities.high, vulnerabilities.medium, vulnerabilities.low),
            detailedVulnerabilities: detailedVulns,
            helmChart: this.extractHelmChart(imageName),
            scanFormat: 'sarif',
            metadata: imageMetadata,
            epss: epssData
        };
    }

    extractCveFromRuleId(ruleId) {
        // Extract CVE ID from SARIF rule ID
        const cveMatch = ruleId.match(/CVE-\d{4}-\d+/);
        return cveMatch ? cveMatch[0] : ruleId;
    }

    getHelpUriFromSarif(run, result) {
        // Try to get help URI from the rule definition
        if (result.ruleIndex !== undefined && run.tool?.driver?.rules) {
            const rule = run.tool.driver.rules[result.ruleIndex];
            return rule?.helpUri || 'No reference available';
        }
        return 'No reference available';
    }

    cleanImageName(imageName) {
        // Clean up image name for display
        return imageName
            .replace(/^docker-io-/, '')
            .replace(/^ghcr-io-/, '')
            .replace(/-\d+$/, '') // Remove trailing version numbers
            .replace(/-/g, '/'); // Convert hyphens back to slashes for readability
    }

    extractHelmChart(imageName) {
        // Try to extract helm chart name from image name patterns
        let chart_name = "";
        
        // Pattern 1: name-component (e.g., wordpress-mysql)
        if (imageName.match(/^([a-zA-Z0-9-]+)-[a-zA-Z0-9-]+$/)) {
            chart_name = imageName.match(/^([a-zA-Z0-9-]+)-[a-zA-Z0-9-]+$/)[1];
        }
        // Pattern 2: registry/namespace/chartname (e.g., docker.io/bitnami/wordpress)
        else if (imageName.match(/\/([a-zA-Z0-9-]+)$/)) {
            chart_name = imageName.match(/\/([a-zA-Z0-9-]+)$/)[1];
        }
        // Pattern 3: just use the base name if no pattern matches
        else {
            chart_name = imageName.replace(/[^a-zA-Z0-9-].*$/, '').replace(/-[0-9].*$/, '');
        }
        
        return chart_name || 'unknown';
    }

    parseMarkdownReport(markdown, metadata = null) {
        const data = {
            summary: {
                totalContainers: 0,
                totalVulnerabilities: 0,
                critical: 0,
                high: 0,
                medium: 0,
                low: 0,
                scanDate: 'Unknown',
                scanDuration: 'Unknown'
            },
            images: [],
            metadata: metadata
        };

        try {
            // Extract scan date from title
            const dateMatch = markdown.match(/# Security Scan Report - (\d{4}-\d{2}-\d{2})/);
            if (dateMatch) {
                data.summary.scanDate = dateMatch[1];
            }

            // Extract summary table data
            const summaryTableMatch = markdown.match(/## 📊 Summary Table\s*\n([\s\S]*?)\n\n/);
            if (summaryTableMatch) {
                const tableContent = summaryTableMatch[1];
                const totalRow = tableContent.match(/\|\s*\*\*Total\*\*\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|/);
                
                if (totalRow) {
                    data.summary.critical = parseInt(totalRow[2]) || 0;
                    data.summary.high = parseInt(totalRow[3]) || 0;
                    data.summary.medium = parseInt(totalRow[4]) || 0;
                    data.summary.low = parseInt(totalRow[5]) || 0;
                    data.summary.totalVulnerabilities = parseInt(totalRow[1]) || 0;
                }

                // Parse individual image rows
                const imageRows = tableContent.match(/\|\s*([^|]+?)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|/g);
                if (imageRows) {
                    imageRows.forEach(row => {
                        const match = row.match(/\|\s*([^|]+?)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|\s*(\d+)\s*\|/);
                        if (match && !match[1].includes('**Total**') && !match[1].includes('Image Name')) {
                            const imageName = match[1].trim();
                            const total = parseInt(match[2]) || 0;
                            const critical = parseInt(match[3]) || 0;
                            const high = parseInt(match[4]) || 0;
                            const medium = parseInt(match[5]) || 0;
                            const low = parseInt(match[6]) || 0;

                            data.images.push({
                                name: imageName,
                                vulnerabilities: {
                                    total,
                                    critical,
                                    high,
                                    medium,
                                    low
                                },
                                status: this.getImageStatus(critical, high, medium, low)
                            });
                        }
                    });
                }
            }

            data.summary.totalContainers = data.images.length;

            // Extract scan duration from metadata if available
            if (metadata && metadata.scan_duration) {
                data.summary.scanDuration = metadata.scan_duration;
            } else if (metadata && metadata.scanDuration) {
                data.summary.scanDuration = metadata.scanDuration;
            }

        } catch (error) {
            console.error('Error parsing markdown:', error);
        }

        return data;
    }

    getImageStatus(critical, high, medium, low) {
        if (critical > 0) return 'critical';
        if (high > 0) return 'high';
        if (medium > 0) return 'medium';
        if (low > 0) return 'low';
        return 'clean';
    }

    calculateSecurityScore() {
        const { critical, high, medium, low, totalVulnerabilities } = this.securityData.summary;
        
        // Handle edge cases
        if (!critical && !high && !medium && !low && !totalVulnerabilities) return 100;
        if (totalVulnerabilities === 0) return 100;
        
        // Ensure all values are numbers
        const safeCritical = Number(critical) || 0;
        const safeHigh = Number(high) || 0;
        const safeMedium = Number(medium) || 0;
        const safeLow = Number(low) || 0;
        const safeTotalVulns = Number(totalVulnerabilities) || 0;
        
        if (safeTotalVulns === 0) return 100;
        
        // Weighted scoring: Critical = 10 points, High = 5, Medium = 2, Low = 1
        const weightedVulns = (safeCritical * 10) + (safeHigh * 5) + (safeMedium * 2) + safeLow;
        const maxPossibleScore = safeTotalVulns * 10;
        
        if (maxPossibleScore === 0) return 100;
        
        const score = Math.max(0, Math.round(100 - ((weightedVulns / maxPossibleScore) * 100)));
        return isNaN(score) ? 0 : score;
    }

    renderDashboard() {
        this.renderSummaryCards();
        this.renderVulnerabilityBreakdown();
        this.renderImageTable();
        this.renderLastUpdated();
        this.checkForAlerts();
    }

    renderSummaryCards() {
        const { summary } = this.securityData;
        const securityScore = this.calculateSecurityScore();

        // Ensure we display the correct values
        document.getElementById('totalContainers').textContent = summary.totalContainers || 0;
        document.getElementById('totalVulnerabilities').textContent = summary.totalVulnerabilities || 0;
        document.getElementById('securityScore').textContent = `${securityScore}%`;
        
        // Handle scan duration with better fallbacks
        let scanDuration = summary.scanDuration;
        if (!scanDuration || scanDuration === 'Unknown') {
            // Try to get it from metadata
            if (this.securityData.metadata?.scan_duration) {
                scanDuration = this.securityData.metadata.scan_duration;
            } else if (this.securityData.metadata?.scanDuration) {
                scanDuration = this.securityData.metadata.scanDuration;
            } else if (this.securityData.test_mode || this.securityData.dashboard_test_mode) {
                scanDuration = 'Test Mode';
            } else {
                scanDuration = 'Not available';
            }
        }
        document.getElementById('scanDuration').textContent = scanDuration;

        // Add trend indicators (placeholder - would need historical data)
        this.renderTrendIndicator('containersChange', 0);
        this.renderTrendIndicator('vulnerabilitiesChange', 0);
    }

    renderTrendIndicator(elementId, change) {
        const element = document.getElementById(elementId);
        if (change > 0) {
            element.textContent = `+${change} from last scan`;
            element.className = 'metric-change positive';
        } else if (change < 0) {
            element.textContent = `${change} from last scan`;
            element.className = 'metric-change negative';
        } else {
            element.textContent = 'No change';
            element.className = 'metric-change';
        }
    }

    renderVulnerabilityBreakdown() {
        const { critical, high, medium, low, totalVulnerabilities } = this.securityData.summary;
        
        // Update counts
        document.getElementById('criticalCount').textContent = critical;
        document.getElementById('highCount').textContent = high;
        document.getElementById('mediumCount').textContent = medium;
        document.getElementById('lowCount').textContent = low;

        // Update progress bars
        if (totalVulnerabilities > 0) {
            this.updateProgressBar('criticalProgress', (critical / totalVulnerabilities) * 100);
            this.updateProgressBar('highProgress', (high / totalVulnerabilities) * 100);
            this.updateProgressBar('mediumProgress', (medium / totalVulnerabilities) * 100);
            this.updateProgressBar('lowProgress', (low / totalVulnerabilities) * 100);
        } else {
            this.updateProgressBar('criticalProgress', 0);
            this.updateProgressBar('highProgress', 0);
            this.updateProgressBar('mediumProgress', 0);
            this.updateProgressBar('lowProgress', 0);
        }
    }

    updateProgressBar(elementId, percentage) {
        const element = document.getElementById(elementId);
        element.style.width = `${percentage}%`;
    }

    renderImageTable() {
        const tableBody = document.getElementById('imagesTableBody');
        tableBody.innerHTML = '';

        if (this.filteredData.length === 0) {
            tableBody.innerHTML = `
                <tr>
                    <td colspan="9" style="text-align: center; padding: 2rem; color: var(--text-secondary);">
                        No images match the current filter criteria.
                    </td>
                </tr>
            `;
            return;
        }

        this.filteredData.forEach(image => {
            const row = document.createElement('tr');
            const { vulnerabilities, metadata } = image;
            
            // Format age display
            let ageDisplay = 'Unknown';
            let ageEmoji = '❓';
            if (metadata && metadata.ageText && metadata.ageStatus) {
                ageDisplay = metadata.ageText;
                switch (metadata.ageStatus) {
                    case 'very_recent':
                        ageEmoji = '✅';
                        break;
                    case 'recent':
                        ageEmoji = '🟢';
                        break;
                    case 'moderate':
                        ageEmoji = '🟡';
                        break;
                    case 'old':
                        ageEmoji = '🟠';
                        break;
                    case 'very_old':
                        ageEmoji = '🔴';
                        break;
                    default:
                        ageEmoji = '❓';
                }
            }
            
            row.innerHTML = `
                <td>
                    <div style="font-weight: 500;">${this.escapeHtml(image.name)}</div>
                </td>
                <td><span class="severity-count">${vulnerabilities.critical}</span></td>
                <td><span class="severity-count">${vulnerabilities.high}</span></td>
                <td><span class="severity-count">${vulnerabilities.medium}</span></td>
                <td><span class="severity-count">${vulnerabilities.low}</span></td>
                <td><strong>${vulnerabilities.total}</strong></td>
                <td>
                    <div style="display: flex; align-items: center; gap: 0.5rem;">
                        <span>${ageEmoji}</span>
                        <span style="font-size: 0.875rem;">${ageDisplay}</span>
                    </div>
                </td>
                <td><span class="status-badge ${image.status}">${this.capitalizeFirst(image.status)}</span></td>
                <td>
                    <button class="action-btn" onclick="dashboard.showImageDetails('${this.escapeHtml(image.name)}')">
                        View Details
                    </button>
                </td>
            `;
            
            tableBody.appendChild(row);
        });
    }

    renderLastUpdated() {
        const updateElement = document.getElementById('updateTime');
        
        if (this.securityData.metadata && this.securityData.metadata.scan_timestamp) {
            const date = new Date(this.securityData.metadata.scan_timestamp);
            updateElement.textContent = date.toLocaleString();
        } else if (this.securityData.summary.scanDate !== 'Unknown') {
            updateElement.textContent = this.securityData.summary.scanDate;
        } else {
            updateElement.textContent = 'Unknown';
        }

        // Show test mode indicator if in test mode
        if (this.securityData.test_mode || this.securityData.dashboard_test_mode) {
            const testIndicator = document.createElement('div');
            testIndicator.style.cssText = `
                position: absolute;
                top: 10px;
                right: 10px;
                background: #fbbf24;
                color: #92400e;
                padding: 4px 8px;
                border-radius: 4px;
                font-size: 0.75rem;
                font-weight: 600;
                z-index: 1000;
            `;
            testIndicator.textContent = '🧪 TEST MODE';
            testIndicator.title = 'Dashboard is displaying test/sample data';
            document.querySelector('.dashboard-header').style.position = 'relative';
            document.querySelector('.dashboard-header').appendChild(testIndicator);
        }
    }

    checkForAlerts() {
        const { critical, high } = this.securityData.summary;
        const alertBanner = document.getElementById('alertBanner');
        const alertMessage = document.getElementById('alertMessage');

        if (critical > 0) {
            alertMessage.textContent = `${critical} critical vulnerabilities require immediate attention.`;
            alertBanner.className = 'alert-banner critical';
            alertBanner.style.display = 'flex';
        } else if (high > 10) {
            alertMessage.textContent = `${high} high-severity vulnerabilities detected. Review and prioritize patching.`;
            alertBanner.className = 'alert-banner';
            alertBanner.style.display = 'flex';
        } else {
            alertBanner.style.display = 'none';
        }
    }

    setupEventListeners() {
        // Search functionality
        const searchInput = document.getElementById('searchInput');
        searchInput.addEventListener('input', (e) => {
            this.filterImages();
        });

        // Severity filter
        const severityFilter = document.getElementById('severityFilter');
        severityFilter.addEventListener('change', (e) => {
            this.filterImages();
        });

        // Refresh button
        const refreshBtn = document.getElementById('refreshBtn');
        refreshBtn.addEventListener('click', () => {
            this.loadSecurityData().then(() => {
                this.renderDashboard();
            });
        });
    }

    filterImages() {
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();
        const severityFilter = document.getElementById('severityFilter').value;

        this.filteredData = this.securityData.images.filter(image => {
            const matchesSearch = image.name.toLowerCase().includes(searchTerm);
            const matchesSeverity = !severityFilter || image.status === severityFilter;
            
            return matchesSearch && matchesSeverity;
        });

        this.renderImageTable();
    }

    showImageDetails(imageName) {
        const image = this.securityData.images.find(img => img.name === imageName);
        if (!image) return;

        const modal = document.getElementById('vulnerabilityModal');
        const modalTitle = document.getElementById('modalTitle');
        const modalDetails = document.getElementById('vulnerabilityDetails');

        modalTitle.textContent = `${imageName} - Vulnerability Details`;
        
        // Display SARIF format badge
        const dataFormatInfo = this.securityData.dataFormat === 'sarif' ? 
            '<div class="data-format-badge" style="background: #10b981; color: white; padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; margin-bottom: 1rem; display: inline-block;">📊 SARIF Format</div>' : 
            '<div class="data-format-badge" style="background: #f59e0b; color: white; padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; margin-bottom: 1rem; display: inline-block;">🧪 Demo Mode</div>';
        
        modalDetails.innerHTML = `
            ${dataFormatInfo}
            <div class="vulnerability-summary">
                <h4>🛡️ Vulnerability Summary</h4>
                <div class="summary-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(150px, 1fr)); gap: 1rem; margin: 1rem 0;">
                    <div class="summary-item">
                        <div style="font-size: 0.875rem; color: var(--text-secondary);">Critical</div>
                        <div style="font-size: 1.5rem; font-weight: 700; color: var(--critical-color);">${image.vulnerabilities.critical}</div>
                    </div>
                    <div class="summary-item">
                        <div style="font-size: 0.875rem; color: var(--text-secondary);">High</div>
                        <div style="font-size: 1.5rem; font-weight: 700; color: #d97706;">${image.vulnerabilities.high}</div>
                    </div>
                    <div class="summary-item">
                        <div style="font-size: 0.875rem; color: var(--text-secondary);">Medium</div>
                        <div style="font-size: 1.5rem; font-weight: 700; color: #7c3aed;">${image.vulnerabilities.medium}</div>
                    </div>
                    <div class="summary-item">
                        <div style="font-size: 0.875rem; color: var(--text-secondary);">Low</div>
                        <div style="font-size: 1.5rem; font-weight: 700; color: var(--success-color);">${image.vulnerabilities.low}</div>
                    </div>
                </div>
            </div>
            
            <div class="image-details">
                <h4>📦 Image Information</h4>
                <div style="margin: 1rem 0;">
                    <p><strong>Image Name:</strong> ${this.escapeHtml(imageName)}</p>
                    <p><strong>Security Status:</strong> <span class="status-badge ${image.status}">${this.capitalizeFirst(image.status)}</span></p>
                    <p><strong>Total Vulnerabilities:</strong> ${image.vulnerabilities.total}</p>
                    ${image.metadata && image.metadata.ageText ? `
                        <p><strong>Image Age:</strong> 
                            <span style="display: inline-flex; align-items: center; gap: 0.5rem;">
                                ${this.getAgeStatusEmoji(image.metadata.ageStatus)}
                                <span>${image.metadata.ageText}</span>
                                ${image.metadata.ageStatus === 'very_old' ? '<span style="color: #e53e3e; font-weight: bold;">(Very Old - Consider Updating)</span>' : ''}
                                ${image.metadata.ageStatus === 'old' ? '<span style="color: #d69e2e; font-weight: bold;">(Old - Review for Updates)</span>' : ''}
                            </span>
                        </p>
                        ${image.metadata.createdDate ? `<p><strong>Created:</strong> ${new Date(image.metadata.createdDate).toLocaleString()}</p>` : ''}
                    ` : ''}
                    ${image.helmChart ? `<p><strong>Helm Chart:</strong> ${image.helmChart}</p>` : ''}
                    ${image.scanFormat ? `<p><strong>Scan Format:</strong> ${image.scanFormat.toUpperCase()}</p>` : ''}
                    ${image.metadata && image.metadata.scanTimestamp ? `<p><strong>Scan Date:</strong> ${new Date(image.metadata.scanTimestamp).toLocaleString()}</p>` : ''}
                </div>
            </div>

            ${image.detailedVulnerabilities && image.detailedVulnerabilities.length > 0 ? `
            <div class="detailed-vulnerabilities" style="max-height: 300px; overflow-y: auto; border: 1px solid var(--border-color); border-radius: 0.5rem; padding: 1rem; margin: 1rem 0;">
                <h4>🔍 Detailed Vulnerabilities (Top 10)</h4>
                ${image.detailedVulnerabilities.slice(0, 10).map(vuln => `
                    <div class="vulnerability-item" style="border-bottom: 1px solid var(--border-light); padding: 0.75rem 0; margin-bottom: 0.75rem;">
                        <div class="vuln-header" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                            <span class="vuln-id" style="font-weight: 600; color: var(--primary-color);">${vuln.id}</span>
                            <span class="vuln-severity ${vuln.severity}" style="padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-size: 0.75rem; color: white; background: ${this.getSeverityColor(vuln.severity)};">${this.capitalizeFirst(vuln.severity)}</span>
                        </div>
                        <div class="vuln-description" style="font-size: 0.875rem; margin-bottom: 0.5rem;">${vuln.message || vuln.description || 'No description available'}</div>
                        ${vuln.location && vuln.location !== 'Unknown' ? `<div class="vuln-location" style="font-size: 0.75rem; color: var(--text-secondary);">📍 Location: ${vuln.location}</div>` : ''}
                        ${vuln.fixedVersion ? `<div class="vuln-fix" style="font-size: 0.75rem; color: var(--success-color);">✅ Fixed in: ${vuln.fixedVersion}</div>` : ''}
                        ${vuln.helpUri && vuln.helpUri !== 'No reference available' ? `<div class="vuln-reference" style="font-size: 0.75rem;"><a href="${vuln.helpUri}" target="_blank" rel="noopener" style="color: var(--primary-color);">🔗 View Reference</a></div>` : ''}
                    </div>
                `).join('')}
                ${image.detailedVulnerabilities.length > 10 ? `<div style="text-align: center; padding: 0.5rem; color: var(--text-secondary); font-size: 0.875rem;">... and ${image.detailedVulnerabilities.length - 10} more vulnerabilities</div>` : ''}
            </div>
            ` : ''}

            <div class="recommendations">
                <h4>💡 Recommendations</h4>
                <ul style="margin: 1rem 0; padding-left: 1.5rem;">
                    ${this.getRecommendations(image.vulnerabilities)}
                </ul>
            </div>

            ${this.securityData.dataFormat === 'sarif' ? `
            <div class="sarif-info" style="background: #f0f9ff; border: 1px solid #0ea5e9; border-radius: 0.5rem; padding: 1rem; margin: 1rem 0;">
                <h4 style="color: #0ea5e9; margin-bottom: 0.5rem;">📊 SARIF Benefits</h4>
                <ul style="font-size: 0.875rem; margin: 0; padding-left: 1.5rem;">
                    <li>Industry standard format for static analysis results</li>
                    <li>Rich metadata with detailed location information</li>
                    <li>Compatible with GitHub Security, Azure DevOps, and other platforms</li>
                    <li>Enhanced rule references and help URIs</li>
                </ul>
            </div>
            ` : this.securityData.dataFormat === 'demo' ? `
            <div class="demo-info" style="background: #fef3c7; border: 1px solid #f59e0b; border-radius: 0.5rem; padding: 1rem; margin: 1rem 0;">
                <h4 style="color: #92400e; margin-bottom: 0.5rem;">🧪 Demo Mode</h4>
                <p style="font-size: 0.875rem; margin: 0; color: #92400e;">This is sample data for demonstration. Run a scan to see real SARIF vulnerability data.</p>
            </div>
            ` : ''}

            <div class="actions">
                <h4>🚀 Next Steps</h4>
                <div style="margin-top: 1rem;">
                    <a href="../security-reports/latest/SCAN_REPORT.md" target="_blank" class="action-btn" style="margin-right: 1rem; text-decoration: none; padding: 0.5rem 1rem; background: var(--primary-color); color: white; border-radius: 0.25rem; display: inline-block;">View Full Report</a>
                    <button class="action-btn" onclick="navigator.clipboard.writeText('${this.escapeHtml(imageName)}').then(() => alert('Image name copied to clipboard!'))" style="padding: 0.5rem 1rem; background: var(--secondary-color); color: white; border: none; border-radius: 0.25rem; cursor: pointer;">Copy Image Name</button>
                </div>
            </div>
        `;

        modal.style.display = 'flex';
    }

    getSeverityColor(severity) {
        switch (severity) {
            case 'critical': return '#dc2626';
            case 'high': return '#d97706';
            case 'medium': return '#7c3aed';
            case 'low': return '#059669';
            default: return '#6b7280';
        }
    }

    getRecommendations(vulnerabilities) {
        const recommendations = [];
        
        if (vulnerabilities.critical > 0) {
            recommendations.push('<li><strong>Critical:</strong> Immediate patching required. Consider taking image offline until fixed.</li>');
        }
        if (vulnerabilities.high > 0) {
            recommendations.push('<li><strong>High:</strong> Schedule patching within 24-48 hours.</li>');
        }
        if (vulnerabilities.medium > 0) {
            recommendations.push('<li><strong>Medium:</strong> Include in next maintenance window.</li>');
        }
        if (vulnerabilities.low > 0) {
            recommendations.push('<li><strong>Low:</strong> Monitor and update during regular maintenance.</li>');
        }
        if (vulnerabilities.total === 0) {
            recommendations.push('<li><strong>Clean:</strong> No vulnerabilities detected. Continue monitoring.</li>');
        }

        return recommendations.join('');
    }

    closeModal() {
        document.getElementById('vulnerabilityModal').style.display = 'none';
    }

    closeAlert() {
        document.getElementById('alertBanner').style.display = 'none';
    }

    showError(message) {
        const alertBanner = document.getElementById('alertBanner');
        const alertMessage = document.getElementById('alertMessage');
        
        alertMessage.textContent = message;
        alertBanner.className = 'alert-banner critical';
        alertBanner.style.display = 'flex';
    }

    escapeHtml(text) {
        const div = document.createElement('div');
        div.textContent = text;
        return div.innerHTML;
    }

    capitalizeFirst(str) {
        return str.charAt(0).toUpperCase() + str.slice(1);
    }

    getAgeStatusEmoji(ageStatus) {
        switch (ageStatus) {
            case 'very_recent':
                return '✅';
            case 'recent':
                return '🟢';
            case 'moderate':
                return '🟡';
            case 'old':
                return '🟠';
            case 'very_old':
                return '🔴';
            default:
                return '❓';
        }
    }

    createSampleData() {
        // Sample data for demo when real data isn't available
        return {
            summary: {
                totalContainers: 6,
                totalVulnerabilities: 47,
                critical: 3,
                high: 12,
                medium: 18,
                low: 14,
                scanDate: new Date().toISOString().split('T')[0],
                scanDuration: '2m 34s'
            },
            images: [
                { name: 'nginx:latest', vulnerabilities: { total: 8, critical: 1, high: 2, medium: 3, low: 2 }, status: 'critical' },
                { name: 'wordpress:6.0', vulnerabilities: { total: 15, critical: 2, high: 5, medium: 6, low: 2 }, status: 'critical' },
                { name: 'mysql:8.0', vulnerabilities: { total: 12, critical: 0, high: 3, medium: 5, low: 4 }, status: 'high' },
                { name: 'redis:7.0', vulnerabilities: { total: 7, critical: 0, high: 2, medium: 3, low: 2 }, status: 'high' },
                { name: 'postgres:14', vulnerabilities: { total: 5, critical: 0, high: 0, medium: 1, low: 4 }, status: 'medium' },
                { name: 'apache:2.4', vulnerabilities: { total: 0, critical: 0, high: 0, medium: 0, low: 0 }, status: 'clean' }
            ],
            metadata: null
        };
    }
}

// Global functions
function closeModal() {
    document.getElementById('vulnerabilityModal').style.display = 'none';
}

function closeAlert() {
    document.getElementById('alertBanner').style.display = 'none';
}

function loadSecurityData() {
    if (window.dashboard) {
        window.dashboard.loadSecurityData().then(() => {
            window.dashboard.renderDashboard();
        });
    }
}

// Initialize dashboard when page loads
document.addEventListener('DOMContentLoaded', () => {
    window.dashboard = new SecurityDashboard();
}); 
