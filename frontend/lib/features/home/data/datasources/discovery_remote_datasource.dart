import 'package:cinehubapp/core/network/api_client.dart';
import 'package:cinehubapp/features/home/data/models/project_feed_dto.dart';

/// Remote data source for Discovery / Home Feed.
class DiscoveryRemoteDataSource {
  const DiscoveryRemoteDataSource(this._client);
  final ApiClient _client;

  static const _base = 'discovery';

  Future<FeedPageDto> discoverProjects({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '$_base/projects',
      queryParameters: {
        'page': page,
        'limit': limit,
      },
    );
    return FeedPageDto.fromJson(response.data!);
  }
}
