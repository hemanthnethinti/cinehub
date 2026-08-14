import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/search/domain/entities/search_entity.dart';
import 'package:cinehubapp/features/search/domain/repositories/search_repository.dart';

class GlobalSearchUseCase {
  const GlobalSearchUseCase(this._repository);
  final SearchRepository _repository;

  Future<Result<SearchResultEntity>> call(String query) async {
    if (query.trim().isNotEmpty) {
      await _repository.saveSearchQuery(query.trim());
    }
    return _repository.searchAll(query);
  }
}

class GetRecentSearchesUseCase {
  const GetRecentSearchesUseCase(this._repository);
  final SearchRepository _repository;

  Future<List<String>> call() => _repository.getRecentSearches();
}

class ClearRecentSearchesUseCase {
  const ClearRecentSearchesUseCase(this._repository);
  final SearchRepository _repository;

  Future<void> call() => _repository.clearRecentSearches();
}
