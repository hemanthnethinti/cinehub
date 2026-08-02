import '../constants/error_codes.dart';

/// Sealed domain error class.
///
/// All errors in the app are represented as one of these subtypes.
/// Never throw raw exceptions into the presentation layer.
///
/// Usage:
/// ```dart
/// result.when(
///   success: (data) => ...,
///   failure: (error) => error.when(
///     network: (msg, _) => ...,
///     server:  (msg, code) => ...,
///     auth:    (msg) => ...,
///     unknown: (msg) => ...,
///   ),
/// );
/// ```
sealed class AppError {
  const AppError();

  /// Resolve a human-readable message for display.
  String get userMessage;

  // ── Factory constructors ──────────────────────────────────────

  /// No internet connection or request timed out.
  const factory AppError.network({
    required String message,
    String? code,
  }) = NetworkError;

  /// Backend returned a non-2xx HTTP response.
  const factory AppError.server({
    required String message,
    required int statusCode,
    String? errorCode,
  }) = ServerError;

  /// 401 / token expired.
  const factory AppError.auth({required String message}) = AuthError;

  /// Fallback for unexpected errors.
  const factory AppError.unknown({required String message}) = UnknownError;
}

/// No internet / timeout.
final class NetworkError extends AppError {
  const NetworkError({required this.message, this.code});

  final String message;
  final String? code;

  @override
  String get userMessage =>
      code == ErrorCodes.networkTimeout
          ? 'Request timed out. Check your connection.'
          : 'No internet connection.';
}

/// Non-2xx HTTP response from the server.
final class ServerError extends AppError {
  const ServerError({
    required this.message,
    required this.statusCode,
    this.errorCode,
  });

  final String message;
  final int statusCode;
  final String? errorCode;

  @override
  String get userMessage => message;
}

/// 401 / authentication failure.
final class AuthError extends AppError {
  const AuthError({required this.message});

  final String message;

  @override
  String get userMessage => message;
}

/// Unexpected / unhandled error.
final class UnknownError extends AppError {
  const UnknownError({required this.message});

  final String message;

  @override
  String get userMessage => 'Something went wrong. Please try again.';
}
