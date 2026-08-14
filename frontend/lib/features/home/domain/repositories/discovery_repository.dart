import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/home/domain/entities/feed_page.dart';

/// Repository interface for Discovery / Home Feed.
abstract interface class DiscoveryRepository {
  /// Fetches a paginated list of feed items.
  Future<Result<FeedPage>> getFeed({required int page, required int limit});
}
