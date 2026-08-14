import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/search/data/datasources/search_remote_datasource.dart';
import 'package:cinehubapp/features/search/domain/entities/search_entity.dart';
import 'package:cinehubapp/features/search/domain/repositories/search_repository.dart';

import 'package:cinehubapp/features/profile/data/models/profile_dto.dart';
import 'package:cinehubapp/features/projects/data/models/project_dto.dart';
import 'package:cinehubapp/features/portfolio/data/models/portfolio_dto.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(this._remote, this._prefs);
  
  final SearchRemoteDataSource _remote;
  final SharedPreferences _prefs;
  static const _recentSearchesKey = 'recent_searches';

  @override
  Future<Result<SearchResultEntity>> searchAll(String query) async {
    try {
      final futures = await Future.wait([
        _remote.searchUsers(query, limit: 10),
        _remote.searchProjects(query, limit: 10),
        _remote.searchPortfolios(query, limit: 10),
      ]);

      final usersData = futures[0]['data'] as List<dynamic>? ?? [];
      final projectsData = futures[1]['data'] as List<dynamic>? ?? [];
      final portfoliosData = futures[2]['data'] as List<dynamic>? ?? [];

      final users = usersData.map((e) => ProfileDto.fromJson(e).toDomain()).toList();
      final projects = projectsData.map((e) => ProjectDto.fromJson(e).toDomain()).toList();
      final portfolios = portfoliosData.map((e) => PortfolioDto.fromJson(e).toDomain()).toList();

      return Result.success(SearchResultEntity(
        users: users,
        projects: projects,
        portfolios: portfolios,
      ));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<List<String>> getRecentSearches() async {
    return _prefs.getStringList(_recentSearchesKey) ?? [];
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    final searches = _prefs.getStringList(_recentSearchesKey) ?? [];
    searches.remove(query);
    searches.insert(0, query);
    if (searches.length > 10) {
      searches.removeLast();
    }
    await _prefs.setStringList(_recentSearchesKey, searches);
  }

  @override
  Future<void> clearRecentSearches() async {
    await _prefs.remove(_recentSearchesKey);
  }
}
