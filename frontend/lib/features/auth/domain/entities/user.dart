import 'user_role.dart';

/// Core user domain entity.
///
/// This is the clean domain object — no JSON, no Dio, no Flutter.
/// It is constructed by the repository from [UserDto] and passed to the
/// presentation layer via [AuthNotifier].
///
/// All fields are immutable. Changes produce a new [User] via [copyWith].
final class User {
  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.avatarUrl,
    this.bio,
    this.slug,
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
  final String? bio;
  final String? slug;
  final bool isEmailVerified;
  final bool isActive;
  final DateTime? createdAt;

  /// Full display name.
  String get fullName => '$firstName $lastName'.trim();

  /// Initials for [CachedAvatar] when no photo is available.
  String get initials {
    final f = firstName.isNotEmpty ? firstName[0] : '';
    final l = lastName.isNotEmpty ? lastName[0] : '';
    return '$f$l'.toUpperCase();
  }

  User copyWith({
    String? id,
    String? email,
    String? firstName,
    String? lastName,
    UserRole? role,
    String? avatarUrl,
    String? bio,
    String? slug,
    bool? isEmailVerified,
    bool? isActive,
    DateTime? createdAt,
  }) =>
      User(
        id: id ?? this.id,
        email: email ?? this.email,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        role: role ?? this.role,
        avatarUrl: avatarUrl ?? this.avatarUrl,
        bio: bio ?? this.bio,
        slug: slug ?? this.slug,
        isEmailVerified: isEmailVerified ?? this.isEmailVerified,
        isActive: isActive ?? this.isActive,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is User && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'User(id: $id, email: $email, role: ${role.value})';
}
