import 'environment.dart';

/// Application-wide configuration resolved from the compile-time environment.
///
/// To switch environment, pass `--dart-define=ENV=production` to `flutter run`.
/// Default is [Environment.development].
abstract final class AppConfig {
  static const String _env = String.fromEnvironment('ENV', defaultValue: 'development');

  static Environment get environment => switch (_env) {
        'production' => Environment.production,
        'staging'    => Environment.staging,
        _            => Environment.development,
      };

  static bool get isDev  => environment == Environment.development;
  static bool get isProd => environment == Environment.production;

  static String get baseUrl => switch (environment) {
        Environment.production  => 'https://api.cinehub.app',
        Environment.staging     => 'https://api-staging.cinehub.app',
        Environment.development => 'http://10.0.2.2:4000', // Android emulator → localhost
      };

  static String get socketUrl => baseUrl;

  static String get apiVersion => 'v1';

  static String get apiBase => '$baseUrl/api/$apiVersion';
}
