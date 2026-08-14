import 'package:cinehubapp/core/network/api_client.dart';

class PortfolioRemoteDataSource {
  const PortfolioRemoteDataSource(this._client);
  final ApiClient _client;

  static const _base = 'portfolios';

  Future<Map<String, dynamic>> getFeatured({int page = 1, int limit = 20}) async {
    final response = await _client.get('$_base/featured', queryParameters: {
      'page': page,
      'limit': limit,
    });
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> getTrending({int limit = 20}) async {
    final response = await _client.get('$_base/trending', queryParameters: {
      'limit': limit,
    });
    // Trending returns an array directly under data according to ApiResponse.ok(items)
    return {'data': response.data?['data'] ?? []};
  }

  Future<Map<String, dynamic>> getByOwner(String ownerId, {int page = 1, int limit = 20}) async {
    final response = await _client.get('$_base/user/$ownerId', queryParameters: {
      'page': page,
      'limit': limit,
    });
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> getMyPortfolio({int page = 1, int limit = 20}) async {
    final response = await _client.get('$_base/me', queryParameters: {
      'page': page,
      'limit': limit,
    });
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> getById(String id) async {
    final response = await _client.get('$_base/$id');
    return response.data?['data'] as Map<String, dynamic>? ?? {};
  }

  Future<Map<String, dynamic>> create(Map<String, dynamic> data) async {
    final response = await _client.post(_base, data: data);
    return response.data?['data'] as Map<String, dynamic>? ?? {};
  }

  Future<Map<String, dynamic>> update(String id, Map<String, dynamic> data) async {
    final response = await _client.patch('$_base/$id', data: data);
    return response.data?['data'] as Map<String, dynamic>? ?? {};
  }

  Future<void> delete(String id) async {
    await _client.delete('$_base/$id');
  }

  Future<Map<String, dynamic>> toggleLike(String id) async {
    final response = await _client.post('$_base/$id/like');
    return response.data?['data'] as Map<String, dynamic>? ?? {};
  }
}
