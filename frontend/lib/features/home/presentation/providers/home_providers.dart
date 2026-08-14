import 'package:cinehubapp/core/di/providers.dart';
import 'package:cinehubapp/features/home/data/datasources/discovery_remote_datasource.dart';
import 'package:cinehubapp/features/home/data/repositories/discovery_repository_impl.dart';
import 'package:cinehubapp/features/home/domain/repositories/discovery_repository.dart';
import 'package:cinehubapp/features/home/domain/usecases/get_feed_usecase.dart';
import 'package:cinehubapp/features/home/presentation/providers/home_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// ── Dependencies ────────────────────────────────────────────────────────────

final discoveryRemoteDataSourceProvider = Provider<DiscoveryRemoteDataSource>((ref) {
  return DiscoveryRemoteDataSource(ref.watch(apiClientProvider));
});

final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  return DiscoveryRepositoryImpl(ref.watch(discoveryRemoteDataSourceProvider));
});

final getFeedUseCaseProvider = Provider<GetFeedUseCase>((ref) {
  return GetFeedUseCase(ref.watch(discoveryRepositoryProvider));
});

// ── Notifier ────────────────────────────────────────────────────────────────

final homeNotifierProvider = NotifierProvider<HomeNotifier, HomeState>(HomeNotifier.new);

class HomeNotifier extends Notifier<HomeState> {
  static const _limit = 10;
  int _currentPage = 1;

  @override
  HomeState build() {
    Future.microtask(loadFeed);
    return const HomeInitial();
  }

  Future<void> loadFeed() async {
    state = const HomeLoading();
    _currentPage = 1;
    
    final result = await ref.read(getFeedUseCaseProvider).call(
      page: _currentPage,
      limit: _limit,
    );

    result.when(
      success: (pageData) {
        state = HomeLoaded(
          items: pageData.items,
          hasMore: pageData.hasNext,
        );
      },
      failure: (error) {
        state = HomeFailure(error: error);
      },
    );
  }

  Future<void> refreshFeed() async {
    _currentPage = 1;
    final result = await ref.read(getFeedUseCaseProvider).call(
      page: _currentPage,
      limit: _limit,
    );

    result.when(
      success: (pageData) {
        state = HomeLoaded(
          items: pageData.items,
          hasMore: pageData.hasNext,
        );
      },
      failure: (error) {
        // Keeps previous items if we fail while refreshing
        final current = state;
        state = HomeFailure(
          error: error,
          previousItems: current is HomeLoaded ? current.items : null,
        );
      },
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! HomeLoaded || currentState.isLoadingMore || !currentState.hasMore) return;

    state = HomeLoaded(
      items: currentState.items,
      hasMore: currentState.hasMore,
      isLoadingMore: true,
    );

    _currentPage++;

    final result = await ref.read(getFeedUseCaseProvider).call(
      page: _currentPage,
      limit: _limit,
    );

    result.when(
      success: (pageData) {
        state = HomeLoaded(
          items: [...currentState.items, ...pageData.items],
          hasMore: pageData.hasNext,
          isLoadingMore: false,
        );
      },
      failure: (error) {
        // Revert loading state and optionally show a toast in UI
        state = HomeLoaded(
          items: currentState.items,
          hasMore: currentState.hasMore,
          isLoadingMore: false,
        );
      },
    );
  }

  void toggleLike(String itemId) {
    // Currently UI only, as backend doesn't support project likes yet
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final items = currentState.items.map((item) {
      if (item.id == itemId) {
        final wasLiked = item.isLiked;
        return item.copyWith(
          isLiked: !wasLiked,
          likeCount: item.likeCount + (wasLiked ? -1 : 1),
        );
      }
      return item;
    }).toList();

    state = HomeLoaded(
      items: items,
      hasMore: currentState.hasMore,
      isLoadingMore: currentState.isLoadingMore,
    );
  }

  void toggleBookmark(String itemId) {
    // Currently UI only, as backend doesn't support project bookmarks yet
    final currentState = state;
    if (currentState is! HomeLoaded) return;

    final items = currentState.items.map((item) {
      if (item.id == itemId) {
        return item.copyWith(isBookmarked: !item.isBookmarked);
      }
      return item;
    }).toList();

    state = HomeLoaded(
      items: items,
      hasMore: currentState.hasMore,
      isLoadingMore: currentState.isLoadingMore,
    );
  }
}
