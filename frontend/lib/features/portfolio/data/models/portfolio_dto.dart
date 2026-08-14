import 'package:cinehubapp/features/portfolio/domain/entities/portfolio_entity.dart';
import 'package:cinehubapp/core/utils/url_resolver.dart';

class PortfolioDto {
  const PortfolioDto({
    required this.id,
    required this.ownerId,
    this.ownerName,
    this.ownerAvatar,
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
    required this.media,
    required this.likeCount,
    required this.viewCount,
    required this.isPublished,
    required this.createdAt,
  });

  final String id;
  final String ownerId;
  final String? ownerName;
  final String? ownerAvatar;
  final String title;
  final String description;
  final String category;
  final List<String> tags;
  final List<PortfolioMediaDto> media;
  final int likeCount;
  final int viewCount;
  final bool isPublished;
  final DateTime createdAt;

  factory PortfolioDto.fromJson(Map<String, dynamic> json) {
    final owner = json['owner'];
    String ownerId = '';
    String? ownerName;
    String? ownerAvatar;

    if (owner is Map<String, dynamic>) {
      ownerId = owner['_id']?.toString() ?? owner['id']?.toString() ?? '';
      ownerName = owner['displayName']?.toString() ?? owner['firstName']?.toString();
      ownerAvatar = UrlResolver.resolve(owner['avatar']?.toString());
    } else if (owner != null) {
      ownerId = owner.toString();
    }

    return PortfolioDto(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      ownerId: ownerId,
      ownerName: ownerName,
      ownerAvatar: ownerAvatar,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      media: (json['media'] as List<dynamic>?)
              ?.map((e) => PortfolioMediaDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      likeCount: json['likeCount'] as int? ?? 0,
      viewCount: json['viewCount'] as int? ?? 0,
      isPublished: json['isPublished'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  PortfolioItemEntity toDomain() {
    return PortfolioItemEntity(
      id: id,
      ownerId: ownerId,
      ownerName: ownerName,
      ownerAvatar: ownerAvatar,
      title: title,
      description: description,
      category: category,
      tags: tags,
      media: media.map((e) => e.toDomain()).toList(),
      likeCount: likeCount,
      viewCount: viewCount,
      isPublished: isPublished,
      createdAt: createdAt,
    );
  }
}

class PortfolioMediaDto {
  const PortfolioMediaDto({
    required this.url,
    required this.type,
    this.thumbnail,
  });

  final String url;
  final String type;
  final String? thumbnail;

  factory PortfolioMediaDto.fromJson(Map<String, dynamic> json) {
    return PortfolioMediaDto(
      url: UrlResolver.resolveRequired(json['url']?.toString() ?? ''),
      type: json['type']?.toString() ?? 'image',
      thumbnail: UrlResolver.resolve(json['thumbnail']?.toString()),
    );
  }

  PortfolioMediaEntity toDomain() {
    return PortfolioMediaEntity(
      url: url,
      type: type,
      thumbnail: thumbnail,
    );
  }
}
