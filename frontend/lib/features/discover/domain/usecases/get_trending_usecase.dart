
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/discover/domain/entities/trending_content.dart';
import 'package:cinehubapp/features/discover/domain/repositories/discover_repository.dart';

class GetTrendingUseCase {
  const GetTrendingUseCase(this._repository);
  final DiscoverRepository _repository;

  Future<Result<TrendingContent>> call() {
    return _repository.getTrendingContent();
  }
}
