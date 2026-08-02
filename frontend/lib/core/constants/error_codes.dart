/// CineHub error codes used across the app.
///
/// Mirrors the backend error codes from the API response envelope.
/// Example: `{ "error": { "code": "AUTH_001", "message": "..." } }`
abstract final class ErrorCodes {
  // Auth
  static const String authInvalidCredentials = 'AUTH_001';
  static const String authTokenExpired        = 'AUTH_002';
  static const String authTokenInvalid        = 'AUTH_003';
  static const String authEmailTaken          = 'AUTH_004';
  static const String authUnauthorized        = 'AUTH_005';

  // Network
  static const String networkNoConnection  = 'NET_001';
  static const String networkTimeout       = 'NET_002';
  static const String networkServerError   = 'NET_003';
  static const String networkUnknown       = 'NET_004';

  // Resource
  static const String notFound    = 'RES_001';
  static const String forbidden   = 'RES_002';
  static const String validation  = 'RES_003';
}
