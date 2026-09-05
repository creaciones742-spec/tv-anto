# 🍎 Instrucciones iOS - TV Anto

TV Anto es una app **Flutter**, así que el mismo código (`lib/main.dart`) que ya
compilaste como APK (Android) y Web funciona en iOS. Esta guía cubre cómo
generar el instalador de iPhone (`.ipa`).

---

## ✅ Ya quedó configurado para iOS

Se dejaron listos estos ajustes específicos de iOS en el proyecto:

| Ajuste | Valor configurado |
|---|---|
| **Bundle ID** | `com.tvanto.app` |
| **Nombre visible** | `TV Anto` |
| **ATS (App Transport Security)** | Permitir streams HTTP/HTTPS (evita que iOS bloquee los canales) |
| **Ícono de app** | Generado desde `assets/img/logo.jpg` |
| **Deployment target** | iOS 15.0 o superior |

> ⚠️ **Importante:** el `.ipa` **no se puede compilar en Windows**.
> Apple exige una Mac con Xcode. Tienes dos caminos (A o B).

---

## 🖥️ Opción A — Tengo una Mac con Xcode

### Requisitos
- Una Mac con macOS y [Xcode](https://apps.apple.com/us/app/xcode/id497799835) instalado.
- [Flutter](https://docs.flutter.dev/get-started/install/macos) instalado en la Mac.
- (Solo para distribuir) Una cuenta de [Apple Developer](https://developer.apple.com).

### Pasos
1. Copia la carpeta `tv_anto` completa a la Mac (puedes usar Git, AirDrop, USB o descargar el repo).
2. En la Terminal de la Mac, entra a la carpeta:
   ```bash
   cd /ruta/a/tv_anto
   ```
3. Compila:
   ```bash
   # Opción rápida (genera el .ipa firmado):
   ./build_ios.sh

   # O sin firmar, para probar en el simulador:
   ./build_ios.sh --no-codesign
   ```
4. **Firma (solo la primera vez):** abre `ios/Runner.xcworkspace` en Xcode,
   ve a *Runner → Signing & Capabilities*, activa *Automatically manage signing*
   y selecciona tu equipo (*Team*). Verifica que el Bundle Identifier sea
   `com.tvanto.app`.
5. El `.ipa` queda en `build/ios/ipa/`. Para instalarlo en tu iPhone usa
   [Apple Configurator](https://apps.apple.com/us/app/apple-configurator/id1037126344)
   (conectando el iPhone por cable), o súbelo a **TestFlight** desde Xcode.

---

## ☁️ Opción B — No tengo Mac (compilar en la nube)

Puedes compilar el `.ipa` desde esta misma PC de Windows usando un servicio en
la nube. El más sencillo para Flutter es **Codemagic** (tiene plan gratuito).

### Con Codemagic
1. Crea una cuenta gratis en [codemagic.io](https://codemagic.io) (puedes entrar con GitHub).
2. Conecta el repositorio de `tv_anto` (GitHub/GitLab/Bitbucket). Si aún no está
   en un repo, súbelo:
   ```bash
   git init
   git add .
   git commit -m "TV Anto - iOS listo"
   git remote add origin <URL-de-tu-repo>
   git push -u origin main
   ```
3. En Codemagic, crea una app apuntando al repo y elige **Flutter App**.
4. En **iOS code signing**, Codemagic puede configurar la firma automáticamente
   usando tu cuenta de Apple (App Store Connect API) o subiendo tu certificado
   y perfil de aprovisionamiento.
5. Verifica el **Bundle ID**: `com.tvanto.app`.
6. Lanza el build. Al terminar descargas el `.ipa` desde Codemagic y lo instalas
   en el iPhone (vía TestFlight o Apple Configurator).

> También sirve **GitHub Actions** con un runner `macos-latest`, pero Codemagic
> es más simple para la firma automática.

---

## 🔑 Nota sobre la cuenta de Apple

- **Para instalar en tu propio iPhone** (pruebas personales): basta una cuenta
  de Apple gratuita; el certificado dura 7 días y hay que reinstalar.
- **Para distribuir a más personas / App Store**: necesitas la membresía de
  Apple Developer (USD 99/año).

---

## 📂 Archivos iOS del proyecto

```
ios/
├── Runner/
│   ├── Info.plist          # ATS + nombre + orientación (ya configurado)
│   ├── AppDelegate.swift   # Punto de entrada iOS
│   └── Assets.xcassets/    # Íconos (generados desde logo.jpg)
└── Runner.xcodeproj/       # Bundle ID com.tvanto.app (ya configurado)
build_ios.sh                # Script de compilación para Mac
```

---

## ❓ Problemas frecuentes

### "No puedo compilar porque estoy en Windows"
Correcto: iOS solo compila en Mac o en la nube (Opción B).

### "Los canales no cargan en iPhone"
Revisa que el `Info.plist` tenga `NSAppTransportSecurity → NSAllowsArbitraryLoads = true`
(ya está configurado). Si el stream requiere cabeceras especiales, puede que el
servidor bloquee la petición (error 403); prueba con otro canal.

### "Xcode dice que falta el equipo de firma"
En Xcode: *Runner → Signing & Capabilities → Team* y elige tu cuenta de Apple.
