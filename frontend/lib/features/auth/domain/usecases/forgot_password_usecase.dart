import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/core/error/app_error.dart';
import '../repositories/auth_repository.dart';

/// Validates email and calls [AuthRepository.forgotPassword].
///
/// The backend always returns 200 regardless of whether the email exists
/// (to prevent email enumeration). This use case mirrors that behaviour.
class ForgotPasswordUseCase {
  const ForgotPasswordUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<void>> call({required String email}) async {
    if (email.trim().isEmpty) {
      return Result.failure(const AppError.auth(message: 'Email is required.'));
    }
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email.trim())) {
      return Result.failure(const AppError.auth(message: 'Enter a valid email address.'));
    }
    return _repository.forgotPassword(email: email.trim());
  }
}
