import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/search/domain/entities/search_entity.dart';

abstract interface class SearchRepository {
  Future<Result<SearchResultEntity>> searchAll(String query);
  
  // Storage for recent searches
  Future<List<String>> getRecentSearches();
  Future<void> saveSearchQuery(String query);
  Future<void> clearRecentSearches();
}
