# 📺 TV Anto

Aplicación de streaming de canales deportivos en vivo, construida con **Flutter**.

El mismo código genera las tres versiones con información idéntica:

| Plataforma | Estado | Cómo compilar |
|---|---|---|
| 📱 Android (APK) | ✅ Lista | `build_apk.bat` |
| 🌐 Web | ✅ Lista | `build_web.bat` |
| 🍎 iOS (IPA) | ✅ Configurada | Ver `INSTRUCCIONES_IOS.md` (requiere Mac o nube) |

## 🎯 Características
- Reproductor de video en vivo (HLS/m3u8) con Chewie + video_player.
- 11 canales deportivos (ESPN, Fox Sports, Disney, Premiere, DSports, etc.).
- Modo **Móvil** y modo **TV Box**.
- Zoom de video, marco de TV, mantener pantalla encendida.
- Diseño oscuro moderno (rosa/ámbar).
- En Web usa un proxy en `api/proxy.js` para evitar CORS.
- 🔄 **Actualizaciones OTA** y **avisos a usuarios** vía `version.json` (sin Play Store).

## 🚀 Compilación rápida
```bash
# Android
build_apk.bat

# Web
build_web.bat

# iOS (desde una Mac)
./build_ios.sh
```

## 📚 Documentación
- `COMPILAR_INSTRUCCIONES.md` — Android + Web.
- `INSTRUCCIONES_IOS.md` — iOS (Mac con Xcode o compilación en la nube).
- `DEPLOYMENT.md` — despliegue de la versión Web en Vercel.
- `ACTUALIZACIONES_AVISOS.md` — cómo publicar actualizaciones y enviar mensajes a los usuarios.

## ⚙️ Configuración clave
- **Bundle ID iOS:** `com.tvanto.app`
- **Versión:** `1.0.0+1` (definida en `pubspec.yaml`)
- **Canales:** lista en `lib/main.dart` (clase `_MainScreenState.channels`)

## 📝 Nota
El `.ipa` de iOS no puede compilarse en Windows; Apple requiere macOS + Xcode.
Usa una Mac o un servicio en la nube (Codemagic) — ver `INSTRUCCIONES_IOS.md`.
