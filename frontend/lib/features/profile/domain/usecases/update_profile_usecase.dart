import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/core/error/app_error.dart';
import '../entities/profile.dart';
import '../entities/skill.dart';
import '../entities/location.dart';
import '../entities/social_links.dart';
import '../repositories/profile_repository.dart';

/// Input model for [UpdateProfileUseCase].
///
/// Domain-layer input object — not a DTO (no fromJson / toJson).
/// Only fields that are non-null will be sent to the backend.
final class ProfileUpdateParams {
  const ProfileUpdateParams({
    this.firstName,
    this.lastName,
    this.bio,
    this.headline,
    this.avatarUrl,
    this.location,
    this.skills,
    this.socialLinks,
  });

  final String? firstName;
  final String? lastName;
  final String? bio;
  final String? headline;
  final String? avatarUrl;
  final Location? location;
  final List<Skill>? skills;
  final SocialLinks? socialLinks;

  /// Returns [true] when at least one field is provided.
  bool get hasData =>
      firstName != null ||
      lastName != null ||
      bio != null ||
      headline != null ||
      avatarUrl != null ||
      location != null ||
      skills != null ||
      socialLinks != null;
}

/// Updates the authenticated user's own profile.
///
/// Validates:
/// - At least one field must be provided.
/// - [firstName] and [lastName], if provided, must not be blank after trimming.
/// - [skills] list must not exceed 20 items.
///
/// Does NOT handle avatar file upload — that is [UploadAvatarUseCase] (Task 2.11).
/// [avatarUrl] here accepts a URL string already returned by the media upload API.
class UpdateProfileUseCase {
  const UpdateProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<Profile>> call(ProfileUpdateParams params) async {
    if (!params.hasData) {
      return Result.failure(
        const AppError.unknown(message: 'No profile fields provided to update.'),
      );
    }

    if (params.firstName != null && params.firstName!.trim().isEmpty) {
      return Result.failure(
        const AppError.unknown(message: 'First name must not be blank.'),
      );
    }

    if (params.lastName != null && params.lastName!.trim().isEmpty) {
      return Result.failure(
        const AppError.unknown(message: 'Last name must not be blank.'),
      );
    }

    if (params.skills != null && params.skills!.length > 20) {
      return Result.failure(
        const AppError.unknown(message: 'You can add a maximum of 20 skills.'),
      );
    }

    return _repository.updateProfile(
      firstName: params.firstName?.trim(),
      lastName: params.lastName?.trim(),
      bio: params.bio,
      headline: params.headline,
      avatarUrl: params.avatarUrl,
      location: params.location,
      skills: params.skills,
      socialLinks: params.socialLinks,
    );
  }
}
