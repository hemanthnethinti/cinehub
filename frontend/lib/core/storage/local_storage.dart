import 'package:shared_preferences/shared_preferences.dart';

/// Non-sensitive local storage backed by SharedPreferences.
///
/// Only non-sensitive UI preferences are stored here.
/// Never store tokens here — use [SecureStorage] instead.
class LocalStorage {
  LocalStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _kThemeMode = 'theme_mode';
  static const _kLanguage  = 'language';
  static const _kOnboarded = 'onboarded';

  // ── Theme ─────────────────────────────────────────────────────

  Future<void> saveThemeMode(String mode) =>
      _prefs.setString(_kThemeMode, mode);

  String getThemeMode() => _prefs.getString(_kThemeMode) ?? 'dark';

  // ── Language ──────────────────────────────────────────────────

  Future<void> saveLanguage(String code) =>
      _prefs.setString(_kLanguage, code);

  String getLanguage() => _prefs.getString(_kLanguage) ?? 'en';

  // ── Onboarding ────────────────────────────────────────────────

  Future<void> markOnboarded() => _prefs.setBool(_kOnboarded, true);

  bool get isOnboarded => _prefs.getBool(_kOnboarded) ?? false;

  // ── Clear ─────────────────────────────────────────────────────

  Future<void> clearAll() => _prefs.clear();
}
