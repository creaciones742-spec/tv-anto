import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

/// Configuración remota de TV Anto: actualizaciones y avisos.
///
/// Se lee desde un archivo `version.json` alojado en el repositorio de GitHub
/// (servido por raw.githubusercontent.com). Si no hay conexión o el archivo no
/// existe, la app continúa funcionando con normalidad (la lectura falla en
/// silencio, devolviendo `null`).
class RemoteConfig {
  final String? androidVersion;
  final String? androidUrl;
  final bool forceUpdate;
  final String? iosVersion;
  final String? iosUrl;
  final String? messageId;
  final String? messageTitle;
  final String? messageBody;
  final String? messageUrl;

  const RemoteConfig({
    this.androidVersion,
    this.androidUrl,
    this.forceUpdate = false,
    this.iosVersion,
    this.iosUrl,
    this.messageId,
    this.messageTitle,
    this.messageBody,
    this.messageUrl,
  });

  bool get hasMessage =>
      (messageTitle?.isNotEmpty ?? false) && (messageBody?.isNotEmpty ?? false);

  factory RemoteConfig.fromJson(Map<String, dynamic> json) {
    final android = json['android'] as Map<String, dynamic>? ?? const {};
    final ios = json['ios'] as Map<String, dynamic>? ?? const {};
    final mensaje = json['mensaje'] as Map<String, dynamic>? ?? const {};

    return RemoteConfig(
      androidVersion: android['version'] as String?,
      androidUrl: android['url'] as String?,
      forceUpdate: android['forzar'] == true,
      iosVersion: ios['version'] as String?,
      iosUrl: ios['url'] as String?,
      messageId: mensaje['id'] as String?,
      messageTitle: mensaje['titulo'] as String?,
      messageBody: mensaje['cuerpo'] as String?,
      messageUrl: mensaje['url'] as String?,
    );
  }
}

class UpdateService {
  /// Cambia esta URL si mueves el archivo de control a otro lugar.
  static const String configUrl =
      'https://raw.githubusercontent.com/creaciones742-spec/tv-anto/main/version.json';

  /// Descarga y parsea la configuración remota.
  /// Devuelve `null` si falla (sin conexión, error 404, etc.).
  static Future<RemoteConfig?> fetchConfig() async {
    try {
      final response = await http
          .get(Uri.parse(configUrl))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return null;
      final decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return null;
      return RemoteConfig.fromJson(decoded);
    } catch (_) {
      return null;
    }
  }

  /// Versión instalada (ej. "1.0.0"), o `null` si no se puede leer.
  static Future<String?> currentVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (_) {
      return null;
    }
  }

  /// Compara dos versiones "x.y.z". Devuelve `true` si [remote] > [current].
  static bool isNewer(String remote, String current) {
    final a = _parse(remote);
    final b = _parse(current);
    for (var i = 0; i < 3; i++) {
      if (a[i] > b[i]) return true;
      if (a[i] < b[i]) return false;
    }
    return false;
  }

  static List<int> _parse(String version) {
    final parts = version.split('.');
    final out = <int>[0, 0, 0];
    for (var i = 0; i < parts.length && i < 3; i++) {
      out[i] = int.tryParse(parts[i]) ?? 0;
    }
    return out;
  }

  /// Versión más reciente y URL de descarga para la plataforma actual, o `null`
  /// si no aplica (p. ej. en web, que se actualiza sola al redesplegar).
  static ({String version, String url, bool force})? latestForPlatform(
      RemoteConfig config) {
    if (kIsWeb) return null;

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      if (config.iosVersion == null || config.iosUrl == null) return null;
      // iOS no permite autoactualizarse: siempre se puede posponer.
      return (
        version: config.iosVersion!,
        url: config.iosUrl!,
        force: false,
      );
    }

    // Android (APK directo) y el resto.
    if (config.androidVersion == null || config.androidUrl == null) return null;
    return (
      version: config.androidVersion!,
      url: config.androidUrl!,
      force: config.forceUpdate,
    );
  }
}
