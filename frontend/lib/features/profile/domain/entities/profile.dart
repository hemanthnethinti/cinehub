import 'package:cinehubapp/features/auth/domain/entities/user_role.dart';
import 'skill.dart';
import 'location.dart';
import 'social_links.dart';

/// Rich profile entity — the full user profile as seen by the domain layer.
///
/// Distinct from the lightweight [User] entity (auth-only, 10 fields).
/// [Profile] carries every field needed by the profile feature.
///
/// Equality is by [id] only.
/// Profile completion is computed by [completionPercent] (0–100).
final class Profile {
  const Profile({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.avatarUrl,
    this.coverImageUrl,
    this.bio,
    this.headline,
    this.slug,
    this.skills = const [],
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
  final UserRole role;
  final String? avatarUrl;
  final String? coverImageUrl;
  final String? bio;

  /// Short professional tagline. E.g. "Director | Cinematographer".
  final String? headline;

  /// URL-friendly unique identifier.
  final String? slug;

  final List<Skill> skills;
  final Location? location;
  final SocialLinks? socialLinks;

  final int followerCount;
  final int followingCount;
  final int projectCount;

  final bool isEmailVerified;
  final bool isActive;
  final DateTime? createdAt;

  // ── Derived ────────────────────────────────────────────────────

  String get fullName => '$firstName $lastName'.trim();

  /// Two-letter initials for avatar fallback.
  String get initials {
    final f = firstName.isNotEmpty ? firstName[0].toUpperCase() : '';
    final l = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$f$l';
  }

  int get completionPercent {
    var score = 0;
    if (avatarUrl != null && avatarUrl!.isNotEmpty) score += 10;
    if (firstName.trim().isNotEmpty) score += 10;
    if (lastName.trim().isNotEmpty) score += 10;
    if (headline != null && headline!.trim().isNotEmpty) score += 10;
    if (bio != null && bio!.trim().isNotEmpty) score += 15;
    if (location != null && !location!.isEmpty) score += 10;
    if (skills.isNotEmpty) score += 15;
    if (socialLinks != null && !socialLinks!.isEmpty) score += 10;
    if (isEmailVerified) score += 10;
    return score.clamp(0, 100);
  }

  /// List of actionable suggestions for missing profile fields.
  List<String> get missingProfileSteps {
    final steps = <String>[];
    if (avatarUrl == null || avatarUrl!.isEmpty) steps.add('Upload an avatar');
    if (firstName.trim().isEmpty) steps.add('Add your first name');
    if (lastName.trim().isEmpty) steps.add('Add your last name');
    if (headline == null || headline!.trim().isEmpty) steps.add('Add a headline');
    if (bio == null || bio!.trim().isEmpty) steps.add('Complete your bio');
    if (location == null || location!.isEmpty) steps.add('Add your location');
    if (skills.isEmpty) steps.add('Add more skills');
    if (socialLinks == null || socialLinks!.isEmpty) steps.add('Add social links');
    if (!isEmailVerified) steps.add('Verify email');
    return steps;
  }

  Profile copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    UserRole? role,
    String? avatarUrl,
    String? coverImageUrl,
    String? bio,
    String? headline,
    String? slug,
    List<Skill>? skills,
    Location? location,
    SocialLinks? socialLinks,
    int? followerCount,
    int? followingCount,
    int? projectCount,
    bool? isEmailVerified,
    bool? isActive,
    DateTime? createdAt,
  }) =>
      Profile(
        id: id ?? this.id,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        role: role ?? this.role,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        coverImageUrl: coverImageUrl ?? this.coverImageUrl,
        bio: bio ?? this.bio,
        headline: headline ?? this.headline,
        slug: slug ?? this.slug,
        skills: skills ?? this.skills,
        location: location ?? this.location,
        socialLinks: socialLinks ?? this.socialLinks,
        followerCount: followerCount ?? this.followerCount,
        followingCount: followingCount ?? this.followingCount,
        projectCount: projectCount ?? this.projectCount,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Profile && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Profile(id: $id, name: $fullName, role: $role)';
}
