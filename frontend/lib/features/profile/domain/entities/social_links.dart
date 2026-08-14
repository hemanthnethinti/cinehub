/// SocialLinks value object — external profile URLs.
///
/// All fields optional — only non-empty links are displayed.
final class SocialLinks {
  const SocialLinks({
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

  /// Returns [true] when every field is null or empty.
  bool get isEmpty =>
      _blank(website) &&
      _blank(imdb) &&
      _blank(linkedin) &&
      _blank(instagram) &&
      _blank(youtube) &&
      _blank(vimeo) &&
      _blank(twitter);

  bool _blank(String? s) => s == null || s.trim().isEmpty;

  SocialLinks copyWith({
    String? website,
    String? imdb,
    String? linkedin,
    String? instagram,
    String? youtube,
    String? vimeo,
    String? twitter,
  }) =>
      SocialLinks(
        website: website ?? this.website,
        imdb: imdb ?? this.imdb,
        linkedin: linkedin ?? this.linkedin,
        instagram: instagram ?? this.instagram,
        youtube: youtube ?? this.youtube,
        vimeo: vimeo ?? this.vimeo,
        twitter: twitter ?? this.twitter,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocialLinks &&
          other.website == website &&
          other.imdb == imdb &&
          other.linkedin == linkedin &&
          other.instagram == instagram &&
          other.youtube == youtube &&
          other.vimeo == vimeo &&
          other.twitter == twitter;

  @override
  int get hashCode =>
      Object.hash(website, imdb, linkedin, instagram, youtube, vimeo, twitter);

  @override
  String toString() => 'SocialLinks(isEmpty: $isEmpty)';
}
