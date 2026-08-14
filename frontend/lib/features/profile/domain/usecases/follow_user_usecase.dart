import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/core/error/app_error.dart';
import '../repositories/profile_repository.dart';

/// Follows the user identified by [targetUserId].
///
/// Validates:
/// - [currentUserId] must not be empty.
/// - [targetUserId] must not be empty.
/// - A user cannot follow themselves.
class FollowUserUseCase {
  const FollowUserUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<void>> call({
    required String currentUserId,
    required String targetUserId,
  }) async {
    if (currentUserId.trim().isEmpty) {
      return Result.failure(
        const AppError.auth(message: 'You must be logged in to follow users.'),
      );
    }

    if (targetUserId.trim().isEmpty) {
      return Result.failure(
        const AppError.unknown(message: 'Target user ID must not be empty.'),
      );
    }

    if (currentUserId == targetUserId) {
      return Result.failure(
        const AppError.unknown(message: 'You cannot follow yourself.'),
      );
    }

    return _repository.followUser(targetUserId.trim());
  }
}
