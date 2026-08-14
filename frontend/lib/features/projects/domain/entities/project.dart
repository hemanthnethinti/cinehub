import 'package:cinehubapp/features/profile/domain/entities/profile.dart';

class Project {
  const Project({
    required this.id,
    required this.title,
    required this.slug,
    required this.type,
    required this.status,
    this.tagline,
    this.synopsis,
    this.description,
    this.genres = const [],
    this.tags = const [],
    required this.owner,
    this.posterUrl,
    this.coverUrl,
    this.budget,
    this.duration,
    this.visibility = 'private',
    required this.createdAt,
    required this.updatedAt,
    this.viewCount = 0,
    this.likeCount = 0,
    this.shareCount = 0,
  });

  final String id;
  final String title;
  final String slug;
  final String type;
  final String status;
  final String? tagline;
  final String? synopsis;
  final String? description;
  final List<String> genres;
  final List<String> tags;
  final Profile owner;
  final String? posterUrl;
  final String? coverUrl;
  final ProjectBudget? budget;
  final ProjectDuration? duration;
  final String visibility;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int viewCount;
  final int likeCount;
  final int shareCount;
}

class ProjectBudget {
  const ProjectBudget({
    required this.estimated,
    this.currency = 'USD',
  });
  
  final num estimated;
  final String currency;
}

class ProjectDuration {
  const ProjectDuration({
    required this.estimated,
  });

  final num estimated; // minutes
}

class ProjectPage {
  const ProjectPage({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.total,
    required this.hasNext,
  });

  final List<Project> items;
  final int page;
  final int totalPages;
  final int total;
  final bool hasNext;
}
