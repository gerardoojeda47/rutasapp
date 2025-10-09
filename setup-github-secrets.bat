@echo off
echo ========================================
echo    CONFIGURACION DE GITHUB SECRETS
echo ========================================
echo.

REM Verificar si GitHub CLI está instalado
gh --version >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ GitHub CLI no está instalado.
    echo.
    echo Para instalar GitHub CLI:
    echo 1. Ve a: https://cli.github.com/
    echo 2. Descarga e instala GitHub CLI
    echo 3. Ejecuta: gh auth login
    echo 4. Vuelve a ejecutar este script
    echo.
    pause
    exit /b 1
)

echo ✅ GitHub CLI detectado
echo.

REM Verificar autenticación
gh auth status >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo ❌ No estás autenticado en GitHub CLI
    echo Ejecuta: gh auth login
    pause
    exit /b 1
)

echo ✅ Autenticado en GitHub
echo.

REM Obtener información del repositorio
for /f "tokens=*" %%i in ('gh repo view --json nameWithOwner -q .nameWithOwner') do set REPO=%%i
echo 📁 Repositorio: %REPO%
echo.

REM Verificar si el keystore existe
if not exist "android\key.jks" (
    echo ❌ No se encontró android\key.jks
    echo Ejecuta primero: generate_keystore.bat
    pause
    exit /b 1
)

echo ✅ Keystore encontrado
echo.

REM Convertir keystore a base64
echo 🔄 Convirtiendo keystore a base64...
powershell -Command "[Convert]::ToBase64String([IO.File]::ReadAllBytes('android\key.jks'))" > keystore_base64.tmp
set /p KEYSTORE_BASE64=<keystore_base64.tmp
del keystore_base64.tmp

echo ✅ Keystore convertido
echo.

REM Configurar secrets básicos
echo 🔐 Configurando secrets básicos...
gh secret set KEYSTORE_BASE64 --body "%KEYSTORE_BASE64%" --repo %REPO%
gh secret set KEYSTORE_PASSWORD --body "rouwhite123" --repo %REPO%
gh secret set KEY_PASSWORD --body "rouwhite123" --repo %REPO%
gh secret set KEY_ALIAS --body "rouwhite" --repo %REPO%

echo ✅ Secrets básicos configurados
echo.

REM Configurar Firebase App ID (ya lo tenemos)
echo 🔥 CONFIGURACION DE FIREBASE
echo.
echo ✅ Firebase App ID detectado: 1:1077932718791:android:14df76ac74c4beaec29ca2
set FIREBASE_APP_ID=1:1077932718791:android:14df76ac74c4beaec29ca2

gh secret set FIREBASE_APP_ID --body "%FIREBASE_APP_ID%" --repo %REPO%
echo ✅ Firebase App ID configurado
echo.

REM Solicitar Service Account JSON
echo 📋 CONFIGURACION DE SERVICE ACCOUNT
echo.
echo Para obtener el Service Account JSON:
echo 1. Ve a: https://console.cloud.google.com/
echo 2. Selecciona tu proyecto Firebase
echo 3. Ve a IAM ^& Admin ^> Service Accounts
echo 4. Crea un service account con rol "Firebase App Distribution Admin"
echo 5. Descarga el archivo JSON
echo 6. Abre el archivo JSON y copia todo su contenido
echo.
echo Pega aquí el contenido completo del JSON del Service Account:
echo (Presiona Enter dos veces cuando termines)
echo.

setlocal enabledelayedexpansion
set "json_content="
:input_loop
set /p "line="
if "!line!"=="" (
    if defined json_content goto :done_input
) else (
    if defined json_content (
        set "json_content=!json_content!!line!"
    ) else (
        set "json_content=!line!"
    )
)
goto :input_loop
:done_input

if "!json_content!"=="" (
    echo ❌ Service Account JSON es requerido
    pause
    exit /b 1
)

echo !json_content! > service_account.tmp
gh secret set FIREBASE_SERVICE_ACCOUNT --body-file service_account.tmp --repo %REPO%
del service_account.tmp

echo ✅ Service Account configurado
echo.

REM Habilitar GitHub Pages
echo 📄 HABILITANDO GITHUB PAGES
echo.
echo Para habilitar GitHub Pages manualmente:
echo 1. Ve a: https://github.com/%REPO%/settings/pages
echo 2. En "Source" selecciona "GitHub Actions"
echo 3. Guarda los cambios
echo.
echo ¿Quieres que intente habilitarlo automáticamente? (y/n)
set /p ENABLE_PAGES=
if /i "%ENABLE_PAGES%"=="y" (
    gh api repos/%REPO%/pages -X POST -f source[branch]=gh-pages -f source[path]=/ >nul 2>&1
    if %ERRORLEVEL% EQU 0 (
        echo ✅ GitHub Pages habilitado
    ) else (
        echo ⚠️  No se pudo habilitar automáticamente. Hazlo manualmente.
    )
) else (
    echo ⚠️  Recuerda habilitar GitHub Pages manualmente
)

echo.
echo ========================================
echo           CONFIGURACION COMPLETA
echo ========================================
echo.
echo ✅ Todos los secrets configurados:
echo    - KEYSTORE_BASE64
echo    - KEYSTORE_PASSWORD  
echo    - KEY_PASSWORD
echo    - KEY_ALIAS
echo    - FIREBASE_APP_ID
echo    - FIREBASE_SERVICE_ACCOUNT
echo.
echo 🚀 SIGUIENTE PASO:
echo 1. Haz commit y push de estos cambios
echo 2. El workflow se ejecutará automáticamente
echo 3. Ve a: https://github.com/%REPO%/actions
echo.
echo 📱 Una vez completado, tu app estará disponible en:
echo    https://appdistribution.firebase.dev/i/%FIREBASE_APP_ID%
echo.
pause