/**
 * Download Manager for RouWhite App Distribution
 * Handles download link validation, verification, and fallback mechanisms
 */

class DownloadManager {
    constructor(config = {}) {
        this.config = {
            maxRetries: 3,
            retryDelay: 2000,
            timeoutMs: 10000,
            fallbackUrls: [
                './app-release.apk',
                'https://github.com/gerardoojeda47/rutasapp/releases/latest/download/app-release.apk'
            ],
            ...config
        };

        this.state = {
            currentUrl: null,
            isValidating: false,
            lastValidation: null,
            validationCache: new Map()
        };
    }

    /**
     * Validate if a download URL is accessible and returns a valid APK
     */
    async validateDownloadUrl(url, options = {}) {
        const cacheKey = url;
        const maxCacheAge = options.maxCacheAge || 5 * 60 * 1000; // 5 minutes

        // Check cache first
        if (this.state.validationCache.has(cacheKey)) {
            const cached = this.state.validationCache.get(cacheKey);
            if (Date.now() - cached.timestamp < maxCacheAge) {
                console.log('📋 Using cached validation result for:', url);
                return cached.result;
            }
        }

        console.log('🔍 Validating download URL:', url);

        try {
            const controller = new AbortController();
            const timeoutId = setTimeout(() => controller.abort(), this.config.timeoutMs);

            const response = await fetch(url, {
                method: 'HEAD',
                signal: controller.signal,
                headers: {
                    'User-Agent': 'RouWhite-Download-Validator'
                }
            });

            clearTimeout(timeoutId);

            const result = {
                isValid: response.ok,
                status: response.status,
                statusText: response.statusText,
                contentLength: parseInt(response.headers.get('content-length')) || 0,
                contentType: response.headers.get('content-type') || '',
                lastModified: response.headers.get('last-modified'),
                etag: response.headers.get('etag')
            };

            // Additional validation for APK files
            if (result.isValid) {
                result.isValidAPK = this.validateAPKResponse(result);
                result.sizeFormatted = this.formatFileSize(result.contentLength);
            }

            // Cache the result
            this.state.validationCache.set(cacheKey, {
                result,
                timestamp: Date.now()
            });

            console.log('✅ URL validation result:', result);
            return result;

        } catch (error) {
            console.error('❌ URL validation failed:', error);

            const result = {
                isValid: false,
                error: error.message,
                isTimeout: error.name === 'AbortError'
            };

            // Cache failed results for shorter time
            this.state.validationCache.set(cacheKey, {
                result,
                timestamp: Date.now()
            });

            return result;
        }
    }

    /**
     * Validate APK-specific response characteristics
     */
    validateAPKResponse(response) {
        // Check content type
        const contentType = response.contentType.toLowerCase();
        const validContentTypes = [
            'application/vnd.android.package-archive',
            'application/octet-stream',
            'application/java-archive'
        ];

        const hasValidContentType = validContentTypes.some(type =>
            contentType.includes(type)
        );

        // Check file size (APK should be at least 1MB)
        const hasReasonableSize = response.contentLength > 1024 * 1024;

        return {
            hasValidContentType,
            hasReasonableSize,
            isValid: hasValidContentType && hasReasonableSize,
            details: {
                contentType: response.contentType,
                size: response.contentLength,
                sizeFormatted: this.formatFileSize(response.contentLength)
            }
        };
    }

    /**
     * Find the best working download URL from multiple sources
     */
    async findBestDownloadUrl(urls, options = {}) {
        console.log('🔍 Finding best download URL from:', urls);

        const results = [];

        for (const url of urls) {
            try {
                const validation = await this.validateDownloadUrl(url, options);
                results.push({
                    url,
                    validation,
                    score: this.calculateUrlScore(validation)
                });

                // If we find a perfect URL, return it immediately
                if (validation.isValid && validation.isValidAPK?.isValid) {
                    console.log('✅ Found perfect download URL:', url);
                    return {
                        url,
                        validation,
                        allResults: results
                    };
                }
            } catch (error) {
                console.error('❌ Error validating URL:', url, error);
                results.push({
                    url,
                    validation: { isValid: false, error: error.message },
                    score: 0
                });
            }
        }

        // Sort by score and return the best one
        results.sort((a, b) => b.score - a.score);
        const best = results[0];

        console.log('📊 URL validation results:', results);
        console.log('🏆 Best URL selected:', best?.url);

        return {
            url: best?.url,
            validation: best?.validation,
            allResults: results
        };
    }

    /**
     * Calculate a score for URL quality (higher is better)
     */
    calculateUrlScore(validation) {
        if (!validation.isValid) return 0;

        let score = 100; // Base score for valid URLs

        // Bonus for valid APK characteristics
        if (validation.isValidAPK?.isValid) {
            score += 50;
        }

        // Bonus for reasonable file size
        if (validation.contentLength > 5 * 1024 * 1024) { // > 5MB
            score += 25;
        }

        // Bonus for HTTPS
        if (validation.url?.startsWith('https://')) {
            score += 10;
        }

        // Penalty for very small files
        if (validation.contentLength < 1024 * 1024) { // < 1MB
            score -= 30;
        }

        return Math.max(0, score);
    }

    /**
     * Create a robust download link with fallback handling
     */
    async createRobustDownloadLink(primaryUrl, fallbackUrls = []) {
        const allUrls = [primaryUrl, ...fallbackUrls, ...this.config.fallbackUrls]
            .filter(url => url && typeof url === 'string');

        const bestUrl = await this.findBestDownloadUrl(allUrls);

        return {
            primaryUrl: bestUrl.url,
            fallbackUrls: bestUrl.allResults
                .filter(result => result.url !== bestUrl.url && result.validation.isValid)
                .map(result => result.url),
            validation: bestUrl.validation,
            allResults: bestUrl.allResults
        };
    }

    /**
     * Handle download with automatic fallback
     */
    async handleDownload(url, options = {}) {
        console.log('📥 Initiating download:', url);

        try {
            // Validate URL first
            const validation = await this.validateDownloadUrl(url);

            if (!validation.isValid) {
                throw new Error(`Download URL is not accessible: ${validation.error || validation.statusText}`);
            }

            // Create download link
            const link = document.createElement('a');
            link.href = url;
            link.download = options.filename || this.extractFilenameFromUrl(url);

            // Trigger download
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);

            console.log('✅ Download initiated successfully');
            return { success: true, url, validation };

        } catch (error) {
            console.error('❌ Download failed:', error);

            // Try fallback URLs if available
            if (options.fallbackUrls && options.fallbackUrls.length > 0) {
                console.log('🔄 Trying fallback URLs...');

                for (const fallbackUrl of options.fallbackUrls) {
                    try {
                        return await this.handleDownload(fallbackUrl, {
                            ...options,
                            fallbackUrls: [] // Prevent infinite recursion
                        });
                    } catch (fallbackError) {
                        console.error('❌ Fallback URL also failed:', fallbackUrl, fallbackError);
                    }
                }
            }

            throw error;
        }
    }

    /**
     * Monitor download progress (for supported browsers)
     */
    async monitorDownload(url, options = {}) {
        const onProgress = options.onProgress || (() => { });
        const onComplete = options.onComplete || (() => { });
        const onError = options.onError || (() => { });

        try {
            const response = await fetch(url);

            if (!response.ok) {
                throw new Error(`Download failed: ${response.status} ${response.statusText}`);
            }

            const contentLength = parseInt(response.headers.get('content-length')) || 0;
            const reader = response.body.getReader();
            const chunks = [];
            let receivedLength = 0;

            while (true) {
                const { done, value } = await reader.read();

                if (done) break;

                chunks.push(value);
                receivedLength += value.length;

                const progress = contentLength > 0 ? (receivedLength / contentLength) * 100 : 0;
                onProgress({ receivedLength, contentLength, progress });
            }

            // Combine chunks into blob
            const blob = new Blob(chunks);
            const downloadUrl = URL.createObjectURL(blob);

            // Create download link
            const link = document.createElement('a');
            link.href = downloadUrl;
            link.download = options.filename || this.extractFilenameFromUrl(url);

            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);

            // Clean up
            URL.revokeObjectURL(downloadUrl);

            onComplete({ success: true, size: receivedLength });
            return { success: true, size: receivedLength };

        } catch (error) {
            console.error('❌ Download monitoring failed:', error);
            onError(error);
            throw error;
        }
    }

    /**
     * Utility methods
     */
    extractFilenameFromUrl(url) {
        try {
            const urlObj = new URL(url);
            const pathname = urlObj.pathname;
            const filename = pathname.split('/').pop();
            return filename || 'RouWhite.apk';
        } catch {
            return 'RouWhite.apk';
        }
    }

    formatFileSize(bytes) {
        if (bytes === 0) return '0 B';

        const k = 1024;
        const sizes = ['B', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));

        return parseFloat((bytes / Math.pow(k, i)).toFixed(1)) + ' ' + sizes[i];
    }

    /**
     * Clear validation cache
     */
    clearCache() {
        this.state.validationCache.clear();
        console.log('🗑️ Download validation cache cleared');
    }

    /**
     * Get cache statistics
     */
    getCacheStats() {
        return {
            size: this.state.validationCache.size,
            entries: Array.from(this.state.validationCache.entries()).map(([url, data]) => ({
                url,
                timestamp: data.timestamp,
                age: Date.now() - data.timestamp,
                isValid: data.result.isValid
            }))
        };
    }
}

// Export for use in other scripts
if (typeof module !== 'undefined' && module.exports) {
    module.exports = DownloadManager;
} else {
    window.DownloadManager = DownloadManager;
}