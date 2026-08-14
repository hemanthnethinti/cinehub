import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';

/// Reads `assets/dev_config.json` at runtime (debug only).
///
/// This allows changing the backend URL without rebuilding the app.
/// The file is gitignored — each developer maintains their own copy.
///
/// Example `assets/dev_config.json`:
/// ```json
/// { "api_base_url": "http://10.70.14.31:5000" }
/// ```
abstract final class DevOverrides {
  static String? _apiBaseUrl;
  static bool _loaded = false;

  /// Call once in `main()` before runApp. No-op in release mode.
  static Future<void> load() async {
    if (!kDebugMode) return;
    if (_loaded) return;
    try {
      final raw = await rootBundle.loadString('assets/dev_config.json');
      final map = json.decode(raw) as Map<String, dynamic>;
      _apiBaseUrl = (map['api_base_url'] as String?)?.replaceFirst(RegExp(r'/$'), '');
    } catch (_) {
      // File missing or malformed — fall back to AppConfig defaults.
    }
    _loaded = true;
  }

  /// Returns the overridden API base URL, or null if not set.
  static String? get apiBaseUrl => _apiBaseUrl;
}
