import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/di/providers.dart';
import 'package:cinehubapp/features/search/data/datasources/search_remote_datasource.dart';
import 'package:cinehubapp/features/search/data/repositories/search_repository_impl.dart';
import 'package:cinehubapp/features/search/domain/entities/search_entity.dart';
import 'package:cinehubapp/features/search/domain/repositories/search_repository.dart';
import 'package:cinehubapp/features/search/domain/usecases/search_usecases.dart';

// ── Data & Domain ────────────────────────────────────────────────────────────

final searchRemoteDataSourceProvider = Provider<SearchRemoteDataSource>((ref) {
  return SearchRemoteDataSource(ref.watch(apiClientProvider));
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(
    ref.watch(searchRemoteDataSourceProvider),
    ref.watch(sharedPreferencesProvider), // Must be initialized in main
  );
});

final globalSearchUseCaseProvider = Provider<GlobalSearchUseCase>((ref) {
  return GlobalSearchUseCase(ref.watch(searchRepositoryProvider));
});

final getRecentSearchesUseCaseProvider = Provider<GetRecentSearchesUseCase>((ref) {
  return GetRecentSearchesUseCase(ref.watch(searchRepositoryProvider));
});

final clearRecentSearchesUseCaseProvider = Provider<ClearRecentSearchesUseCase>((ref) {
  return ClearRecentSearchesUseCase(ref.watch(searchRepositoryProvider));
});

// ── State ────────────────────────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider.autoDispose.family<SearchResultEntity, String>((ref, query) async {
  if (query.isEmpty) return const SearchResultEntity();
  
  final result = await ref.read(globalSearchUseCaseProvider).call(query);
  return result.when(
    success: (data) => data,
    failure: (error) => throw Exception(error.userMessage),
  );
});

final recentSearchesProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  return ref.read(getRecentSearchesUseCaseProvider).call();
});
