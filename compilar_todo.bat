@echo off
echo ========================================
echo  COMPILACION COMPLETA - TV Anto
echo  APK + WEB
echo ========================================
echo.

cd /d "%~dp0"

echo [1/6] Limpiando builds anteriores...
flutter clean

echo.
echo [2/6] Obteniendo dependencias...
flutter pub get

echo.
echo ========================================
echo  COMPILANDO APK
echo ========================================
echo [3/6] Compilando APK para Android...
flutter build apk --release

echo.
echo ========================================
echo  COMPILANDO WEB
echo ========================================
echo [4/6] Compilando version WEB...
flutter build web --release

echo.
echo [5/6] Verificando APK...
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo [OK] APK generado: build\app\outputs\flutter-apk\app-release.apk
    for %%A in ("build\app\outputs\flutter-apk\app-release.apk") do echo     Tamaño: %%~zA bytes
) else (
    echo [ERROR] No se pudo generar el APK
)

echo.
echo [6/6] Verificando WEB...
if exist "build\web\index.html" (
    echo [OK] Version WEB generada: build\web\
    echo     Archivos: index.html, flutter.js, main.dart.js, etc.
) else (
    echo [ERROR] No se pudo generar la version web
)

echo.
echo ========================================
echo  RESUMEN DE COMPILACION
echo ========================================
echo.
echo Canales deportivos actualizados:
echo   1. Disney 13
echo   2. ESPN 3 MX
echo   3. Fox Sports MX
echo   4. Fox Sports 2 MX
echo   5. Fox Sports Premium
echo   6. Fox Deportes
echo   7. ESPN MX
echo   8. Premiere 1
echo.
echo Ubicaciones:
echo   APK:  build\app\outputs\flutter-apk\app-release.apk
echo   WEB:  build\web\
echo.
echo ========================================
echo  COMPILACION COMPLETADA!
echo ========================================
echo.
pause
