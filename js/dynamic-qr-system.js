/**
 * Dynamic QR System for RouWhite App Distribution
 * Handles automatic QR code generation and GitHub API integration
 */

class DynamicQRSystem {
    constructor(config = {}) {
        // Configuration
        this.config = {
            githubRepo: 'gerardoojeda47/rutasapp',
            updateInterval: 30000, // 30 seconds
            maxRetries: 3,
            retryDelay: 5000,
            qrOptions: {
                width: 256,
                margin: 2,
                color: {
                    dark: '#FF6A00',
                    light: '#FFFFFF'
                },
                errorCorrectionLevel: 'M'
            },
            ...config
        };

        // API endpoints
        this.githubAPI = `https://api.github.com/repos/${this.config.githubRepo}`;

        // DOM elements
        this.elements = {
            qrCanvas: document.getElementById('qr-canvas'),
            qrStatus: document.getElementById('qr-status'),
            qrWrapper: document.getElementById('qr-wrapper'),
            downloadBtn: document.getElementById('download-btn'),
            updateIndicator: document.getElementById('update-indicator'),
            versionNumber: document.getElementById('version-number'),
            buildType: document.getElementById('build-type'),
            apkSize: document.getElementById('apk-size'),
            buildDate: document.getElementById('build-date')
        };

        // State
        this.state = {
            currentRelease: null,
            retryCount: 0,
            isUpdating: false,
            lastUpdateTime: null,
            updateTimer: null
        };

        // Initialize
        this.init();
    }

    async init() {
        console.log('🚀 Initializing Dynamic QR System...');
        console.log('📊 Configuration:', this.config);

        try {
            await this.updateReleaseInfo();
            this.startPeriodicUpdates();
            this.setupEventListeners();
            console.log('✅ Dynamic QR System initialized successfully');
        } catch (error) {
            console.error('❌ Failed to initialize Dynamic QR System:', error);
            this.handleError(error);
        }
    }

    /**
     * Fetch latest release from GitHub API
     */
    async fetchLatestRelease() {
        try {
            console.log('📡 Fetching latest release from GitHub API...');

            const response = await fetch(`${this.githubAPI}/releases/latest`, {
                headers: {
                    'Accept': 'application/vnd.github.v3+json',
                    'User-Agent': 'RouWhite-Distribution-System'
                }
            });

            if (!response.ok) {
                throw new Error(`GitHub API responded with status: ${response.status} ${response.statusText}`);
            }

            const release = await response.json();
            console.log('📦 Release data received:', {
                tag: release.tag_name,
                published: release.published_at,
                assets: release.assets.length
            });

            // Find the best APK asset (prefer release over debug)
            const apkAssets = release.assets.filter(asset => asset.name.endsWith('.apk'));

            if (apkAssets.length === 0) {
                throw new Error('No APK assets found in release');
            }

            // Prioritize release APK over debug
            const apkAsset = apkAssets.find(asset =>
                asset.name.includes('Release') || !asset.name.includes('Debug')
            ) || apkAssets[0];

            console.log('📱 Selected APK asset:', apkAsset.name);

            return {
                version: release.tag_name,
                downloadUrl: apkAsset.browser_download_url,
                publishedAt: release.published_at,
                body: release.body,
                size: apkAsset.size,
                name: apkAsset.name,
                commitHash: release.target_commitish,
                buildType: this.extractBuildType(apkAsset.name),
                releaseNotes: this.parseReleaseNotes(release.body)
            };
        } catch (error) {
            console.error('❌ Error fetching GitHub release:', error);
            throw error;
        }
    }

    /**
     * Check for local build information file
     */
    async checkLocalBuildInfo() {
        try {
            console.log('📄 Checking for local build info...');

            const response = await fetch('./latest-build.txt', {
                cache: 'no-cache'
            });

            if (!response.ok) {
                throw new Error('Local build info not found');
            }

            const text = await response.text();
            const info = this.parseLocalBuildInfo(text);

            if (!info.DOWNLOAD_URL) {
                throw new Error('Invalid local build info format');
            }

            console.log('📄 Local build info loaded:', info);

            return {
                version: info.VERSION || 'Unknown',
                downloadUrl: info.DOWNLOAD_URL,
                publishedAt: info.BUILD_DATE || new Date().toISOString(),
                size: info.SIZE_MB ? parseInt(info.SIZE_MB) * 1024 * 1024 : 0,
                buildType: info.BUILD_TYPE || 'Local',
                commitHash: info.COMMIT_HASH || 'Unknown',
                name: `RouWhite-${info.VERSION || 'local'}.apk`
            };
        } catch (error) {
            console.log('ℹ️ Local build info not available:', error.message);
            throw error;
        }
    }

    /**
     * Get fallback information when all other sources fail
     */
    getFallbackInfo() {
        console.log('🔄 Using fallback information...');

        return {
            version: 'v1.0.6+7',
            downloadUrl: './app-release.apk',
            publishedAt: new Date().toISOString(),
            size: 0,
            buildType: 'Fallback',
            commitHash: 'Unknown',
            name: 'RouWhite-fallback.apk'
        };
    }

    /**
     * Update release information from available sources
     */
    async updateReleaseInfo() {
        if (this.state.isUpdating) {
            console.log('⏳ Update already in progress, skipping...');
            return;
        }

        this.state.isUpdating = true;

        try {
            this.updateStatus('loading', 'Obteniendo información de la última versión...');
            this.setUpdateIndicator('updating');

            let release = null;

            // Try GitHub API first
            try {
                release = await this.fetchLatestRelease();
                console.log('✅ Using GitHub API data');
            } catch (error) {
                console.log('⚠️ GitHub API failed, trying local build info...');

                // Fallback to local build info
                try {
                    release = await this.checkLocalBuildInfo();
                    console.log('✅ Using local build info');
                } catch (localError) {
                    console.log('⚠️ Local build info failed, using fallback...');
                    release = this.getFallbackInfo();
                    console.log('✅ Using fallback data');
                }
            }

            // Check if this is actually a new release
            if (this.state.currentRelease &&
                this.state.currentRelease.version === release.version &&
                this.state.currentRelease.downloadUrl === release.downloadUrl) {
                console.log('ℹ️ No changes detected, skipping update');
                this.updateStatus('success', 'Información actualizada (sin cambios)');
                this.setUpdateIndicator('success');
                return;
            }

            this.state.currentRelease = release;
            this.state.lastUpdateTime = new Date();

            await this.generateQR(release.downloadUrl);
            this.updateUI(release);
            this.updateStatus('success', 'Código QR actualizado correctamente');
            this.setUpdateIndicator('success');
            this.state.retryCount = 0;

            console.log('✅ Release information updated successfully');

        } catch (error) {
            console.error('❌ Error updating release info:', error);
            this.handleError(error);
        } finally {
            this.state.isUpdating = false;
        }
    }

    /**
     * Generate QR code for the given URL
     */
    async generateQR(url) {
        try {
            console.log('🔲 Generating QR code for:', url);

            if (!this.elements.qrCanvas) {
                throw new Error('QR canvas element not found');
            }

            await QRCode.toCanvas(this.elements.qrCanvas, url, this.config.qrOptions);

            if (this.elements.qrWrapper) {
                this.elements.qrWrapper.style.display = 'block';
            }

            console.log('✅ QR code generated successfully');

        } catch (error) {
            console.error('❌ Error generating QR code:', error);
            throw error;
        }
    }

    /**
     * Update UI elements with release information
     */
    updateUI(release) {
        try {
            // Update download button
            if (this.elements.downloadBtn) {
                this.elements.downloadBtn.href = release.downloadUrl;
                this.elements.downloadBtn.textContent = `📱 Descargar ${release.version}`;
                this.elements.downloadBtn.disabled = false;
                this.elements.downloadBtn.download = release.name;
            }

            // Update version information
            if (this.elements.versionNumber) {
                this.elements.versionNumber.textContent = release.version;
            }

            if (this.elements.buildType) {
                this.elements.buildType.textContent = release.buildType || 'Release';
            }

            if (this.elements.apkSize) {
                this.elements.apkSize.textContent = release.size ?
                    `${(release.size / (1024 * 1024)).toFixed(1)} MB` : 'Desconocido';
            }

            if (this.elements.buildDate) {
                this.elements.buildDate.textContent =
                    new Date(release.publishedAt).toLocaleDateString('es-CO', {
                        year: 'numeric',
                        month: 'long',
                        day: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit'
                    });
            }

            console.log('✅ UI updated with release information');

        } catch (error) {
            console.error('❌ Error updating UI:', error);
        }
    }

    /**
     * Update status indicator
     */
    updateStatus(type, message) {
        if (!this.elements.qrStatus) return;

        this.elements.qrStatus.className = `qr-status ${type}`;

        const icons = {
            loading: '<div class="loading-spinner"></div>',
            success: '✅',
            error: '❌'
        };

        const icon = icons[type] || '';
        this.elements.qrStatus.innerHTML = `${icon}<span>${message}</span>`;
    }

    /**
     * Set update indicator status
     */
    setUpdateIndicator(status) {
        if (!this.elements.updateIndicator) return;

        const indicators = {
            updating: '🔄',
            success: '✅',
            error: '❌'
        };

        this.elements.updateIndicator.textContent = indicators[status] || '🔄';
    }

    /**
     * Handle errors with retry logic
     */
    handleError(error) {
        console.error('🚨 Handling error:', error);

        this.updateStatus('error', 'Error al cargar información. Reintentando...');
        this.setUpdateIndicator('error');

        if (this.state.retryCount < this.config.maxRetries) {
            this.state.retryCount++;
            const delay = this.config.retryDelay * this.state.retryCount;

            console.log(`🔄 Retry attempt ${this.state.retryCount}/${this.config.maxRetries} in ${delay}ms`);

            setTimeout(() => {
                this.updateReleaseInfo();
            }, delay);
        } else {
            console.log('❌ Max retries reached, using fallback');
            this.updateStatus('error', 'No se pudo cargar información. Usando datos locales.');

            // Use fallback as last resort
            const fallbackRelease = this.getFallbackInfo();
            this.state.currentRelease = fallbackRelease;
            this.generateQR(fallbackRelease.downloadUrl).catch(console.error);
            this.updateUI(fallbackRelease);
        }
    }

    /**
     * Start periodic updates
     */
    startPeriodicUpdates() {
        console.log(`🔄 Starting periodic updates every ${this.config.updateInterval / 1000} seconds`);

        this.state.updateTimer = setInterval(() => {
            console.log('🔄 Periodic update check...');
            this.updateReleaseInfo();
        }, this.config.updateInterval);
    }

    /**
     * Stop periodic updates
     */
    stopPeriodicUpdates() {
        if (this.state.updateTimer) {
            clearInterval(this.state.updateTimer);
            this.state.updateTimer = null;
            console.log('⏹️ Periodic updates stopped');
        }
    }

    /**
     * Setup event listeners
     */
    setupEventListeners() {
        // Handle visibility change to update when user returns to tab
        document.addEventListener('visibilitychange', () => {
            if (!document.hidden && this.state.lastUpdateTime) {
                const timeSinceUpdate = Date.now() - this.state.lastUpdateTime.getTime();

                // Update if more than 5 minutes have passed
                if (timeSinceUpdate > 5 * 60 * 1000) {
                    console.log('👁️ Page became visible after long absence, checking for updates...');
                    setTimeout(() => this.updateReleaseInfo(), 1000);
                }
            }
        });

        // Handle online/offline events
        window.addEventListener('online', () => {
            console.log('🌐 Connection restored, checking for updates...');
            setTimeout(() => this.updateReleaseInfo(), 2000);
        });

        window.addEventListener('offline', () => {
            console.log('📴 Connection lost, updates paused');
        });
    }

    /**
     * Utility methods
     */
    extractBuildType(filename) {
        if (filename.includes('Release')) return 'Release';
        if (filename.includes('Debug')) return 'Debug';
        if (filename.includes('Profile')) return 'Profile';
        return 'Release';
    }

    parseReleaseNotes(body) {
        if (!body) return '';

        // Extract key points from release notes
        const lines = body.split('\n').filter(line => line.trim());
        const keyPoints = lines.filter(line =>
            line.includes('✅') || line.includes('🔧') || line.includes('📱')
        ).slice(0, 5);

        return keyPoints.join('\n');
    }

    parseLocalBuildInfo(text) {
        const info = {};
        text.split('\n').forEach(line => {
            const [key, value] = line.split('=');
            if (key && value) {
                info[key.trim()] = value.trim();
            }
        });
        return info;
    }

    /**
     * Public API methods
     */
    async forceUpdate() {
        console.log('🔄 Force update requested');
        this.state.retryCount = 0;
        await this.updateReleaseInfo();
    }

    getCurrentRelease() {
        return this.state.currentRelease;
    }

    getSystemStatus() {
        return {
            isUpdating: this.state.isUpdating,
            lastUpdateTime: this.state.lastUpdateTime,
            retryCount: this.state.retryCount,
            currentRelease: this.state.currentRelease
        };
    }

    destroy() {
        console.log('🗑️ Destroying Dynamic QR System...');
        this.stopPeriodicUpdates();
        // Remove event listeners if needed
    }
}

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = DynamicQRSystem;
} else {
    window.DynamicQRSystem = DynamicQRSystem;
}