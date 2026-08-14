/// Location value object — a user's geographic location.
///
/// All fields optional. [displayString] returns a human-readable
/// comma-separated representation of non-empty parts.
final class Location {
  const Location({
    this.city,
    this.state,
    this.country,
  });

  final String? city;
  final String? state;
  final String? country;

  /// E.g. "Mumbai, Maharashtra, India" — omits empty parts.
  String get displayString {
    final parts = [city, state, country]
        .whereType<String>()
        .where((s) => s.isNotEmpty)
        .toList();
    return parts.join(', ');
  }

  bool get isEmpty => displayString.isEmpty;

  Location copyWith({
    String? city,
    String? state,
    String? country,
  }) =>
      Location(
        city: city ?? this.city,
        state: state ?? this.state,
        country: country ?? this.country,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          other.city == city &&
          other.state == state &&
          other.country == country;

  @override
  int get hashCode => Object.hash(city, state, country);

  @override
  String toString() => 'Location($displayString)';
}
