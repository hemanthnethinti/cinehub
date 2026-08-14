import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/di/providers.dart';
import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart'
    show AuthAuthenticated, authNotifierProvider;
import 'package:cinehubapp/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:cinehubapp/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile_page.dart';
import 'package:cinehubapp/features/profile/domain/repositories/profile_repository.dart';
import 'package:cinehubapp/features/profile/domain/usecases/follow_user_usecase.dart';
import 'package:cinehubapp/features/profile/domain/usecases/get_followers_usecase.dart';
import 'package:cinehubapp/features/profile/domain/usecases/get_following_usecase.dart';
import 'package:cinehubapp/features/profile/domain/usecases/get_profile_usecase.dart';
import 'dart:io';
import 'package:cinehubapp/features/profile/domain/usecases/unfollow_user_usecase.dart';
import 'package:cinehubapp/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:cinehubapp/features/profile/domain/usecases/upload_avatar_usecase.dart';
import 'profile_state.dart';
export 'profile_state.dart';

// ═══════════════════════════════════════════════════════════════
//  INFRASTRUCTURE PROVIDERS — Data → Repository → Use Cases
// ═══════════════════════════════════════════════════════════════

final _profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>(
  (ref) => ProfileRemoteDataSource(ref.watch(apiClientProvider)),
  name: 'ProfileRemoteDataSource',
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(
    dataSource: ref.watch(_profileRemoteDataSourceProvider),
  ),
  name: 'ProfileRepository',
);

// ── Use Case Providers ────────────────────────────────────────

final getProfileUseCaseProvider = Provider<GetProfileUseCase>(
  (ref) => GetProfileUseCase(ref.watch(profileRepositoryProvider)),
  name: 'GetProfileUseCase',
);

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>(
  (ref) => UpdateProfileUseCase(ref.watch(profileRepositoryProvider)),
  name: 'UpdateProfileUseCase',
);

final uploadAvatarUseCaseProvider = Provider<UploadAvatarUseCase>(
  (ref) => UploadAvatarUseCase(ref.watch(profileRepositoryProvider)),
  name: 'UploadAvatarUseCase',
);

final followUserUseCaseProvider = Provider<FollowUserUseCase>(
  (ref) => FollowUserUseCase(ref.watch(profileRepositoryProvider)),
  name: 'FollowUserUseCase',
);

final unfollowUserUseCaseProvider = Provider<UnfollowUserUseCase>(
  (ref) => UnfollowUserUseCase(ref.watch(profileRepositoryProvider)),
  name: 'UnfollowUserUseCase',
);

final getFollowersUseCaseProvider = Provider<GetFollowersUseCase>(
  (ref) => GetFollowersUseCase(ref.watch(profileRepositoryProvider)),
  name: 'GetFollowersUseCase',
);

final getFollowingUseCaseProvider = Provider<GetFollowingUseCase>(
  (ref) => GetFollowingUseCase(ref.watch(profileRepositoryProvider)),
  name: 'GetFollowingUseCase',
);

// ═══════════════════════════════════════════════════════════════
//  PROFILE NOTIFIER
// ═══════════════════════════════════════════════════════════════

/// Drives all mutable profile state transitions for the authenticated user.
///
/// State machine:
/// ```
/// ProfileInitial
///   → [loadProfile]     → ProfileLoading → ProfileLoaded | ProfileFailure
///
/// ProfileLoaded
///   → [refresh]         → ProfileLoading → ProfileLoaded | ProfileFailure
///   → [updateProfile]   → ProfileUpdating → ProfileSuccess | ProfileFailure
///   → [followUser]      → ProfileUpdating → ProfileSuccess | ProfileFailure
///   → [unfollowUser]    → ProfileUpdating → ProfileSuccess | ProfileFailure
///   → [clearStatus]     → ProfileLoaded (after Success/Failure with profile)
/// ```
class ProfileNotifier extends Notifier<ProfileState> {
  @override
  ProfileState build() => const ProfileInitial();

  /// Last loaded userId — used by [refresh] to re-fetch without arguments.
  String? _currentUserId;

  // ── Load ──────────────────────────────────────────────────────

  Future<void> loadProfile(String userId) async {
    _currentUserId = userId;
    state = const ProfileLoading();
    final result = await ref.read(getProfileUseCaseProvider).call(userId);
    result.when(
      success: (profile) => state = ProfileLoaded(profile),
      failure: (error) => state = ProfileFailure(error: error),
    );
  }

  // ── Refresh ───────────────────────────────────────────────────

  /// Re-fetches the last loaded profile. No-op if no profile was loaded.
  Future<void> refresh() async {
    if (_currentUserId == null) return;
    await loadProfile(_currentUserId!);
  }

  // ── Update Profile ────────────────────────────────────────────

  Future<void> updateProfile(ProfileUpdateParams params) async {
    final previous = _currentProfile;
    if (previous == null) return;

    state = ProfileUpdating(previous);
    final result =
        await ref.read(updateProfileUseCaseProvider).call(params);
    result.when(
      success: (updated) => state = ProfileSuccess(
        profile: updated,
        message: 'Profile updated.',
      ),
      failure: (error) => state = ProfileFailure(
        error: error,
        previousProfile: previous,
      ),
    );
  }

  // ── Upload Avatar ─────────────────────────────────────────────

  Future<void> uploadAvatar(File file) async {
    final previous = _currentProfile;
    if (previous == null) return;

    state = ProfileUpdating(previous);
    
    // 1. Upload
    final uploadResult = await ref.read(uploadAvatarUseCaseProvider).call(file);
    
    await uploadResult.when(
      success: (url) async {
        // 2. call updateProfile(avatar:url)
        final updateParams = ProfileUpdateParams(avatarUrl: url);
        final updateResult = await ref.read(updateProfileUseCaseProvider).call(updateParams);
        
        updateResult.when(
          success: (updated) {
            state = ProfileSuccess(
              profile: updated,
              message: 'Avatar updated successfully.',
            );
            // 3. refresh profile (optimistic update is sufficient, but per requirements we can call loadProfile silently or just keep it)
          },
          failure: (error) {
            state = ProfileFailure(
              error: error,
              previousProfile: previous,
            );
          },
        );
      },
      failure: (error) async {
        state = ProfileFailure(
          error: error,
          previousProfile: previous,
        );
      },
    );
  }

  // ── Follow ────────────────────────────────────────────────────

  Future<void> followUser(String targetUserId) async {
    final previous = _currentProfile;
    if (previous == null) return;

    final currentUserId = _resolveCurrentUserId();
    if (currentUserId == null) {
      state = ProfileFailure(
        error: const AppError.auth(message: 'You must be logged in to follow users.'),
        previousProfile: previous,
      );
      return;
    }

    state = ProfileUpdating(previous);
    final result = await ref.read(followUserUseCaseProvider).call(
          currentUserId: currentUserId,
          targetUserId: targetUserId,
        );
    result.when(
      success: (_) => state = ProfileSuccess(
        // Optimistically bump the follower count on the displayed profile.
        profile: previous.copyWith(
          followerCount: previous.followerCount + 1,
        ),
        message: 'Following.',
      ),
      failure: (error) => state = ProfileFailure(
        error: error,
        previousProfile: previous,
      ),
    );
  }

  // ── Unfollow ──────────────────────────────────────────────────

  Future<void> unfollowUser(String targetUserId) async {
    final previous = _currentProfile;
    if (previous == null) return;

    final currentUserId = _resolveCurrentUserId();
    if (currentUserId == null) {
      state = ProfileFailure(
        error: const AppError.auth(message: 'You must be logged in to unfollow users.'),
        previousProfile: previous,
      );
      return;
    }

    state = ProfileUpdating(previous);
    final result = await ref.read(unfollowUserUseCaseProvider).call(
          currentUserId: currentUserId,
          targetUserId: targetUserId,
        );
    result.when(
      success: (_) => state = ProfileSuccess(
        profile: previous.copyWith(
          followerCount: (previous.followerCount - 1).clamp(0, double.maxFinite.toInt()),
        ),
        message: 'Unfollowed.',
      ),
      failure: (error) => state = ProfileFailure(
        error: error,
        previousProfile: previous,
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────

  /// Restores [ProfileLoaded] after a [ProfileSuccess] or [ProfileFailure].
  /// Call from screens after handling the one-shot event via [ref.listen].
  void clearStatus() {
    switch (state) {
      case ProfileSuccess(:final profile):
        state = ProfileLoaded(profile);
      case ProfileFailure(:final previousProfile) when previousProfile != null:
        state = ProfileLoaded(previousProfile);
      default:
        break;
    }
  }

  /// The currently known [Profile], extracted from any state that carries one.
  Profile? get _currentProfile => switch (state) {
        ProfileLoaded(:final profile)   => profile,
        ProfileUpdating(:final profile) => profile,
        ProfileSuccess(:final profile)  => profile,
        ProfileFailure(:final previousProfile) => previousProfile,
        _ => null,
      };

  /// Reads the authenticated user's ID from the auth notifier.
  String? _resolveCurrentUserId() {
    final authState = ref.read(authNotifierProvider);
    return authState is AuthAuthenticated ? authState.user.id : null;
  }

  /// Convenience getter for the currently loaded profile (or null).
  Profile? get currentProfile => _currentProfile;

  bool get isLoading =>
      state is ProfileLoading || state is ProfileUpdating;
}

// ═══════════════════════════════════════════════════════════════
//  ROOT PROVIDERS
// ═══════════════════════════════════════════════════════════════

/// The root profile notifier provider.
///
/// Observed by [ProfileScreen], [EditProfileScreen], and [UserProfileScreen].
final profileNotifierProvider =
    NotifierProvider<ProfileNotifier, ProfileState>(ProfileNotifier.new);

/// Read-only provider for any user's public profile, keyed by userId.
///
/// Used by [UserProfileScreen] and [UserListTile] to display other users.
/// Throws [AppError] on failure — caught by Riverpod as [AsyncError].
final userProfileProvider = FutureProvider.autoDispose.family<Profile, String>(
  (ref, userId) async {
    final result =
        await ref.read(getProfileUseCaseProvider).call(userId);
    return result.when(
      success: (profile) => profile,
      failure: (error) => throw error,
    );
  },
  name: 'UserProfile',
);

/// Paginated followers for a given userId.
///
/// Keyed by `(userId, page)` — used by [FollowersScreen].
final followersProvider =
    FutureProvider.autoDispose.family<ProfilePage, (String, int)>(
  (ref, args) async {
    final (userId, page) = args;
    final result = await ref
        .read(getFollowersUseCaseProvider)
        .call(userId: userId, page: page);
    return result.when(
      success: (page) => page,
      failure: (error) => throw error,
    );
  },
  name: 'Followers',
);

/// Paginated following for a given userId.
///
/// Keyed by `(userId, page)` — used by [FollowingScreen].
final followingProvider =
    FutureProvider.autoDispose.family<ProfilePage, (String, int)>(
  (ref, args) async {
    final (userId, page) = args;
    final result = await ref
        .read(getFollowingUseCaseProvider)
        .call(userId: userId, page: page);
    return result.when(
      success: (page) => page,
      failure: (error) => throw error,
    );
  },
  name: 'Following',
);
