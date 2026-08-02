import 'package:cinehubapp/features/auth/domain/entities/user.dart';
import 'package:cinehubapp/features/auth/domain/entities/user_role.dart';

/// Data Transfer Object for the user object returned by the backend.
///
/// Response shape (from `auth.service._sanitizeUser`):
/// ```json
/// {
///   "_id": "...", "email": "...", "firstName": "...", "lastName": "...",
///   "role": "creator", "avatar": "...", "bio": "...", "slug": "...",
///   "isEmailVerified": false, "isActive": true, "createdAt": "..."
/// }
/// ```
final class UserDto {
  const UserDto({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.avatar,
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
  final String role;
  final String? avatar;
  final String? bio;
  final String? slug;
  final bool isEmailVerified;
  final bool isActive;
  final String? createdAt;

  /// Parse from the backend JSON object.
  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
        id: json['_id'] as String? ?? json['id'] as String? ?? '',
        email: json['email'] as String? ?? '',
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        role: json['role'] as String? ?? 'user',
        avatar: json['avatar'] as String?,
        bio: json['bio'] as String?,
        slug: json['slug'] as String?,
        isEmailVerified: json['isEmailVerified'] as bool? ?? false,
        isActive: json['isActive'] as bool? ?? true,
        createdAt: json['createdAt'] as String?,
      );

  /// Convert to the domain [User] entity.
  User toDomain() => User(
        id: id,
        email: email,
        firstName: firstName,
        lastName: lastName,
        role: UserRole.fromValue(role),
        avatarUrl: avatar,
        bio: bio,
        slug: slug,
        isEmailVerified: isEmailVerified,
        isActive: isActive,
        createdAt: createdAt != null ? DateTime.tryParse(createdAt!) : null,
      );
}
