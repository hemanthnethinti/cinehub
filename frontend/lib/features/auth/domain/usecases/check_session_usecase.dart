import 'package:cinehubapp/core/result/result.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Checks whether a valid stored session exists on device start.
///
/// Strategy:
/// 1. Check [AuthRepository.hasStoredSession] — fast local check.
/// 2. If a token exists, call [AuthRepository.getMe] to validate it.
/// 3. If [getMe] fails (401 / network), the refresh interceptor will
///    have already attempted a token refresh. If it still fails,
///    the session is considered expired.
///
/// Used by [SplashScreen] → [AuthNotifier.checkSession].
class CheckSessionUseCase {
  const CheckSessionUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<User?>> call() async {
    final hasToken = await _repository.hasStoredSession();
    if (!hasToken) return Result.success(null);

    // Validate token with server.
    final result = await _repository.getMe();
    return result.when(
      success: (user) => Result.success(user),
      failure: (_)     => Result.success(null), // Expired / invalid — treat as logged out
    );
  }
}
