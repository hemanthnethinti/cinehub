
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/discover/domain/entities/trending_content.dart';
import 'package:cinehubapp/features/home/domain/entities/feed_page.dart';
import 'package:cinehubapp/features/profile/domain/entities/profile_page.dart';

abstract interface class DiscoverRepository {
  Future<Result<TrendingContent>> getTrendingContent();
  
  Future<Result<FeedPage>> searchProjects({
    required String query,
    required int page,
    required int limit,
  });

  Future<Result<ProfilePage>> searchCreators({
    required String query,
    required int page,
    required int limit,
  });
}
