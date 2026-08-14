import 'package:cinehubapp/features/profile/domain/entities/profile.dart';

/// Represents a single item in the Home Feed.
/// 
/// This is a temporary entity for the presentation layer until the backend
/// provides a unified Feed API.
final class FeedItem {
  const FeedItem({
    required this.id,
    required this.author,
    required this.title,
    required this.type,
    this.imageUrl,
    this.description,
    this.likeCount = 0,
    this.commentCount = 0,
    this.isLiked = false,
    this.isBookmarked = false,
    required this.createdAt,
  });

  final String id;
  final Profile author;
  final String title;
  
  /// e.g., 'Project', 'Portfolio', 'Update'
  final String type;
  
  final String? imageUrl;
  final String? description;
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final bool isBookmarked;
  final DateTime createdAt;

  FeedItem copyWith({
    String? id,
    Profile? author,
    String? title,
    String? type,
    String? imageUrl,
    String? description,
    int? likeCount,
    int? commentCount,
    bool? isLiked,
    bool? isBookmarked,
    DateTime? createdAt,
  }) {
    return FeedItem(
      id: id ?? this.id,
      author: author ?? this.author,
      title: title ?? this.title,
      type: type ?? this.type,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isLiked: isLiked ?? this.isLiked,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeedItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
