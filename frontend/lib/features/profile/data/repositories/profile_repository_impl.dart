import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/profile/domain/entities/location.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile_page.dart';
import 'package:cinehubapp/features/profile/domain/entities/skill.dart';
import 'package:cinehubapp/features/profile/domain/entities/social_links.dart';
import 'package:cinehubapp/features/profile/domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

/// Concrete implementation of [ProfileRepository].
///
/// Responsibilities:
/// 1. Calls [ProfileRemoteDataSource] for all HTTP operations.
/// 2. Maps [DioException] → [AppError] → [Result.failure].
/// 3. Maps DTOs → domain entities via [toDomain()].
///
/// No business logic lives here — that belongs in use cases.
/// No token management — handled by [AuthInterceptor] + [RefreshInterceptor].
class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl({
    required ProfileRemoteDataSource dataSource,
  }) : _dataSource = dataSource;

  final ProfileRemoteDataSource _dataSource;

  // ── Get Profile ───────────────────────────────────────────────

  @override
  Future<Result<Profile>> getProfile(String userId) async {
    return _execute(() async {
      final dto = await _dataSource.getProfile(userId);
      return dto.toDomain();
    });
  }

  // ── Update Profile ────────────────────────────────────────────

  @override
  Future<Result<Profile>> updateProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? headline,
    String? avatarUrl,
    Location? location,
    List<Skill>? skills,
    SocialLinks? socialLinks,
  }) async {
    return _execute(() async {
      final dto = await _dataSource.updateProfile(
        firstName: firstName,
        lastName: lastName,
        bio: bio,
        headline: headline,
        avatarUrl: avatarUrl,
        location: location,
        skills: skills,
        socialLinks: socialLinks,
      );
      return dto.toDomain();
    });
  }

  // ── Follow / Unfollow ─────────────────────────────────────────

  @override
  Future<Result<void>> followUser(String targetUserId) async {
    return _executeVoid(() => _dataSource.followUser(targetUserId));
  }

  @override
  Future<Result<void>> unfollowUser(String targetUserId) async {
    return _executeVoid(() => _dataSource.unfollowUser(targetUserId));
  }

  // ── Social Graph ──────────────────────────────────────────────

  @override
  Future<Result<ProfilePage>> getFollowers(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    return _execute(() async {
      final dto =
          await _dataSource.getFollowers(userId, page: page, limit: limit);
      return dto.toDomain();
    });
  }

  @override
  Future<Result<ProfilePage>> getFollowing(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    return _execute(() async {
      final dto =
          await _dataSource.getFollowing(userId, page: page, limit: limit);
      return dto.toDomain();
    });
  }

  // ── Media ─────────────────────────────────────────────────────

  @override
  Future<Result<String>> uploadAvatar(File file) async {
    return _execute(() => _dataSource.uploadAvatar(file));
  }

  // ── Private helpers ───────────────────────────────────────────

  /// Wraps a datasource call in try/catch and returns [Result<T>].
  Future<Result<T>> _execute<T>(Future<T> Function() call) async {
    try {
      final data = await call();
      return Result.success(data);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  Future<Result<void>> _executeVoid(Future<void> Function() call) async {
    try {
      await call();
      return Result.success(null);
    } on DioException catch (e) {
      return Result.failure(_mapDioError(e));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  AppError _mapDioError(DioException e) {
    // The ErrorInterceptor may have already attached an AppError.
    if (e.error is AppError) return e.error as AppError;

    final status = e.response?.statusCode;
    final message =
        _extractMessage(e.response?.data) ?? e.message ?? 'Request failed.';

    if (status == 401) return AppError.auth(message: message);
    if (status != null) {
      return AppError.server(message: message, statusCode: status);
    }
    if (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout) {
      return const AppError.network(message: 'No internet connection.');
    }
    return AppError.unknown(message: message);
  }

  String? _extractMessage(dynamic data) {
    if (data is Map) {
      return (data['error'] as Map?)
              ?.cast<String, dynamic>()['message'] as String? ??
          data['message'] as String?;
    }
    return null;
  }
}
