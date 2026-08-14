import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/messaging/domain/entities/conversation.dart';

abstract interface class MessagingRepository {
  Future<Result<List<Conversation>>> getConversations({int page = 1, int limit = 20});
  
  Future<Result<List<Message>>> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 50,
  });

  Future<Result<Message>> sendMessage({
    required String conversationId,
    required String content,
    String? mediaUrl,
  });

  Future<Result<void>> markAsRead(String conversationId);
}
