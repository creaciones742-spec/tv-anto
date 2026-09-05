@echo off
echo ========================================
echo  Compilando APK de TV Anto
echo ========================================
echo.

cd /d "%~dp0"

echo [1/4] Limpiando build anterior...
flutter clean

echo.
echo [2/4] Obteniendo dependencias...
flutter pub get

echo.
echo [3/4] Compilando APK (esto puede tomar varios minutos)...
flutter build apk --release

echo.
echo [4/4] Verificando APK generado...
if exist "build\app\outputs\flutter-apk\app-release.apk" (
    echo.
    echo ========================================
    echo  APK COMPILADO EXITOSAMENTE!
    echo ========================================
    echo.
    echo Ubicacion: build\app\outputs\flutter-apk\app-release.apk
    echo.
    dir "build\app\outputs\flutter-apk\app-release.apk"
    echo.
    echo Puedes instalar este APK en tu dispositivo Android
) else (
    echo.
    echo ========================================
    echo  ERROR: No se pudo generar el APK
    echo ========================================
)

echo.
pause
