import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/features/discover/domain/entities/trending_content.dart';
import 'package:cinehubapp/features/home/domain/entities/feed_item.dart';

// ── Trending State ─────────────────────────────────────────────────────────

sealed class TrendingState {
  const TrendingState();
}

final class TrendingInitial extends TrendingState { const TrendingInitial(); }
final class TrendingLoading extends TrendingState { const TrendingLoading(); }
final class TrendingLoaded extends TrendingState {
  const TrendingLoaded(this.content);
  final TrendingContent content;
}
final class TrendingFailure extends TrendingState {
  const TrendingFailure({required this.error, this.previousContent});
  final AppError error;
  final TrendingContent? previousContent;
}

// ── Search State ────────────────────────────────────────────────────────────

sealed class DiscoverSearchState {
  const DiscoverSearchState();
}

final class SearchInitial extends DiscoverSearchState { const SearchInitial(); }
final class SearchLoading extends DiscoverSearchState { const SearchLoading(); }
final class SearchLoaded extends DiscoverSearchState {
  const SearchLoaded({
    required this.items,
    this.hasMore = true,
    this.isLoadingMore = false,
  });
  final List<FeedItem> items;
  final bool hasMore;
  final bool isLoadingMore;
}
final class SearchFailure extends DiscoverSearchState {
  const SearchFailure({required this.error, this.previousItems});
  final AppError error;
  final List<FeedItem>? previousItems;
}
