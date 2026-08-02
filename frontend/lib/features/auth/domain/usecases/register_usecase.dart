import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/core/error/app_error.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Validates registration fields and delegates to [AuthRepository.register].
///
/// Validation rules mirror `auth.validation.js` from the backend.
class RegisterUseCase {
  const RegisterUseCase(this._repository);
  final AuthRepository _repository;

  Future<Result<User>> call({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String role,
  }) async {
    final errors = _validate(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
    if (errors != null) {
      return Result.failure(AppError.auth(message: errors));
    }

    return _repository.register(
      email: email,
      password: password,
      firstName: firstName.trim(),
      lastName: lastName.trim(),
      role: role,
    );
  }

  /// Returns the first validation error message, or null if valid.
  String? _validate({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) {
    if (firstName.trim().isEmpty) return 'First name is required.';
    if (firstName.trim().length > 50) return 'First name is too long.';
    if (lastName.trim().isEmpty) return 'Last name is required.';
    if (lastName.trim().length > 50) return 'Last name is too long.';

    if (email.isEmpty) return 'Email is required.';
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email.trim())) return 'Enter a valid email address.';

    if (password.isEmpty) return 'Password is required.';
    if (password.length < 8) return 'Password must be at least 8 characters.';
    if (password.length > 128) return 'Password is too long.';
    // Mirrors backend pattern: /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)/
    final pwdRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)');
    if (!pwdRegex.hasMatch(password)) {
      return 'Password must include uppercase, lowercase, and a number.';
    }

    return null;
  }
}
