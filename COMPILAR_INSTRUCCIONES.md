# 📱 Instrucciones de Compilación - TV Anto

## ✅ Canales Actualizados

Se han actualizado 8 canales deportivos en el código:

1. ⭐ Disney 13 - `https://la18hd.su/vivo/canal.php?stream=disney13`
2. ⭐ ESPN 3 MX - `https://la18hd.su/vivo/canal.php?stream=espn3mx`
3. ⭐ Fox Sports MX - `https://la18hd.su/vivo/canal.php?stream=foxsportsmx`
4. ⭐ Fox Sports 2 MX - `https://la18hd.su/vivo/canal.php?stream=foxsports2mx`
5. ⭐ Fox Sports Premium - `https://la18hd.su/vivo/canal.php?stream=foxsportspremium`
6. ⭐ Fox Deportes - `https://la18hd.su/vivo/canal.php?stream=foxdeportes`
7. ⭐ ESPN MX - `https://la18hd.su/vivo/canal.php?stream=espnmx`
8. ⭐ Premiere 1 - `https://streamtp-golden1.click/global2.php?stream=premiere1`

---

## 🚀 Opción 1: Compilar Todo (APK + WEB)

Ejecuta este comando en tu terminal Windows o haz doble clic en el archivo:

```bash
compilar_todo.bat
```

Este script hará:
- ✓ Limpiar builds anteriores
- ✓ Obtener dependencias
- ✓ Compilar APK para Android
- ✓ Compilar versión WEB
- ✓ Verificar que todo se generó correctamente

---

## 📱 Opción 2: Compilar Solo APK

Si solo necesitas el APK para Android:

```bash
build_apk.bat
```

El APK se generará en:
```
build\app\outputs\flutter-apk\app-release.apk
```

---

## 🌐 Opción 3: Compilar Solo WEB

Si solo necesitas la versión web:

```bash
build_web.bat
```

Los archivos web se generarán en:
```
build\web\
```

---

## 📂 Ubicación de los Archivos Generados

### APK Android
```
C:\Users\wsssi\Documents\tv_anto\build\app\outputs\flutter-apk\app-release.apk
```

### Versión WEB
```
C:\Users\wsssi\Documents\tv_anto\build\web\
```

---

## 📋 Requisitos Previos

Asegúrate de tener instalado:
- ✓ Flutter SDK
- ✓ Android SDK (para compilar APK)
- ✓ Conexión a internet (para descargar dependencias)

---

## 🔧 Solución de Problemas

### Error: "flutter no reconocido como comando"
Asegúrate de que Flutter esté en tu PATH. Ejecuta:
```bash
flutter doctor
```

### Error en la compilación
1. Limpia el proyecto manualmente:
   ```bash
   flutter clean
   ```
2. Vuelve a intentar la compilación

### APK muy grande
El APK en modo release debería pesar entre 40-60 MB. Si es más grande, revisa las dependencias.

---

## 📤 Desplegar Versión WEB

Después de compilar la versión web, puedes subirla a Vercel:

```bash
cd C:\Users\wsssi\Documents\tv_anto
git add .
git commit -m "Actualizar canales deportivos"
git push
```

Vercel detectará automáticamente los cambios y desplegará la nueva versión.

---

## ✨ Cambios Realizados en el Código

### Archivo modificado: `lib\main.dart`

Se reemplazó la lista de canales completa (líneas 63-82) con los 8 nuevos canales deportivos proporcionados.

Todos los canales están en el grupo "DEPORTES" para mejor organización.

---

## 🎯 Próximos Pasos

1. Ejecuta `compilar_todo.bat`
2. Espera a que termine la compilación (puede tomar 5-10 minutos)
3. Instala el APK en tu dispositivo Android
4. Opcionalmente, despliega la versión web a Vercel

---

**¡Listo! Los canales están actualizados y listos para compilar. 🎉**
