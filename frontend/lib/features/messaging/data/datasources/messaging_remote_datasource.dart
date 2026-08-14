import 'package:cinehubapp/core/network/api_client.dart';
import 'package:cinehubapp/features/messaging/data/models/conversation_dto.dart';
import 'package:cinehubapp/features/profile/data/models/profile_dto.dart';

class MessagingRemoteDataSource {
  const MessagingRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<ConversationDto>> getConversations({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _client.get(
      'messaging/conversations',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = _extractList(response.data);
    return data
        .map((json) => ConversationDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<String> startConversation(String participantId) async {
    final response = await _client.post(
      'messaging/conversations',
      data: {'participantId': participantId},
    );
    final data = response.data?['data'] as Map<String, dynamic>? ?? const {};
    return data['id'] as String? ?? data['_id'] as String? ?? '';
  }

  Future<List<ProfileDto>> searchUsers(String query, {int limit = 20}) async {
    final response = await _client.get(
      'users',
      queryParameters: {'search': query, 'page': 1, 'limit': limit},
    );
    final data = _extractList(response.data);
    return data
        .map((json) => ProfileDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<List<MessageDto>> getMessages(
    String conversationId, {
    int page = 1,
    int limit = 50,
  }) async {
    final response = await _client.get(
      'messaging/conversations/$conversationId/messages',
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = _extractList(response.data);
    return data
        .map((json) => MessageDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<MessageDto> sendMessage(
    String conversationId,
    String content,
    String? mediaUrl,
  ) async {
    final response = await _client.post(
      'messaging/conversations/$conversationId/messages',
      data: {
        'content': content,
        if (mediaUrl != null) 'mediaUrl': mediaUrl,
      },
    );
    final data = response.data?['data'] as Map<String, dynamic>? ?? const {};
    return MessageDto.fromJson(data);
  }

  Future<void> markAsRead(String conversationId) async {
    await _client.patch('messaging/conversations/$conversationId/read');
  }

  /// Accept the standardized flat paginated envelope and the legacy nested
  /// `{ data: { results: [...] } }` shape for compatibility with old servers.
  List<dynamic> _extractList(dynamic body) {
    final data = body is Map ? body['data'] : null;
    if (data is List) return data;
    if (data is Map && data['results'] is List) {
      return data['results'] as List<dynamic>;
    }
    return const [];
  }
}
