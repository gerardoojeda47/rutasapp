// Configuración del repositorio
const CONFIG = {
    owner: 'gerardoojeda47',
    repo: 'rutasapp',
    apiUrl: 'https://api.github.com/repos/gerardoojeda47/rutasapp/releases/latest'
};

// Estado de la aplicación
let latestRelease = null;

// Función principal para inicializar la página
document.addEventListener('DOMContentLoaded', function () {
    console.log('🚀 Iniciando RouWhite Download Page');
    loadLatestRelease();
});

// Cargar información del último release
async function loadLatestRelease() {
    try {
        showLoading();

        // Intentar obtener desde GitHub API
        const response = await fetch(CONFIG.apiUrl);

        if (!response.ok) {
            throw new Error(`HTTP ${response.status}: ${response.statusText}`);
        }

        latestRelease = await response.json();
        console.log('✅ Release obtenido:', latestRelease);

        updateUI();
        generateQR();

    } catch (error) {
        console.error('❌ Error al obtener release:', error);
        handleError(error);
    }
}

// Mostrar estado de carga
function showLoading() {
    document.getElementById('qr-loading').style.display = 'flex';
    document.getElementById('qr-canvas').style.display = 'none';
    document.getElementById('qr-error').style.display = 'none';
    document.getElementById('download-loading').style.display = 'block';
    document.getElementById('download-link').style.display = 'none';
}

// Actualizar interfaz con información del release
function updateUI() {
    if (!latestRelease) return;

    // Actualizar información de versión
    const versionElement = document.getElementById('version-number');
    const dateElement = document.getElementById('release-date');
    const downloadLink = document.getElementById('download-link');

    if (versionElement) {
        versionElement.textContent = latestRelease.tag_name || 'Desconocida';
    }

    if (dateElement) {
        const date = new Date(latestRelease.published_at);
        dateElement.textContent = date.toLocaleDateString('es-ES', {
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }

    // Encontrar el APK en los assets
    const apkAsset = latestRelease.assets?.find(asset =>
        asset.name.endsWith('.apk') || asset.content_type === 'application/vnd.android.package-archive'
    );

    if (apkAsset && downloadLink) {
        downloadLink.href = apkAsset.browser_download_url;
        downloadLink.style.display = 'inline-block';
        document.getElementById('download-loading').style.display = 'none';

        // Actualizar nombre del botón con el nombre del archivo
        downloadLink.innerHTML = `📥 ${apkAsset.name}`;
    }
}

// Generar código QR
async function generateQR() {
    if (!latestRelease) {
        console.error('❌ No hay release disponible para generar QR');
        return;
    }

    try {
        // Encontrar el APK
        const apkAsset = latestRelease.assets?.find(asset =>
            asset.name.endsWith('.apk') || asset.content_type === 'application/vnd.android.package-archive'
        );

        if (!apkAsset) {
            throw new Error('No se encontró archivo APK en el release');
        }

        const canvas = document.getElementById('qr-canvas');

        // Generar QR code
        await QRCode.toCanvas(canvas, apkAsset.browser_download_url, {
            width: 256,
            height: 256,
            margin: 2,
            color: {
                dark: '#333333',
                light: '#FFFFFF'
            },
            errorCorrectionLevel: 'M'
        });

        // Mostrar QR y ocultar loading
        document.getElementById('qr-loading').style.display = 'none';
        document.getElementById('qr-error').style.display = 'none';
        canvas.style.display = 'block';

        console.log('✅ QR Code generado exitosamente');

    } catch (error) {
        console.error('❌ Error al generar QR:', error);
        showQRError();
    }
}

// Mostrar error en QR
function showQRError() {
    document.getElementById('qr-loading').style.display = 'none';
    document.getElementById('qr-canvas').style.display = 'none';
    document.getElementById('qr-error').style.display = 'flex';
}

// Manejar errores generales
function handleError(error) {
    console.error('❌ Error general:', error);

    // Mostrar error en QR
    showQRError();

    // Mostrar mensaje de error en descarga directa
    const downloadLoading = document.getElementById('download-loading');
    if (downloadLoading) {
        downloadLoading.innerHTML = `
            <div style="color: #ff6b6b; text-align: center;">
                <p>❌ Error al cargar la información de descarga</p>
                <p style="font-size: 0.9rem; margin-top: 5px;">
                    Intenta recargar la página o visita el 
                    <a href="https://github.com/${CONFIG.owner}/${CONFIG.repo}/releases" target="_blank" style="color: #667eea;">
                        repositorio en GitHub
                    </a>
                </p>
            </div>
        `;
    }

    // Actualizar información de versión con error
    const versionElement = document.getElementById('version-number');
    const dateElement = document.getElementById('release-date');

    if (versionElement) versionElement.textContent = 'Error al cargar';
    if (dateElement) dateElement.textContent = 'Error al cargar';
}

// Función para reintentar (llamada desde el botón)
function retryLoad() {
    console.log('🔄 Reintentando cargar release...');
    loadLatestRelease();
}

// Función global para regenerar QR (llamada desde HTML)
window.generateQR = function () {
    console.log('🔄 Regenerando QR code...');
    if (latestRelease) {
        generateQR();
    } else {
        loadLatestRelease();
    }
};

// Analytics simples (opcional)
function trackDownload() {
    console.log('📊 Descarga iniciada');
    // Aquí podrías agregar Google Analytics o similar
}

// Event listeners para tracking
document.addEventListener('click', function (e) {
    if (e.target.id === 'download-link') {
        trackDownload();
    }
});

// Función para verificar actualizaciones periódicamente (opcional)
function startPeriodicCheck() {
    // Verificar cada 5 minutos si hay una nueva versión
    setInterval(async () => {
        try {
            const response = await fetch(CONFIG.apiUrl);
            if (response.ok) {
                const newRelease = await response.json();
                if (newRelease.tag_name !== latestRelease?.tag_name) {
                    console.log('🆕 Nueva versión disponible:', newRelease.tag_name);
                    // Mostrar notificación o actualizar automáticamente
                    showUpdateNotification(newRelease);
                }
            }
        } catch (error) {
            console.log('ℹ️ Error en verificación periódica (normal):', error.message);
        }
    }, 5 * 60 * 1000); // 5 minutos
}

// Mostrar notificación de actualización
function showUpdateNotification(newRelease) {
    const notification = document.createElement('div');
    notification.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #4CAF50;
        color: white;
        padding: 15px 20px;
        border-radius: 10px;
        box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        z-index: 1000;
        animation: slideIn 0.3s ease;
    `;

    notification.innerHTML = `
        <div style="display: flex; align-items: center; gap: 10px;">
            <span>🆕</span>
            <div>
                <strong>Nueva versión disponible!</strong>
                <br>
                <small>${newRelease.tag_name}</small>
            </div>
            <button onclick="location.reload()" style="
                background: rgba(255,255,255,0.2);
                border: none;
                color: white;
                padding: 5px 10px;
                border-radius: 5px;
                cursor: pointer;
            ">
                Actualizar
            </button>
        </div>
    `;

    document.body.appendChild(notification);

    // Auto-remover después de 10 segundos
    setTimeout(() => {
        notification.remove();
    }, 10000);
}

// Iniciar verificación periódica (opcional, comentado por defecto)
// startPeriodicCheck();