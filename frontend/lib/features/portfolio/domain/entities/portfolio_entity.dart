class PortfolioItemEntity {
  const PortfolioItemEntity({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.category,
    required this.tags,
    required this.media,
    required this.likeCount,
    required this.viewCount,
    required this.isPublished,
    required this.createdAt,
    this.ownerName,
    this.ownerAvatar,
  });

  final String id;
  final String ownerId;
  final String title;
  final String description;
  final String category;
  final List<String> tags;
  final List<PortfolioMediaEntity> media;
  final int likeCount;
  final int viewCount;
  final bool isPublished;
  final DateTime createdAt;
  
  // Populated fields
  final String? ownerName;
  final String? ownerAvatar;
}

class PortfolioMediaEntity {
  const PortfolioMediaEntity({
    required this.url,
    required this.type,
    this.thumbnail,
  });

  final String url;
  final String type; // e.g. 'image' or 'video'
  final String? thumbnail;
}
