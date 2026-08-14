import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/features/home/domain/entities/feed_item.dart';

/// All possible states for the home feed feature.
sealed class HomeState {
  const HomeState();
}

/// Initial state — no feed has been requested yet.
final class HomeInitial extends HomeState {
  const HomeInitial();
}

/// Full-screen load — feed is being fetched for the first time.
final class HomeLoading extends HomeState {
  const HomeLoading();
}

/// Feed is loaded and ready to display.
final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.items,
    this.hasMore = true,
    this.isLoadingMore = false,
  });

  final List<FeedItem> items;
  final bool hasMore;
  final bool isLoadingMore;
}

/// An operation failed.
final class HomeFailure extends HomeState {
  const HomeFailure({required this.error, this.previousItems});
  
  final AppError error;
  final List<FeedItem>? previousItems;
}
