import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/core/error/app_error.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Validates login form fields before calling the repository.
///
/// Validation rules mirror the backend Joi schema in `auth.validation.js`.
class LoginUseCase {
  const LoginUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<User>> call({
    required String email,
    required String password,
  }) async {
    final emailError = _validateEmail(email);
    if (emailError != null) {
      return Result.failure(AppError.auth(message: emailError));
    }

    if (password.isEmpty) {
      return Result.failure(const AppError.auth(message: 'Password is required.'));
    }

    return _repository.login(email: email, password: password);
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) return 'Email is required.';
    final regex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!regex.hasMatch(email.trim())) return 'Enter a valid email address.';
    return null;
  }
}
