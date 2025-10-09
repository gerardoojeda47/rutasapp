@echo off
echo ========================================
echo   RouWhite - Deployment Script
echo ========================================
echo.

echo [1/4] Verificando Git...
git status
if %errorlevel% neq 0 (
    echo Error: No se pudo verificar el estado de Git
    pause
    exit /b 1
)

echo.
echo [2/4] Agregando cambios...
git add .

echo.
echo [3/4] Commit de cambios...
git commit -m "Deploy: Actualización automática - %date% %time%"

echo.
echo [4/4] Subiendo a GitHub...
git push origin main

echo.
echo ========================================
echo   Deployment completado!
echo ========================================
echo.
echo Tu app estará disponible en:
echo - APK: https://gerardoojeda47.github.io/rutasapp/apk/app-release.apk
echo - Web: https://gerardoojeda47.github.io/rutasapp/
echo.
echo Los GitHub Actions generarán automáticamente la nueva APK.
echo Revisa el progreso en: https://github.com/gerardoojeda47/rutasapp/actions
echo.
pause
