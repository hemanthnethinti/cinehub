import 'environment.dart';

/// Application-wide configuration resolved from the compile-time environment.
///
/// To switch environment, pass `--dart-define=ENV=production` to `flutter run`.
/// Default is [Environment.development].
abstract final class AppConfig {
  static const String _env =
      String.fromEnvironment('ENV', defaultValue: 'development');

  /// Optional API origin override.
  ///
  /// This keeps local development independent of a developer's LAN address:
  /// `flutter run --dart-define=API_BASE_URL=http://192.168.1.20:5000`.
  /// Android emulators can use the default `10.0.2.2` host alias.
  static const String _baseUrlOverride =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');

  static Environment get environment => switch (_env) {
        'production' => Environment.production,
        'staging' => Environment.staging,
        _ => Environment.development,
      };

  static bool get isDev => environment == Environment.development;
  static bool get isProd => environment == Environment.production;

  static String get baseUrl {
    if (_baseUrlOverride.isNotEmpty) {
      return _baseUrlOverride.replaceFirst(RegExp(r'/$'), '');
    }

    return switch (environment) {
      Environment.production => 'https://api.cinehub.app',
      Environment.staging => 'https://api-staging.cinehub.app',
      Environment.development => 'http://10.0.2.2:5000',
    };
  }

  static String get socketUrl => baseUrl;

  static String get apiVersion => 'v1';

  static String get apiBase => '$baseUrl/api/$apiVersion/';
}
