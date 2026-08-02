import 'package:cinehubapp/core/result/result.dart';
import '../repositories/auth_repository.dart';

/// Clears tokens from [SecureStorage] and notifies the backend.
///
/// Always returns success from the UI's perspective —
/// even if the backend call fails, the local session is wiped.
class LogoutUseCase {
  const LogoutUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<void>> call() => _repository.logout();
}
