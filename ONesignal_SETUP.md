# 🔔 Notificaciones Push con OneSignal - TV ANTO

Notificaciones push reales (llegan aunque la app esté cerrada) con **OneSignal**
(gratis).

> ✅ **El SDK ya está integrado en la app** con tu App ID. No hace falta crear
> proyecto de Firebase ni descargar `google-services.json` — el SDK de OneSignal
> registra FCM automáticamente.

---

## ✅ Lo que ya quedó hecho en el código

- Dependencia `onesignal_flutter` (versión estable **5.5.2**).
- Wrapper central `lib/onesignal_service.dart` (todas las llamadas pasan por aquí).
- Inicialización en `main()` con el App ID `0d6bfe44-46d5-4498-8953-b1bfe508cb47`.
- Diálogo de verificación: al registrarse el dispositivo, la app muestra
  "Your OneSignal SDK integration is complete!" y pide permiso al tocar "Got it".
- Permiso `POST_NOTIFICATIONS` en el AndroidManifest.

> 💡 El texto del diálogo de verificación está en inglés (es el estándar de
> OneSignal). Puedes cambiarlo a español cuando quieras.

---

## 🧭 Lo único que te falta (panel de OneSignal)

1. Entra a https://dashboard.onesignal.com con tu cuenta.
2. Abre tu app **TV ANTO** → **Settings → Platforms → Android**.
3. Sigue lo que te pida el panel. Si pide credenciales de FCM/Firebase, el propio
   panel te guía (algunos flujos usan el remitente por defecto de OneSignal;
   otros piden una clave). Guarda los cambios.

---

## 🧪 Enviar tu primer push de prueba

1. Instala la app en tu Android (la versión `v1.0.3`).
2. Ábrela y toca **"Got it"** en el diálogo para aceptar notificaciones.
3. En el panel de OneSignal → **Messages → New Push**.
4. Escribe título y mensaje → **Audience:** "Subscribed Users" → **Send**.
5. El mensaje llega a tu dispositivo, incluso con la app cerrada.

> ⚠️ Para probar, **no borres los datos ni reinstales** la app a cada intento
> (eso crea suscripciones duplicadas en OneSignal). Con reinstalar encima
> (actualizar) es suficiente.

---

## 🍎 Nota sobre iOS

El push en iPhone requiere Mac + cuenta de Apple Developer (APNs). Lo dejamos
fuera por ahora (Android ya funciona completo). El código de OneSignal es el
mismo para ambas plataformas.
