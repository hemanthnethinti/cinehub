import 'dart:io';
import 'package:dio/dio.dart';
import 'package:cinehubapp/core/network/api_client.dart';
import 'package:cinehubapp/core/utils/url_resolver.dart';
import 'package:cinehubapp/features/profile/domain/entities/location.dart';
import 'package:cinehubapp/features/profile/domain/entities/skill.dart';
import 'package:cinehubapp/features/profile/domain/entities/social_links.dart';
import '../models/profile_dto.dart';

/// Profile remote datasource — all HTTP calls for the profile feature.
///
/// Returns raw DTOs. Never maps to domain objects.
/// Never handles [AppError] — exceptions propagate to [ProfileRepositoryImpl].
///
/// Endpoints (base: `/users`):
/// - GET    `/:id`           → getProfile
/// - PATCH  `/profile`       → updateProfile
/// - POST   `/:id/follow`    → followUser
/// - DELETE `/:id/follow`    → unfollowUser
/// - GET    `/:id/followers` → getFollowers
/// - GET    `/:id/following` → getFollowing
class ProfileRemoteDataSource {
  const ProfileRemoteDataSource(this._client);

  final ApiClient _client;

  static const _base = 'users';

  // ── Get Profile ───────────────────────────────────────────────

  Future<ProfileDto> getProfile(String userId) async {
    final response =
        await _client.get<Map<String, dynamic>>('$_base/$userId');
    final data = response.data!['data'] as Map<String, dynamic>;
    return ProfileDto.fromJson(data);
  }

  // ── Update Profile ────────────────────────────────────────────

  /// Sends only non-null fields to `PATCH /users/profile`.
  /// Serializes [Location] and [SocialLinks] domain objects inline.
  Future<ProfileDto> updateProfile({
    String? firstName,
    String? lastName,
    String? bio,
    String? headline,
    String? avatarUrl,
    Location? location,
    List<Skill>? skills,
    SocialLinks? socialLinks,
  }) async {
    final body = <String, dynamic>{};

    if (firstName != null) body['firstName'] = firstName;
    if (lastName != null) body['lastName'] = lastName;
    if (bio != null) body['bio'] = bio;
    if (headline != null) body['headline'] = headline;
    // Backend field name is 'avatar', domain field is 'avatarUrl'.
    if (avatarUrl != null) body['avatar'] = avatarUrl;

    if (location != null) {
      body['location'] = {
        'city': location.city,
        'state': location.state,
        'country': location.country,
      };
    }

    if (skills != null) {
      body['skills'] = skills
          .map((s) => {
                'name': s.name,
                if (s.category != null) 'category': s.category,
                'proficiency': s.proficiency,
              })
          .toList();
    }

    if (socialLinks != null) {
      body['socialLinks'] = {
        if (socialLinks.website != null) 'website': socialLinks.website,
        if (socialLinks.imdb != null) 'imdb': socialLinks.imdb,
        if (socialLinks.linkedin != null) 'linkedin': socialLinks.linkedin,
        if (socialLinks.instagram != null) 'instagram': socialLinks.instagram,
        if (socialLinks.youtube != null) 'youtube': socialLinks.youtube,
        if (socialLinks.vimeo != null) 'vimeo': socialLinks.vimeo,
        if (socialLinks.twitter != null) 'twitter': socialLinks.twitter,
      };
    }

    final response = await _client.patch<Map<String, dynamic>>(
      '$_base/profile',
      data: body,
    );
    final data = response.data!['data'] as Map<String, dynamic>;
    return ProfileDto.fromJson(data);
  }

  // ── Follow ────────────────────────────────────────────────────

  Future<void> followUser(String targetUserId) async {
    await _client.post<void>('$_base/$targetUserId/follow');
  }

  Future<void> unfollowUser(String targetUserId) async {
    await _client.delete<void>('$_base/$targetUserId/follow');
  }

  // ── Social Graph ──────────────────────────────────────────────

  Future<ProfilePageDto> getFollowers(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '$_base/$userId/followers',
      queryParameters: {'page': page, 'limit': limit},
    );
    return ProfilePageDto.fromJson(response.data!);
  }

  Future<ProfilePageDto> getFollowing(
    String userId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '$_base/$userId/following',
      queryParameters: {'page': page, 'limit': limit},
    );
    return ProfilePageDto.fromJson(response.data!);
  }

  // ── Media ─────────────────────────────────────────────────────

  Future<String> uploadAvatar(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final response = await _client.upload<Map<String, dynamic>>(
      'media/upload',
      data: formData,
    );
    final rawUrl = response.data!['data']['url'] as String;
    return UrlResolver.resolveRequired(rawUrl);
  }
}
