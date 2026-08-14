import 'package:cinehubapp/core/network/api_client.dart';
import 'package:cinehubapp/features/discover/data/models/trending_content_dto.dart';
import 'package:cinehubapp/features/home/data/models/project_feed_dto.dart';
import 'package:cinehubapp/features/profile/data/models/profile_dto.dart';

/// Remote data source for Discover feature.
class DiscoverRemoteDataSource {
  const DiscoverRemoteDataSource(this._client);
  final ApiClient _client;

  static const _base = 'discovery';

  Future<TrendingContentDto> getTrendingContent() async {
    final response = await _client.get<Map<String, dynamic>>('$_base/trending');
    
    // Check if the response contains the 'data' wrapper and extract it
    final data = response.data?['data'] as Map<String, dynamic>? ?? response.data ?? {};
    return TrendingContentDto.fromJson(data);
  }

  Future<FeedPageDto> searchProjects({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      'projects',
      queryParameters: {
        'search': query,
        'page': page,
        'limit': limit,
      },
    );
    return FeedPageDto.fromJson(response.data!);
  }

  Future<ProfilePageDto> searchCreators({
    required String query,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '$_base/creators',
      queryParameters: {
        'search': query,
        'page': page,
        'limit': limit,
      },
    );
    return ProfilePageDto.fromJson(response.data!);
  }
}
