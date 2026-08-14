import 'package:cinehubapp/core/network/api_client.dart';

class SearchRemoteDataSource {
  const SearchRemoteDataSource(this._client);
  final ApiClient _client;

  Future<Map<String, dynamic>> searchUsers(String query, {int page = 1, int limit = 20}) async {
    final response = await _client.get('discovery/creators', queryParameters: {
      'search': query,
      'page': page,
      'limit': limit,
    });
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> searchProjects(String query, {int page = 1, int limit = 20}) async {
    final response = await _client.get('projects', queryParameters: {
      'search': query,
      'page': page,
      'limit': limit,
    });
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> searchPortfolios(String query, {int page = 1, int limit = 20}) async {
    // Note: The backend featured endpoint doesn't support search yet, but we will pass it
    final response = await _client.get('portfolios/featured', queryParameters: {
      'search': query,
      'page': page,
      'limit': limit,
    });
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> searchTeams(String query, {int page = 1, int limit = 20}) async {
    // Backend has no global teams search endpoint yet
    return {
      'data': [],
      'meta': {
        'pagination': {
          'page': page,
          'limit': limit,
          'totalPages': 0,
          'total': 0,
          'hasNext': false,
        },
      },
    };
  }
}
