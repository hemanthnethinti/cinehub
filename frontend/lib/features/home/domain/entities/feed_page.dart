import 'package:cinehubapp/features/home/domain/entities/feed_item.dart';

/// Represents a paginated page of feed items.
final class FeedPage {
  const FeedPage({
    required this.items,
    required this.page,
    required this.totalPages,
    required this.total,
    required this.hasNext,
  });

  final List<FeedItem> items;
  final int page;
  final int totalPages;
  final int total;
  final bool hasNext;
}
