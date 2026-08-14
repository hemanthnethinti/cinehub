import 'package:cinehubapp/features/profile/domain/entities/social_links.dart';

/// Data Transfer Object for a user's social links.
///
/// Maps from the backend shape:
/// `{ website, imdb, linkedin, instagram, youtube, vimeo, twitter }`.
final class SocialLinksDto {
  const SocialLinksDto({
    this.website,
    this.imdb,
    this.linkedin,
    this.instagram,
    this.youtube,
    this.vimeo,
    this.twitter,
  });

  final String? website;
  final String? imdb;
  final String? linkedin;
  final String? instagram;
  final String? youtube;
  final String? vimeo;
  final String? twitter;

  factory SocialLinksDto.fromJson(Map<String, dynamic> json) => SocialLinksDto(
        website: json['website'] as String?,
        imdb: json['imdb'] as String?,
        linkedin: json['linkedin'] as String?,
        instagram: json['instagram'] as String?,
        youtube: json['youtube'] as String?,
        vimeo: json['vimeo'] as String?,
        twitter: json['twitter'] as String?,
      );

  SocialLinks toDomain() => SocialLinks(
        website: website,
        imdb: imdb,
        linkedin: linkedin,
        instagram: instagram,
        youtube: youtube,
        vimeo: vimeo,
        twitter: twitter,
      );
}
