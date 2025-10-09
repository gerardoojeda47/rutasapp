# Configuración de Distribución Automática

Este documento explica cómo configurar la distribución automática de la aplicación RouWhite mediante GitHub Actions y GitHub Pages.

## 🚀 Características

- ✅ Compilación automática del APK con cada commit
- ✅ Creación automática de releases en GitHub
- ✅ Página web con código QR para descarga fácil
- ✅ Distribución opcional via Firebase App Distribution
- ✅ Verificación automática de actualizaciones en la app

## 📋 Configuración Inicial

### 1. Configurar GitHub Secrets

Ve a tu repositorio en GitHub → Settings → Secrets and variables → Actions y agrega los siguientes secrets:

#### Secrets Requeridos para APK Signing:

```
KEYSTORE_BASE64: [Tu keystore convertido a base64]
KEYSTORE_PASSWORD: rouwhite123
KEY_PASSWORD: rouwhite123
KEY_ALIAS: rouwhite
```

#### Secrets Opcionales para Firebase:

```
FIREBASE_TOKEN: [Token de Firebase CLI]
FIREBASE_APP_ID: [ID de tu app en Firebase]
```

### 2. Generar Keystore Base64

Si necesitas generar el keystore en base64:

```bash
# Convertir keystore existente a base64
base64 -i android/key.jks -o keystore.base64

# En Windows (PowerShell)
[Convert]::ToBase64String([IO.File]::ReadAllBytes("android\key.jks")) > keystore.base64
```

### 3. Habilitar GitHub Pages

1. Ve a tu repositorio → Settings → Pages
2. En "Source" selecciona "GitHub Actions"
3. La página estará disponible en: `https://[tu-usuario].github.io/[nombre-repo]/`

### 4. Configurar Firebase App Distribution (Opcional)

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Crea un proyecto o usa uno existente
3. Habilita App Distribution
4. Instala Firebase CLI: `npm install -g firebase-tools`
5. Genera token: `firebase login:ci`
6. Agrega el token como secret `FIREBASE_TOKEN`

## 🔄 Flujo de Trabajo

### Automático (Recomendado)

1. **Commit a main** → Trigger automático
2. **GitHub Actions** compila el APK
3. **Release automático** con APK adjunto
4. **GitHub Pages** actualiza la página con nuevo QR
5. **Firebase** (opcional) distribuye a testers

### Manual

1. Ve a Actions → "Build and Release APK"
2. Haz clic en "Run workflow"
3. Selecciona la rama y ejecuta

## 📱 Uso de la Página de Distribución

### Para Usuarios Finales:

1. Visita: `https://[tu-usuario].github.io/rouwhite/`
2. Escanea el código QR con tu móvil
3. Descarga e instala el APK
4. Habilita "Fuentes desconocidas" si es necesario

### Para Desarrolladores:

- La página se actualiza automáticamente con cada release
- Muestra la versión actual y fecha de actualización
- Incluye instrucciones de instalación
- Funciona en dispositivos móviles y desktop

## 🔧 Personalización

### Actualizar Información de la App

Edita `docs/index.html` para cambiar:

- Nombre de la aplicación
- Descripción
- Colores y estilos
- Instrucciones de instalación

### Modificar Workflow

Edita `.github/workflows/build-and-release.yml` para:

- Cambiar triggers (ramas, tags)
- Agregar pasos adicionales
- Modificar configuración de build
- Personalizar release notes

### Configurar Ambientes

Para múltiples ambientes (dev/staging/prod):

1. Crea ramas específicas (`develop`, `staging`)
2. Duplica el workflow con diferentes triggers
3. Usa diferentes proyectos Firebase por ambiente
4. Configura URLs diferentes para cada ambiente

## 🧪 Testing

### Probar Localmente

```bash
# Compilar APK de release
flutter build apk --release

# Verificar que el APK funciona
adb install build/app/outputs/flutter-apk/app-release.apk
```

### Probar Página Web

```bash
# Servir localmente
cd docs
python -m http.server 8000
# Visita: http://localhost:8000
```

## 🐛 Troubleshooting

### Error: "Keystore not found"

- Verifica que `KEYSTORE_BASE64` esté configurado correctamente
- Asegúrate de que el keystore sea válido

### Error: "Firebase token invalid"

- Regenera el token: `firebase login:ci`
- Actualiza el secret `FIREBASE_TOKEN`

### Error: "GitHub Pages not updating"

- Verifica que GitHub Pages esté habilitado
- Revisa los logs del workflow "Deploy to GitHub Pages"

### APK no se instala

- Verifica que "Fuentes desconocidas" esté habilitado
- Comprueba que el APK esté firmado correctamente

## 📚 Recursos Adicionales

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)
- [Firebase App Distribution](https://firebase.google.com/docs/app-distribution)
- [Flutter Build and Release](https://docs.flutter.dev/deployment/android)

## 🆘 Soporte

Si tienes problemas con la configuración:

1. Revisa los logs de GitHub Actions
2. Verifica que todos los secrets estén configurados
3. Comprueba que el keystore sea válido
4. Asegúrate de que GitHub Pages esté habilitado

---

**¡Tu aplicación RouWhite ahora se distribuye automáticamente! 🎉**
