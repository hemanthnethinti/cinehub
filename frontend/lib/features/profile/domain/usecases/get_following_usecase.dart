import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/core/error/app_error.dart';
import '../entities/profile_page.dart';
import '../repositories/profile_repository.dart';

/// Returns a paginated list of users that the given user follows.
///
/// Validates:
/// - [userId] must not be empty.
/// - [page] must be ≥ 1.
/// - [limit] must be between 1 and 100.
class GetFollowingUseCase {
  const GetFollowingUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<ProfilePage>> call({
    required String userId,
    int page = 1,
    int limit = 20,
  }) async {
    if (userId.trim().isEmpty) {
      return Result.failure(
        const AppError.unknown(message: 'User ID must not be empty.'),
      );
    }

    if (page < 1) {
      return Result.failure(
        const AppError.unknown(message: 'Page number must be 1 or greater.'),
      );
    }

    if (limit < 1 || limit > 100) {
      return Result.failure(
        const AppError.unknown(message: 'Limit must be between 1 and 100.'),
      );
    }

    return _repository.getFollowing(userId.trim(), page: page, limit: limit);
  }
}
