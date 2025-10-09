# RouWhite - Rutas Popayán 🚌

App móvil para consultar rutas de buses en Popayán, Colombia.

## 📱 Descargar APK

**Descarga la última versión:** [📱 Descargar APK](https://gerardoojeda47.github.io/rutasapp/app-release.apk)

## 🌐 Versión Web

**Usar en el navegador:** [🌐 Abrir Web](https://gerardoojeda47.github.io/rutasapp/)

## ✨ Características

- 🗺️ **Mapas interactivos** con zoom de alta calidad
- 🚌 **Animaciones de buses** en tiempo real
- 📍 **Paradas y rutas** actualizadas de Popayán
- 🔍 **Búsqueda inteligente** de destinos
- ⭐ **Favoritos** y navegación personalizada
- 🔄 **Actualizaciones automáticas** via GitHub Actions

## 🚀 Deployment Automático

Esta app se despliega automáticamente usando GitHub Actions:

### Para APK:
1. Cada push a `main` genera una nueva APK
2. Se sube automáticamente a GitHub Pages
3. Disponible en: `https://gerardoojeda47.github.io/rutasapp/app-release.apk`

### Para Web:
1. Cada push a `main` construye la versión web
2. Se despliega en GitHub Pages
3. Disponible en: `https://gerardoojeda47.github.io/rutasapp/`

## 🛠️ Desarrollo

### Requisitos
- Flutter SDK 3.5.0+
- Dart 3.5.0+
- Android SDK

### Instalación
```bash
git clone https://github.com/gerardoojeda47/rutasapp.git
cd rutasapp
flutter pub get
flutter run
```

### Estructura del Proyecto
```
lib/
├── core/           # Servicios y utilidades
├── data/           # Modelos y repositorios
├── domain/         # Entidades y casos de uso
├── view/           # Pantallas y widgets
└── main.dart       # Punto de entrada
```

## 📊 Tecnologías

- **Flutter** - Framework de desarrollo
- **Firebase** - Backend y autenticación
- **Flutter Map** - Mapas interactivos
- **GitHub Actions** - CI/CD automático
- **GitHub Pages** - Hosting gratuito

## 🔧 Configuración de Mapas

Para zoom de alta calidad, configura las API keys en `lib/view/paradas_pagina.dart`:

```dart
// Mapbox (recomendado)
static const String _mapboxKey = 'TU_TOKEN_MAPBOX';

// MapTiler (alternativa)
static const String _mapTilerKey = 'TU_KEY_MAPTILER';
```

### Obtener API Keys:
- **Mapbox**: https://account.mapbox.com/access-tokens/ (50k requests/mes gratis)
- **MapTiler**: https://cloud.maptiler.com/account/keys/ (100k tiles/mes gratis)

## 📱 Instalación de APK

1. Descarga el APK desde el enlace arriba
2. En Android, ve a Configuración > Seguridad > Fuentes desconocidas
3. Permite instalación de apps de fuentes desconocidas
4. Instala el APK descargado

## 🔄 Actualizaciones

- **Automáticas**: Cada cambio en el código genera una nueva APK
- **Manual**: Descarga desde el enlace de arriba
- **Web**: Se actualiza automáticamente en GitHub Pages

## 📞 Soporte

Si encuentras algún problema:
1. Abre un [Issue](https://github.com/gerardoojeda47/rutasapp/issues)
2. Incluye detalles del error y dispositivo
3. Adjunta capturas de pantalla si es necesario

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver `LICENSE` para más detalles.

---

**Desarrollado con ❤️ para Popayán, Colombia**