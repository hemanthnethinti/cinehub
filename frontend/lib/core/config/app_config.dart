import 'package:flutter/foundation.dart';
import 'dev_overrides.dart';
import 'environment.dart';

/// Application-wide configuration resolved at runtime.
///
/// Priority order for baseUrl in development:
///   1. `assets/dev_config.json` → `api_base_url`  (runtime, gitignored)
///   2. `--dart-define=API_BASE_URL=...`            (compile-time override)
///   3. Hardcoded per-environment defaults
///
/// To create your local override (no rebuild needed):
///   1. Copy `assets/dev_config.json.example` → `assets/dev_config.json`
///   2. Set `"api_base_url"` to your machine's LAN IP.
///   3. Hot-restart the app.
abstract final class AppConfig {
  static const String _env =
      String.fromEnvironment('ENV', defaultValue: 'development');

  /// Compile-time override via `--dart-define=API_BASE_URL=http://...`
  static const String _dartDefineUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  static Environment get environment => switch (_env) {
        'production' => Environment.production,
        'staging' => Environment.staging,
        _ => Environment.development,
      };

  static bool get isDev => environment == Environment.development;
  static bool get isProd => environment == Environment.production;

  static String get baseUrl {
    // 1. Runtime JSON override (dev_config.json) — highest priority in debug
    if (kDebugMode && DevOverrides.apiBaseUrl != null) {
      return DevOverrides.apiBaseUrl!;
    }

    // 2. Compile-time dart-define override
    if (_dartDefineUrl.isNotEmpty) {
      return _dartDefineUrl.replaceFirst(RegExp(r'/$'), '');
    }

    // 3. Hardcoded defaults
    return switch (environment) {
      Environment.production => 'https://api.cinehub.app',
      Environment.staging => 'https://api-staging.cinehub.app',
      Environment.development => 'http://10.70.14.31:5000',
    };
  }

  static String get socketUrl => baseUrl;
  static String get apiVersion => 'v1';
  static String get apiBase => '$baseUrl/api/$apiVersion/';
}
