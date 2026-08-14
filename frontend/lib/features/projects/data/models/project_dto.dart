import 'package:cinehubapp/features/profile/data/models/profile_dto.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile.dart';
import 'package:cinehubapp/features/auth/domain/entities/user_role.dart';
import 'package:cinehubapp/features/projects/domain/entities/project.dart';
import 'package:cinehubapp/core/utils/url_resolver.dart';

final class ProjectDto {
  const ProjectDto({
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
    this.owner,
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
  final ProfileDto? owner;
  final String? posterUrl;
  final String? coverUrl;
  final Map<String, dynamic>? budget;
  final Map<String, dynamic>? duration;
  final String visibility;
  final String? createdAt;
  final String? updatedAt;
  final int viewCount;
  final int likeCount;
  final int shareCount;

  factory ProjectDto.fromJson(Map<String, dynamic> json) {
    return ProjectDto(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled',
      slug: json['slug'] as String? ?? '',
      type: json['type'] as String? ?? 'short_film',
      status: json['status'] as String? ?? 'draft',
      tagline: json['tagline'] as String?,
      synopsis: json['synopsis'] as String?,
      description: json['description'] as String?,
      genres: (json['genres'] as List<dynamic>? ?? []).cast<String>(),
      tags: (json['tags'] as List<dynamic>? ?? []).cast<String>(),
      owner: json['owner'] != null && json['owner'] is Map<String, dynamic>
          ? ProfileDto.fromJson(json['owner'] as Map<String, dynamic>)
          : null,
      posterUrl: UrlResolver.resolve(json['poster'] as String?),
      coverUrl: UrlResolver.resolve(json['coverImage'] as String?),
      budget: json['budget'] as Map<String, dynamic>?,
      duration: json['duration'] as Map<String, dynamic>?,
      visibility: json['visibility'] as String? ?? 'private',
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      shareCount: (json['shareCount'] as num?)?.toInt() ?? 0,
    );
  }

  Project toDomain() {
    ProjectBudget? projectBudget;
    if (budget != null && budget!['estimated'] != null) {
      projectBudget = ProjectBudget(
        estimated: budget!['estimated'] as num,
        currency: budget!['currency'] as String? ?? 'USD',
      );
    }

    ProjectDuration? projectDuration;
    if (duration != null && duration!['estimated'] != null) {
      projectDuration = ProjectDuration(
        estimated: duration!['estimated'] as num,
      );
    }

    return Project(
      id: id,
      title: title,
      slug: slug,
      type: type,
      status: status,
      tagline: tagline,
      synopsis: synopsis,
      description: description,
      genres: genres,
      tags: tags,
      owner: owner?.toDomain() ?? _fallbackProfile(),
      posterUrl: posterUrl,
      coverUrl: coverUrl,
      budget: projectBudget,
      duration: projectDuration,
      visibility: visibility,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) ?? DateTime.now() : DateTime.now(),
      updatedAt: updatedAt != null ? DateTime.tryParse(updatedAt!) ?? DateTime.now() : DateTime.now(),
      viewCount: viewCount,
      likeCount: likeCount,
      shareCount: shareCount,
    );
  }

  Profile _fallbackProfile() {
    return Profile(
      id: 'unknown',
      email: '',
      firstName: 'Unknown',
      lastName: 'User',
      role: UserRole.user,
      isActive: false,
      isEmailVerified: false,
    );
  }
}

final class ProjectPageDto {
  const ProjectPageDto({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.total,
    required this.hasNext,
  });

  final List<ProjectDto> items;
  final int page;
  final int totalPages;
  final int total;
  final bool hasNext;

  factory ProjectPageDto.fromJson(Map<String, dynamic> json) {
    final docs = (json['data'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(ProjectDto.fromJson)
        .toList();

    final meta = json['meta'] as Map<String, dynamic>? ?? const {};
    final pagination = meta['pagination'] as Map<String, dynamic>? ?? const {};

    return ProjectPageDto(
      items: docs,
      page: (pagination['page'] as num?)?.toInt() ?? 1,
      totalPages: (pagination['totalPages'] as num?)?.toInt() ?? 1,
      total: (pagination['total'] as num? ?? pagination['totalDocs'] as num?)
              ?.toInt() ??
          0,
      hasNext: pagination['hasNext'] as bool? ??
          pagination['hasNextPage'] as bool? ??
          false,
    );
  }

  ProjectPage toDomain() {
    return ProjectPage(
      items: items.map((e) => e.toDomain()).toList(),
      page: page,
      totalPages: totalPages,
      total: total,
      hasNext: hasNext,
    );
  }
}
