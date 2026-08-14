import 'package:cinehubapp/features/home/domain/entities/feed_item.dart';
import 'package:cinehubapp/features/profile/data/models/profile_dto.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile.dart';
import 'package:cinehubapp/features/auth/domain/entities/user_role.dart';
import 'package:cinehubapp/features/home/domain/entities/feed_page.dart';
import 'package:cinehubapp/core/utils/url_resolver.dart';

/// DTO for a project mapped into a FeedItem.
final class ProjectFeedDto {
  const ProjectFeedDto({
    required this.id,
    required this.title,
    required this.type,
    this.description,
    this.imageUrl,
    this.owner,
    this.viewCount = 0,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String type;
  final String? description;
  final String? imageUrl;
  final ProfileDto? owner;
  final int viewCount;
  final String? createdAt;

  factory ProjectFeedDto.fromJson(Map<String, dynamic> json) {
    return ProjectFeedDto(
      id: json['_id'] as String? ?? json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled',
      type: json['type'] as String? ?? 'project',
      description: json['description'] as String?,
      imageUrl: UrlResolver.resolve(json['poster'] as String? ?? json['coverImage'] as String?),  // backend keys: poster, coverImage
      owner: json['owner'] != null && json['owner'] is Map<String, dynamic>
          ? ProfileDto.fromJson(json['owner'] as Map<String, dynamic>)
          : null,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] as String?,
    );
  }

  FeedItem toDomain() {
    return FeedItem(
      id: id,
      title: title,
      type: 'Project • ${_formatType(type)}',
      description: description,
      imageUrl: imageUrl,
      author: owner?.toDomain() ?? _fallbackProfile(),
      likeCount: viewCount, // Using viewCount as a proxy for likes since projects lack likes
      commentCount: 0,
      isLiked: false,
      isBookmarked: false,
      createdAt: createdAt != null ? DateTime.tryParse(createdAt!) ?? DateTime.now() : DateTime.now(),
    );
  }

  String _formatType(String t) {
    return t.split('_').map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '').join(' ');
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

/// DTO for paginated feed lists.
final class FeedPageDto {
  const FeedPageDto({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.total,
    required this.hasNext,
  });

  final List<ProjectFeedDto> items;
  final int page;
  final int totalPages;
  final int total;
  final bool hasNext;

  factory FeedPageDto.fromJson(Map<String, dynamic> json) {
    final docs = (json['data'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(ProjectFeedDto.fromJson)
        .toList();

    final meta = json['meta'] as Map<String, dynamic>? ?? const {};
    final pagination = meta['pagination'] as Map<String, dynamic>? ?? const {};

    return FeedPageDto(
      items: docs,
      page: (pagination['page'] as num?)?.toInt() ?? 1,
      totalPages: (pagination['totalPages'] as num?)?.toInt() ?? 1,
      total: (pagination['total'] as num?)?.toInt() ?? 0,
      hasNext: pagination['hasNext'] as bool? ?? false,
    );
  }

  FeedPage toDomain() => FeedPage(
        items: items.map((i) => i.toDomain()).toList(),
        page: page,
        totalPages: totalPages,
        total: total,
        hasNext: hasNext,
      );
}
