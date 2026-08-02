import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure token storage backed by Keychain (iOS) / Keystore (Android).
///
/// Only tokens and sensitive credentials are stored here.
/// Preferences (theme, language) use [LocalStorage] instead.
class SecureStorage {
  SecureStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const _kAccessToken  = 'access_token';
  static const _kRefreshToken = 'refresh_token';

  // ── Access Token ──────────────────────────────────────────────

  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _kAccessToken, value: token);

  Future<String?> getAccessToken() =>
      _storage.read(key: _kAccessToken);

  Future<void> deleteAccessToken() =>
      _storage.delete(key: _kAccessToken);

  // ── Refresh Token ─────────────────────────────────────────────

  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _kRefreshToken, value: token);

  Future<String?> getRefreshToken() =>
      _storage.read(key: _kRefreshToken);

  Future<void> deleteRefreshToken() =>
      _storage.delete(key: _kRefreshToken);

  // ── Clear All ─────────────────────────────────────────────────

  /// Called on logout — removes all stored credentials.
  Future<void> clearAll() => _storage.deleteAll();

  // ── Session Check ─────────────────────────────────────────────

  /// Returns `true` if a stored access token exists.
  /// Does NOT validate the token with the server.
  Future<bool> hasSession() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
