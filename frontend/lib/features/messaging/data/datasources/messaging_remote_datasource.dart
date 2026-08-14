import 'package:cinehubapp/core/network/api_client.dart';
import 'package:cinehubapp/features/messaging/data/models/conversation_dto.dart';

class MessagingRemoteDataSource {
  const MessagingRemoteDataSource(this._client);
  
  // ignore: unused_field
  final ApiClient _client;

  Future<List<ConversationDto>> getConversations({int page = 1, int limit = 20}) async {
    final response = await _client.get('messaging/conversations', queryParameters: {
      'page': page,
      'limit': limit,
    });
    final data = response.data?['data']?['results'] as List? ?? [];
    return data.map((json) => ConversationDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<MessageDto>> getMessages(String conversationId, {int page = 1, int limit = 50}) async {
    final response = await _client.get('messaging/conversations/$conversationId/messages', queryParameters: {
      'page': page,
      'limit': limit,
    });
    final data = response.data?['data']?['results'] as List? ?? [];
    return data.map((json) => MessageDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<MessageDto> sendMessage(String conversationId, String content, String? mediaUrl) async {
    final response = await _client.post('messaging/conversations/$conversationId/messages', data: {
      'content': content,
      if (mediaUrl != null) 'mediaUrl': mediaUrl,
    });
    final data = response.data?['data'] as Map<String, dynamic>? ?? {};
    return MessageDto.fromJson(data);
  }

  Future<void> markAsRead(String conversationId) async {
    await _client.patch('messaging/conversations/$conversationId/read');
  }
}
