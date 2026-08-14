import 'package:cinehubapp/features/auth/domain/entities/user_role.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile_page.dart';
import 'package:cinehubapp/core/utils/url_resolver.dart';
import 'skill_dto.dart';
import 'location_dto.dart';
import 'social_links_dto.dart';

/// Data Transfer Object for the full user profile.
///
/// Returned by `GET /api/v1/users/:id` and `PATCH /api/v1/users/profile`.
///
/// Backend response shape (inside `data` envelope):
/// ```json
/// {
///   "id": "...", "email": "...", "firstName": "...", "lastName": "...",
///   "role": "creator", "avatar": "...", "coverImage": "...",
///   "bio": "...", "headline": "...", "slug": "...",
///   "skills": [...], "location": {...}, "socialLinks": {...},
///   "followerCount": 0, "followingCount": 0, "projectCount": 0,
///   "isEmailVerified": false, "isActive": true, "createdAt": "..."
/// }
/// ```
final class ProfileDto {
  const ProfileDto({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.avatar,
    this.coverImage,
    this.bio,
    this.headline,
    this.slug,
    this.skills,
    this.location,
    this.socialLinks,
    this.followerCount = 0,
    this.followingCount = 0,
    this.projectCount = 0,
    this.isEmailVerified = false,
    this.isActive = true,
    this.createdAt,
  });

  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String? avatar;
  final String? coverImage;
  final String? bio;
  final String? headline;
  final String? slug;
  final List<SkillDto>? skills;
  final LocationDto? location;
  final SocialLinksDto? socialLinks;
  final int followerCount;
  final int followingCount;
  final int projectCount;
  final bool isEmailVerified;
  final bool isActive;
  final String? createdAt;

  /// Parses from the backend JSON object.
  ///
  /// Handles both `_id` (lean Mongoose result) and `id` (toJSON plugin output).
  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    final rawSkills = json['skills'] as List<dynamic>?;
    final rawLocation = json['location'] as Map<String, dynamic>?;
    final rawLinks = json['socialLinks'] as Map<String, dynamic>?;

    return ProfileDto(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      avatar: UrlResolver.resolve(json['avatar'] as String?),
      coverImage: UrlResolver.resolve(json['coverImage'] as String?),
      bio: json['bio'] as String?,
      headline: json['headline'] as String?,
      slug: json['slug'] as String?,
      skills: rawSkills
          ?.whereType<Map<String, dynamic>>()
          .map(SkillDto.fromJson)
          .toList(),
      location: rawLocation != null ? LocationDto.fromJson(rawLocation) : null,
      socialLinks:
          rawLinks != null ? SocialLinksDto.fromJson(rawLinks) : null,
      followerCount: (json['followerCount'] as num?)?.toInt() ?? 0,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      projectCount: (json['projectCount'] as num?)?.toInt() ?? 0,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: json['createdAt'] as String?,
    );
  }

  /// Converts to the domain [Profile] entity.
  Profile toDomain() => Profile(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: UserRole.fromValue(role),
        avatarUrl: avatar,
        coverImageUrl: coverImage,
        bio: bio,
        headline: headline,
        slug: slug,
        skills: skills?.map((s) => s.toDomain()).toList() ?? const [],
        location: location?.toDomain(),
        socialLinks: socialLinks?.toDomain(),
        followerCount: followerCount,
        followingCount: followingCount,
        projectCount: projectCount,
        isEmailVerified: isEmailVerified,
        isActive: isActive,
        createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      );
}

// ── Paginated wrapper ──────────────────────────────────────────────────────

/// DTO for paginated profile lists (followers, following).
///
/// Backend paginated response shape:
/// ```json
/// {
///   "success": true,
///   "data": [ { ...profile... }, ... ],
///   "pagination": { "page": 1, "limit": 20, "total": 100, "totalPages": 5, "hasNext": true }
/// }
/// ```
final class ProfilePageDto {
  const ProfilePageDto({
    required this.profiles,
    required this.page,
    required this.totalPages,
    required this.total,
    required this.hasNext,
  });

  final List<ProfileDto> profiles;
  final int page;
  final int totalPages;
  final int total;
  final bool hasNext;

  /// Parses from the full paginated response envelope (`response.data!`).
  factory ProfilePageDto.fromJson(Map<String, dynamic> json) {
    final docs = (json['data'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(ProfileDto.fromJson)
        .toList();

    final meta = json['meta'] as Map<String, dynamic>? ?? const {};
    final pagination = meta['pagination'] as Map<String, dynamic>? ?? const {};

    return ProfilePageDto(
      profiles: docs,
      page: (pagination['page'] as num?)?.toInt() ?? 1,
      totalPages: (pagination['totalPages'] as num?)?.toInt() ?? 1,
      total: (pagination['total'] as num?)?.toInt() ?? 0,
      hasNext: pagination['hasNext'] as bool? ?? false,
    );
  }

  ProfilePage toDomain() => ProfilePage(
        profiles: profiles.map((p) => p.toDomain()).toList(),
        page: page,
        totalPages: totalPages,
        total: total,
        hasNext: hasNext,
      );
}
