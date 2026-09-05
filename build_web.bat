@echo off
echo ========================================
echo  Compilando VERSION WEB de TV Anto
echo ========================================
echo.

cd /d "%~dp0"

echo [1/4] Limpiando build anterior...
flutter clean

echo.
echo [2/4] Obteniendo dependencias...
flutter pub get

echo.
echo [3/4] Compilando para WEB...
flutter build web --release

echo.
echo [4/4] Verificando build web...
if exist "build\web\index.html" (
    echo.
    echo ========================================
    echo  VERSION WEB COMPILADA EXITOSAMENTE!
    echo ========================================
    echo.
    echo Ubicacion: build\web\
    echo.
    echo Archivos generados:
    dir "build\web" /B
    echo.
    echo Lista para subir a Vercel o cualquier hosting
) else (
    echo.
    echo ========================================
    echo  ERROR: No se pudo generar la version web
    echo ========================================
)

echo.
pause
