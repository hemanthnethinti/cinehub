import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/core/error/app_error.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

/// Fetches the full profile for any user.
///
/// Used for both the own profile tab and public user profiles.
///
/// Fails with [AppError.unknown] if [userId] is empty.
class GetProfileUseCase {
  const GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<Profile>> call(String userId) async {
    if (userId.trim().isEmpty) {
      return Result.failure(
        const AppError.unknown(message: 'User ID must not be empty.'),
      );
    }
    return _repository.getProfile(userId.trim());
  }
}
