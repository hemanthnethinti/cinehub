import 'package:cinehubapp/core/network/api_client.dart';

class AiRemoteDataSource {
  const AiRemoteDataSource(this._client);
  final ApiClient _client;

  Future<Map<String, dynamic>> generate({
    required String module,
    required String task,
    required dynamic input,
    Map<String, dynamic>? options,
  }) async {
    final response = await _client.post('ai/generate', data: {
      'module': module,
      'task': task,
      'input': input,
      if (options != null) 'options': options,
    });
    final responseData = response.data ?? {};
    return responseData['data'] ?? {};
  }
}
