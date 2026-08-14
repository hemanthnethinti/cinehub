
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/discover/domain/repositories/discover_repository.dart';
import 'package:cinehubapp/features/home/domain/entities/feed_page.dart';

class SearchProjectsUseCase {
  const SearchProjectsUseCase(this._repository);
  final DiscoverRepository _repository;

  Future<Result<FeedPage>> call({
    required String query,
    required int page,
    required int limit,
  }) {
    return _repository.searchProjects(query: query, page: page, limit: limit);
  }
}
