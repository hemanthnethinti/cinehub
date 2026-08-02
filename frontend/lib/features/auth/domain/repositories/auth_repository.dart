import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/core/error/app_error.dart';
import '../entities/user.dart';

/// Abstract contract for authentication operations.
///
/// The domain layer depends on this interface.
/// The data layer provides [AuthRepositoryImpl].
///
/// Every method returns [Result<T>] — never throws.
abstract interface class AuthRepository {
  /// Login with email and password.
  /// Returns [User] on success with tokens persisted to [SecureStorage].
  Future<Result<User>> login({
    required String email,
    required String password,
  });

  /// Register a new account.
  /// Returns the created [User] with tokens persisted to [SecureStorage].
  Future<Result<User>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  });

  /// Send a password reset email. Always returns success (backend is silent).
  Future<Result<void>> forgotPassword({required String email});

  /// Logout — clears tokens from [SecureStorage] and calls backend.
  Future<Result<void>> logout();

  /// Fetches the current authenticated user from the backend.
  /// Used to validate a stored token on app start.
  Future<Result<User>> getMe();

  /// Returns [true] if a stored access token exists locally.
  /// Does NOT validate with the server.
  Future<bool> hasStoredSession();
}

/// Convenience extension on [Result<void>].
extension VoidResultX on Result<void> {
  /// Returns [true] if this is a [Success].
  bool get succeeded => isSuccess;

  /// Returns the [AppError] or null.
  AppError? get failureOrNull => errorOrNull;
}
