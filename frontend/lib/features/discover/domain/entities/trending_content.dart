import 'package:cinehubapp/features/home/domain/entities/feed_item.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile.dart';

/// Represents trending content (creators, projects, portfolios).
final class TrendingContent {
  const TrendingContent({
    required this.creators,
    required this.projects,
    required this.portfolios,
  });

  final List<Profile> creators;
  final List<FeedItem> projects;
  final List<FeedItem> portfolios;
}
