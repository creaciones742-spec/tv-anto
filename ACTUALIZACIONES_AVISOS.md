# 🔄 Actualizaciones OTA y Avisos a Usuarios - TV Anto

TV Anto revisa un archivo de control llamado `version.json` que está en este
repositorio de GitHub. Con ese único archivo puedes:

1. **Avisar de una nueva actualización** (Android descarga el APK; iOS abre el enlace).
2. **Enviar un mensaje/aviso** a todos los usuarios:
   - **Al abrir la app**: aparece como ventana (una vez por `id`).
   - **En vivo (mientras ven un programa)**: la app revisa cada ~45 segundos y
     muestra el mensaje como banner, sin interrumpir la reproducción.

Todo sin Play Store ni App Store. El archivo se sirve gratis desde:

```
https://raw.githubusercontent.com/creaciones742-spec/tv-anto/main/version.json
```

---

## 📁 Estructura de `version.json`

```json
{
  "mensaje": {
    "id": "bienvenida-1",
    "titulo": "🎉 ¡Bienvenido a TV Anto!",
    "cuerpo": "Gracias por usar la app. Aquí verás avisos y novedades.",
    "url": ""
  },
  "android": {
    "version": "1.0.0",
    "url": "https://github.com/creaciones742-spec/tv-anto/releases/latest/download/app-release.apk",
    "forzar": false
  },
  "ios": {
    "version": "1.0.0",
    "url": "https://github.com/creaciones742-spec/tv-anto/releases/latest"
  }
}
```

| Campo | Qué hace |
|---|---|
| `mensaje.id` | Identificador del mensaje. La app lo muestra **una sola vez** por id. Cambia el id para mostrar un aviso nuevo. |
| `mensaje.titulo` / `cuerpo` | Título y texto del aviso. |
| `mensaje.url` | (Opcional) enlace que abre el botón "Ver". Déjalo `""` si no quieres botón. |
| `android.version` | Última versión para Android. Si es mayor que la instalada, aparece el aviso de actualización. |
| `android.url` | Enlace de descarga del APK. |
| `android.forzar` | `true` = obliga a actualizar (no se puede posponer). `false` = permite "Ahora no". |
| `ios.version` / `ios.url` | Igual pero para iPhone (enlace a TestFlight o instrucciones). |

> 💡 La versión instalada se compara con la de `pubspec.yaml` (hoy es `1.0.0`).

---

## 📦 Cómo publicar una ACTUALIZACIÓN (Android)

1. Sube la versión en `pubspec.yaml`. Ej.: de `1.0.0+1` a `1.0.1+2`.
2. Compila el APK:
   ```bash
   build_apk.bat
   ```
   El APK queda en `build\app\outputs\flutter-apk\app-release.apk`.
3. Súbelo a GitHub:
   - Ve a tu repo → **Releases** → **Draft a new release**.
   - Pon un tag, ej. `v1.0.1`.
   - Adjunta el archivo `app-release.apk` (nómbralo exactamente **`app-release.apk`**).
   - Publica el release.
4. Edita `version.json` (desde GitHub, botón ✏️):
   - `android.version` → `"1.0.1"`.
   - Guarda (Commit changes).

   Desde ese momento, al abrir la app, los usuarios verán **"🔄 Actualización disponible"**
   con el botón **"Actualizar aquí"**, que abre el APK en el navegador para instalarlo.

> El enlace `.../releases/latest/download/app-release.apk` siempre apunta al APK del
> release más reciente, así que solo tienes que subir el APK y cambiar la versión.

---

## 💬 Cómo enviar un MENSAJE/AVISO

1. Edita `version.json` en GitHub.
2. Cambia el bloque `mensaje`:
   ```json
   "mensaje": {
     "id": "novedad-canales-2",
     "titulo": "⚽ ¡Nuevos canales!",
     "cuerpo": "Agregamos más canales deportivos. Ábrelos desde la lista.",
     "url": ""
   }
   ```
3. Guarda. La próxima vez que cada usuario abra la app, verá el mensaje.
   - **Importante:** cambia el `id` (ej. `novedad-canales-2`, `3`, ...) para que
     el mensaje se muestre otra vez. Si el id no cambia, quien ya lo vio no lo verá de nuevo.

---

## 🍎 Sobre iOS

Apple no permite que una app se autoactualice como el APK. En iPhone, el aviso
muestra "hay nueva versión" y abre el enlace `ios.url` (por ejemplo, la página de
TestFlight). Para actualizar una app iOS hay que recompilar y redistribuir
(vía TestFlight o Apple Configurator) — ver `INSTRUCCIONES_IOS.md`.

---

## ❓ Preguntas frecuentes

**¿Y si el usuario no tiene internet?**
La app arranca normal; la revisión falla en silencio y no muestra nada.

**¿El mensaje aparece en la web también?**
Sí, el mensaje se muestra en Android, iOS y Web. El aviso de actualización no
aparece en web (la web se actualiza sola al redesplegar en Vercel).

**¿Puedo poner el APK en otro lado (Drive, etc.)?**
Sí, solo cambia `android.url` por el enlace directo de descarga. GitHub Releases
es lo más confiable para APK.
