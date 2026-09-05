# 🔔 Notificaciones Push con OneSignal - TV ANTO

> ✅ **El SDK ya está integrado en la app** (wrapper, App ID, diálogo de
> verificación). Solo falta configurar el **panel de OneSignal** y probar.
> No hace falta `google-services.json` en la app.

---

## Paso 1 — Crear proyecto Firebase y clave de cuenta de servicio

1. Entra a https://console.firebase.google.com (con tu cuenta de Google).
2. **Crear proyecto** → nombre `TV ANTO` → **Continuar** → **Crear**.
3. Cuando cargue, abre **⚙️ Configuración del proyecto** (engranaje).
4. Ve a la pestaña **Cuentas de servicio**.
5. Pulsa **"Generar nueva clave privada"** → se descarga un archivo **`.json`**.
   - Guárdalo; es lo que subirás a OneSignal.
   - Si no ves el botón, primero activa **"Firebase Cloud Messaging API"** en
     *Cloud Messaging* y vuelve a intentar.

> 📌 Este `.json` (cuenta de servicio) es DISTINTO a `google-services.json`.
> Este va al panel de OneSignal, no a la app.

---

## Paso 2 — Subir la clave a OneSignal

1. Entra a https://dashboard.onesignal.com → tu app **TV ANTO**.
2. **Settings → Platforms → Android**.
3. En **Google Android FCM** sube el archivo `.json` del paso 1.
4. **Guardar**.

---

## Paso 3 — Instalar la app en tu Android

1. Descarga el APK (en tu teléfono o PC y lo pasas por cable):
   https://github.com/creaciones742-spec/tv-anto/releases/latest/download/app-release.apk
2. Al abrir el APK, Android te pedirá **permitir instalar apps desconocidas** → actívalo.
3. **Instalar** → **Abrir**.
4. Toca **"Got it"** en el diálogo para aceptar notificaciones.

---

## Paso 4 — Enviar tu primer push

1. OneSignal → **Messages → New Push**.
2. Escribe **título** y **mensaje**.
3. **Audience:** elige "Subscribed Users".
4. **Send**.

Si todo está bien, el mensaje llega a tu dispositivo, incluso con la app cerrada.

---

## 🛟 Si no llega el push

- Asegúrate de haber tocado **"Got it"** y aceptado el permiso del sistema.
- Verifica que en OneSignal → **Audience → Subscriptions** aparezca tu dispositivo
  (el id no debe empezar con `local-`).
- No borres los datos ni reinstales a cada prueba (crea suscripciones duplicadas).
