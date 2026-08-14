import 'dart:io';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/core/error/app_error.dart';
import '../entities/profile.dart';
import '../entities/profile_page.dart';
import '../entities/skill.dart';
import '../entities/location.dart';
import '../entities/social_links.dart';

/// Abstract contract for all profile operations.
///
/// The domain layer depends on this interface.
/// The data layer provides [ProfileRepositoryImpl].
///
/// Every method returns [Result<T>] — never throws.
abstract interface class ProfileRepository {
  /// Fetches the full profile for any user by [userId].
  Future<Result<Profile>> getProfile(String userId);

  /// Updates the authenticated user's own profile.
  /// Only non-null fields are sent to the backend.
  Future<Result<Profile>> updateProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? headline,
    String? avatarUrl,
    Location? location,
    List<Skill>? skills,
    SocialLinks? socialLinks,
  });

  /// Follows the user identified by [targetUserId].
  /// Fails with [AppError.auth] if the current user is not authenticated.
  Future<Result<void>> followUser(String targetUserId);

  /// Unfollows the user identified by [targetUserId].
  Future<Result<void>> unfollowUser(String targetUserId);

  /// Returns a paginated list of followers for [userId].
  Future<Result<ProfilePage>> getFollowers(
    String userId, {
    int page = 1,
    int limit = 20,
  });

  /// Returns a paginated list of users that [userId] follows.
  Future<Result<ProfilePage>> getFollowing(
    String userId, {
    int page = 1,
    int limit = 20,
  });

  /// Uploads an avatar image and returns the uploaded media URL.
  Future<Result<String>> uploadAvatar(File file);
}

/// Convenience extension on [Result<void>].
extension VoidResultX on Result<void> {
  bool get succeeded => isSuccess;
  AppError? get failureOrNull => errorOrNull;
}
