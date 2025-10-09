# Configuración de Firebase para GitHub Actions

## 1. Crear Service Account

1. Ve a [Google Cloud Console](https://console.cloud.google.com/)
2. Selecciona tu proyecto Firebase
3. Ve a "IAM & Admin" > "Service Accounts"
4. Haz clic en "Create Service Account"
5. Nombre: `github-actions-rouwhite`
6. Descripción: `Service account for GitHub Actions CI/CD`
7. Haz clic en "Create and Continue"

## 2. Asignar Roles

Asigna estos roles al service account:

- `Firebase App Distribution Admin`
- `Firebase Admin SDK Administrator Service Agent`

## 3. Crear Key

1. Haz clic en el service account creado
2. Ve a la pestaña "Keys"
3. Haz clic en "Add Key" > "Create new key"
4. Selecciona "JSON"
5. Descarga el archivo JSON

## 4. Obtener Firebase App ID

1. Ve a [Firebase Console](https://console.firebase.google.com/)
2. Selecciona tu proyecto
3. Ve a "Project Settings" (ícono de engranaje)
4. En la pestaña "General", busca tu app Android
5. Copia el "App ID" (formato: 1:123456789:android:abc123...)

## 5. Configurar GitHub Secrets

Ve a tu repositorio en GitHub > Settings > Secrets and variables > Actions

Agrega estos secrets:

### FIREBASE_SERVICE_ACCOUNT

Pega todo el contenido del archivo JSON descargado

### FIREBASE_APP_ID

Pega el App ID copiado de Firebase Console

### KEYSTORE_BASE64

Convierte tu keystore a base64:

```bash
# En Windows (PowerShell)
[Convert]::ToBase64String([IO.File]::ReadAllBytes("android\key.jks"))

# En Linux/Mac
base64 -i android/key.jks
```

### KEYSTORE_PASSWORD

`rouwhite123`

### KEY_PASSWORD

`rouwhite123`

### KEY_ALIAS

`rouwhite`

## 6. Habilitar GitHub Pages

1. Ve a tu repositorio > Settings > Pages
2. Source: "GitHub Actions"
3. Guarda los cambios

## 7. Crear grupo de testers en Firebase

1. Ve a Firebase Console > App Distribution
2. Haz clic en "Testers & Groups"
3. Crea un grupo llamado "testers"
4. Agrega emails de las personas que quieres que reciban la app

¡Listo! Ahora cada commit activará el build automático.
