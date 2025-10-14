# Requirements Document - Distribución Simple con QR

## Introducción

Este documento define los requisitos para implementar un sistema de distribución simple de la aplicación Flutter mediante GitHub Releases y GitHub Pages. El sistema generará automáticamente un APK con cada commit, lo subirá como release en GitHub, y creará una página web con QR code para descarga directa.

## Requirements

### Requirement 1

**User Story:** Como desarrollador, quiero que cada commit genere automáticamente un APK y lo suba como GitHub Release, para que esté disponible para descarga inmediata.

#### Acceptance Criteria

1. WHEN se hace push a la rama main THEN GitHub Actions SHALL compilar automáticamente el APK
2. WHEN la compilación es exitosa THEN el sistema SHALL crear un nuevo GitHub Release
3. WHEN se crea el release THEN el APK SHALL estar disponible para descarga pública
4. IF la compilación falla THEN el sistema SHALL mantener el release anterior disponible

### Requirement 2

**User Story:** Como usuario final, quiero escanear un código QR, para que pueda descargar directamente el APK más reciente sin complicaciones.

#### Acceptance Criteria

1. WHEN accedo a la página de distribución THEN el sistema SHALL mostrar un QR code actualizado
2. WHEN escaneo el QR code THEN mi dispositivo SHALL iniciar la descarga del APK más reciente
3. WHEN se descarga el APK THEN puedo instalarlo directamente en mi dispositivo
4. IF hay una nueva versión THEN el QR code SHALL apuntar automáticamente a la versión más reciente

### Requirement 3

**User Story:** Como administrador, quiero tener una página web simple de distribución, para que los usuarios puedan acceder fácilmente a la aplicación.

#### Acceptance Criteria

1. WHEN accedo a la URL de GitHub Pages THEN el sistema SHALL mostrar la página de distribución
2. WHEN hay un nuevo release THEN la página SHALL actualizarse automáticamente
3. WHEN se muestra la información THEN SHALL incluir versión actual, fecha y enlace directo
4. IF no hay releases THEN la página SHALL mostrar un mensaje informativo

### Requirement 4

**User Story:** Como desarrollador, quiero que el sistema sea completamente automático, para que no tenga que hacer nada manual después del commit.

#### Acceptance Criteria

1. WHEN hago git push THEN todo el proceso SHALL ejecutarse automáticamente
2. WHEN se genera el APK THEN el versionado SHALL incrementarse automáticamente
3. WHEN se crea el release THEN la página web SHALL actualizarse sin intervención manual
4. IF hay errores THEN el sistema SHALL notificar pero no romper el flujo

### Requirement 5

**User Story:** Como usuario, quiero instrucciones claras de instalación, para que pueda instalar la app sin problemas técnicos.

#### Acceptance Criteria

1. WHEN accedo a la página THEN el sistema SHALL mostrar instrucciones paso a paso
2. WHEN mi dispositivo bloquea la instalación THEN SHALL haber guía para habilitar fuentes desconocidas
3. WHEN hay problemas THEN SHALL mostrar soluciones comunes
4. IF la descarga falla THEN SHALL ofrecer enlaces alternativos
