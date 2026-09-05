import 'package:onesignal_flutter/onesignal_flutter.dart';

/// Envoltura (wrapper) central de OneSignal.
///
/// Toda interacción con el SDK de OneSignal pasa por esta clase, para aislar
/// las llamadas directas y facilitar pruebas y futuras actualizaciones.
class OneSignalService {
  OneSignalService._();

  static final OneSignalService instance = OneSignalService._();

  bool _initialized = false;

  /// Inicializa el SDK. Se llama una sola vez, antes de `runApp()`.
  Future<void> initialize(String appId) async {
    if (_initialized || appId.isEmpty) return;
    // Log level verbose solo para depuración; bajar a debug/info en producción.
    OneSignal.Debug.setLogLevel(OSLogLevel.verbose);
    await OneSignal.initialize(appId);
    _initialized = true;
  }

  /// Solicita permiso de notificaciones. Solo se llama desde el diálogo
  /// de verificación ("Got it").
  Future<bool> requestPermission() {
    return OneSignal.Notifications.requestPermission(true);
  }

  /// Id de suscripción actual (puede ser `null` o el placeholder `local-`).
  String? get subscriptionId => OneSignal.User.pushSubscription.id;

  /// True si el id es real (asignado por el servidor), no el placeholder `local-`.
  bool isRegistered(String? id) =>
      id != null && id.isNotEmpty && !id.startsWith('local-');

  /// Registra un observador de cambios de suscripción. Recibe el id actual
  /// en cada cambio.
  void addSubscriptionObserver(void Function(String? id) onChanged) {
    OneSignal.User.pushSubscription.addObserver((state) {
      onChanged(state.current.id);
    });
  }

  void login(String externalId) => OneSignal.login(externalId);

  void logout() => OneSignal.logout();

  Future<void> setEmail(String email) => OneSignal.User.addEmail(email);

  Future<void> setSmsNumber(String number) => OneSignal.User.addSms(number);

  Future<void> setTag(String key, dynamic value) =>
      OneSignal.User.addTagWithKey(key, value);

  void setLogLevel(OSLogLevel level) => OneSignal.Debug.setLogLevel(level);
}
