import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/home/domain/entities/feed_page.dart';
import 'package:cinehubapp/features/home/domain/repositories/discovery_repository.dart';

class GetFeedUseCase {
  const GetFeedUseCase(this._repository);
  final DiscoveryRepository _repository;

  Future<Result<FeedPage>> call({required int page, required int limit}) {
    return _repository.getFeed(page: page, limit: limit);
  }
}
