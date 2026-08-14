import 'package:cinehubapp/features/profile/domain/entities/location.dart';

/// Data Transfer Object for a user's location.
///
/// Maps from the backend shape: `{ city, state, country }`.
/// Coordinates field (`location.coordinates`) is intentionally omitted
/// — not needed in the Flutter client at this phase.
final class LocationDto {
  const LocationDto({
    this.city,
    this.state,
    this.country,
  });

  final String? city;
  final String? state;
  final String? country;

  factory LocationDto.fromJson(Map<String, dynamic> json) => LocationDto(
        city: json['city'] as String?,
        state: json['state'] as String?,
        country: json['country'] as String?,
      );

  Location toDomain() => Location(
        city: city,
        state: state,
        country: country,
      );
}
