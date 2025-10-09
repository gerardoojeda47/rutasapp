@echo off
echo Generando keystore para Rouwhite...

REM Buscar Java en ubicaciones comunes
set JAVA_PATH=""
if exist "C:\Program Files\Java\jdk*\bin\keytool.exe" (
    for /d %%i in ("C:\Program Files\Java\jdk*") do set JAVA_PATH="%%i\bin\keytool.exe"
)
if exist "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" (
    set JAVA_PATH="C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe"
)
if exist "%JAVA_HOME%\bin\keytool.exe" (
    set JAVA_PATH="%JAVA_HOME%\bin\keytool.exe"
)

if %JAVA_PATH%=="" (
    echo Error: No se encontró keytool. Asegúrate de tener Java o Android Studio instalado.
    echo Alternativamente, puedes usar Android Studio para generar el keystore:
    echo 1. Abre Android Studio
    echo 2. Ve a Build ^> Generate Signed Bundle / APK
    echo 3. Selecciona APK
    echo 4. Crea un nuevo keystore con estos datos:
    echo    - Keystore path: %cd%\android\key.jks
    echo    - Password: rouwhite123
    echo    - Key alias: rouwhite
    echo    - Key password: rouwhite123
    pause
    exit /b 1
)

echo Usando Java en: %JAVA_PATH%
%JAVA_PATH% -genkey -v -keystore android\key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias rouwhite -storepass rouwhite123 -keypass rouwhite123 -dname "CN=Rouwhite, OU=Development, O=Rouwhite, L=Popayan, S=Cauca, C=CO"

if %ERRORLEVEL% EQU 0 (
    echo ✓ Keystore generado exitosamente en android\key.jks
) else (
    echo ✗ Error generando keystore
)

pause