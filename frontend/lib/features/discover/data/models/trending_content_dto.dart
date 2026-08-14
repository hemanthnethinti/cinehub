import 'package:cinehubapp/features/discover/domain/entities/trending_content.dart';
import 'package:cinehubapp/features/home/data/models/project_feed_dto.dart';
import 'package:cinehubapp/features/profile/data/models/profile_dto.dart';

/// DTO for the trending endpoint response.
final class TrendingContentDto {
  const TrendingContentDto({
    required this.creators,
    required this.projects,
    required this.portfolios,
  });

  final List<ProfileDto> creators;
  final List<ProjectFeedDto> projects;
  final List<ProjectFeedDto> portfolios; // Assuming portfolios have a similar structure for now

  factory TrendingContentDto.fromJson(Map<String, dynamic> json) {
    final creatorsList = (json['creators'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(ProfileDto.fromJson)
        .toList();

    final projectsList = (json['projects'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(ProjectFeedDto.fromJson)
        .toList();

    final portfoliosList = (json['portfolios'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(ProjectFeedDto.fromJson)
        .toList();

    return TrendingContentDto(
      creators: creatorsList,
      projects: projectsList,
      portfolios: portfoliosList,
    );
  }

  TrendingContent toDomain() {
    return TrendingContent(
      creators: creators.map((e) => e.toDomain()).toList(),
      projects: projects.map((e) => e.toDomain()).toList(),
      portfolios: portfolios.map((e) => e.toDomain()).toList(),
    );
  }
}
