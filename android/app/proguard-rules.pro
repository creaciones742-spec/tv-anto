# Reglas ProGuard/R8 para evitar crashes de ofuscación.
# WorkManager y Room (usados por OneSignal) usan reflexión; R8 los
# ofusca y rompe la creación de la base de datos -> crash al iniciar.
-keep class androidx.work.** { *; }
-keep class androidx.room.** { *; }
-dontwarn androidx.work.**
-dontwarn androidx.room.**

# OneSignal
-keep class com.onesignal.** { *; }
-dontwarn com.onesignal.**
