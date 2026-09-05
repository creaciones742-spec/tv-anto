#!/usr/bin/env bash
# ============================================
#  TV Anto - Compilación iOS
#  Requiere: macOS + Xcode + Flutter instalado
#
#  Uso (desde una Mac, en la carpeta del proyecto):
#    ./build_ios.sh                 -> genera el .ipa firmado
#    ./build_ios.sh --no-codesign   -> genera el .app sin firmar
#                                      (para probar en simulador)
# ============================================
set -euo pipefail

cd "$(dirname "$0")"

echo "========================================"
echo "  TV Anto - Compilación iOS"
echo "========================================"
echo ""

echo "[1/4] Limpiando builds anteriores..."
flutter clean

echo ""
echo "[2/4] Obteniendo dependencias..."
flutter pub get

echo ""
if [[ "${1:-}" == "--no-codesign" ]]; then
  echo "[3/4] Compilando iOS (sin firmar)..."
  flutter build ios --release --no-codesign

  echo ""
  echo "========================================"
  echo "  LISTO (sin firmar)"
  echo "========================================"
  echo "  Resultado: build/ios/iphoneos/Runner.app"
  echo "  Ábrelo con Xcode (Runner.xcworkspace) para firmar y exportar el .ipa."
else
  echo "[3/4] Compilando .ipa firmado..."
  flutter build ipa --release

  echo ""
  echo "========================================"
  echo "  LISTO (.ipa firmado)"
  echo "========================================"
  echo "  Resultado: build/ios/ipa/*.ipa"
fi

echo ""
echo "[4/4] Nota sobre firma (code signing):"
echo "  Antes de firmar, abre Runner.xcworkspace en Xcode y configura"
echo "  tu equipo de Apple Developer en: Runner > Signing & Capabilities."
echo "  Bundle ID configurado: com.tvanto.app"
echo "========================================"
