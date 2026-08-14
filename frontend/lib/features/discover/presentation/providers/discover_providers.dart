import 'package:cinehubapp/core/di/providers.dart';
import 'package:cinehubapp/features/discover/data/datasources/discover_remote_datasource.dart';
import 'package:cinehubapp/features/discover/data/repositories/discover_repository_impl.dart';
import 'package:cinehubapp/features/discover/domain/repositories/discover_repository.dart';
import 'package:cinehubapp/features/discover/domain/usecases/get_trending_usecase.dart';
import 'package:cinehubapp/features/discover/domain/usecases/search_projects_usecase.dart';
import 'package:cinehubapp/features/discover/presentation/providers/discover_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Dependencies ────────────────────────────────────────────────────────────

final discoverRemoteDataSourceProvider = Provider<DiscoverRemoteDataSource>((ref) {
  return DiscoverRemoteDataSource(ref.watch(apiClientProvider));
});

final discoverRepositoryProvider = Provider<DiscoverRepository>((ref) {
  return DiscoverRepositoryImpl(ref.watch(discoverRemoteDataSourceProvider));
});

final getTrendingUseCaseProvider = Provider<GetTrendingUseCase>((ref) {
  return GetTrendingUseCase(ref.watch(discoverRepositoryProvider));
});

final searchProjectsUseCaseProvider = Provider<SearchProjectsUseCase>((ref) {
  return SearchProjectsUseCase(ref.watch(discoverRepositoryProvider));
});

// ── State Providers ─────────────────────────────────────────────────────────

/// Holds the current search query string.
final discoverSearchQueryProvider = StateProvider<String>((ref) => '');

/// Manages the trending content state (initial view when not searching).
final trendingNotifierProvider = NotifierProvider<TrendingNotifier, TrendingState>(TrendingNotifier.new);

class TrendingNotifier extends Notifier<TrendingState> {
  @override
  TrendingState build() {
    Future.microtask(loadTrending);
    return const TrendingInitial();
  }

  Future<void> loadTrending() async {
    state = const TrendingLoading();
    final result = await ref.read(getTrendingUseCaseProvider).call();
    result.when(
      success: (content) => state = TrendingLoaded(content),
      failure: (error) => state = TrendingFailure(error: error),
    );
  }

  Future<void> refresh() async {
    final result = await ref.read(getTrendingUseCaseProvider).call();
    result.when(
      success: (content) => state = TrendingLoaded(content),
      failure: (error) {
        final current = state;
        state = TrendingFailure(
          error: error,
          previousContent: current is TrendingLoaded ? current.content : null,
        );
      },
    );
  }
}

/// Manages the search results state (when search is active).
final searchNotifierProvider = NotifierProvider<SearchNotifier, DiscoverSearchState>(SearchNotifier.new);

class SearchNotifier extends Notifier<DiscoverSearchState> {
  static const _limit = 20;
  int _currentPage = 1;

  @override
  DiscoverSearchState build() {
    // Listen to changes in the search query and debounce/trigger searches.
    ref.listen(discoverSearchQueryProvider, (previous, next) {
      if (next.trim().isNotEmpty) {
        search(next);
      } else {
        state = const SearchInitial();
      }
    });
    return const SearchInitial();
  }

  Future<void> search(String query) async {
    state = const SearchLoading();
    _currentPage = 1;
    
    final result = await ref.read(searchProjectsUseCaseProvider).call(
      query: query,
      page: _currentPage,
      limit: _limit,
    );

    result.when(
      success: (pageData) {
        state = SearchLoaded(
          items: pageData.items,
          hasMore: pageData.hasNext,
        );
      },
      failure: (error) => state = SearchFailure(error: error),
    );
  }

  Future<void> refresh() async {
    final query = ref.read(discoverSearchQueryProvider);
    if (query.trim().isEmpty) return;

    _currentPage = 1;
    final result = await ref.read(searchProjectsUseCaseProvider).call(
      query: query,
      page: _currentPage,
      limit: _limit,
    );

    result.when(
      success: (pageData) {
        state = SearchLoaded(
          items: pageData.items,
          hasMore: pageData.hasNext,
        );
      },
      failure: (error) {
        final current = state;
        state = SearchFailure(
          error: error,
          previousItems: current is SearchLoaded ? current.items : null,
        );
      },
    );
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! SearchLoaded || currentState.isLoadingMore || !currentState.hasMore) return;
    
    final query = ref.read(discoverSearchQueryProvider);
    if (query.trim().isEmpty) return;

    state = SearchLoaded(
      items: currentState.items,
      hasMore: currentState.hasMore,
      isLoadingMore: true,
    );

    _currentPage++;

    final result = await ref.read(searchProjectsUseCaseProvider).call(
      query: query,
      page: _currentPage,
      limit: _limit,
    );

    result.when(
      success: (pageData) {
        state = SearchLoaded(
          items: [...currentState.items, ...pageData.items],
          hasMore: pageData.hasNext,
          isLoadingMore: false,
        );
      },
      failure: (error) {
        state = SearchLoaded(
          items: currentState.items,
          hasMore: currentState.hasMore,
          isLoadingMore: false,
        );
      },
    );
  }
}
