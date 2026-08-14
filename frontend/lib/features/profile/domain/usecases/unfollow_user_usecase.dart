import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/core/error/app_error.dart';
import '../repositories/profile_repository.dart';

/// Unfollows the user identified by [targetUserId].
///
/// Validates:
/// - [targetUserId] must not be empty.
/// - A user cannot unfollow themselves (no-op guard).
class UnfollowUserUseCase {
  const UnfollowUserUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<void>> call({
    required String currentUserId,
    required String targetUserId,
  }) async {
    if (currentUserId.trim().isEmpty) {
      return Result.failure(
        const AppError.auth(message: 'You must be logged in to unfollow users.'),
      );
    }

    if (targetUserId.trim().isEmpty) {
      return Result.failure(
        const AppError.unknown(message: 'Target user ID must not be empty.'),
      );
    }

    if (currentUserId == targetUserId) {
      return Result.failure(
        const AppError.unknown(message: 'You cannot unfollow yourself.'),
      );
    }

    return _repository.unfollowUser(targetUserId.trim());
  }
}
