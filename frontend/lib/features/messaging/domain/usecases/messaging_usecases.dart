import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/messaging/domain/entities/conversation.dart';
import 'package:cinehubapp/features/messaging/domain/repositories/messaging_repository.dart';

class GetConversationsUseCase {
  const GetConversationsUseCase(this._repository);
  final MessagingRepository _repository;

  Future<Result<List<Conversation>>> call({int page = 1, int limit = 20}) {
    return _repository.getConversations(page: page, limit: limit);
  }
}

class GetMessagesUseCase {
  const GetMessagesUseCase(this._repository);
  final MessagingRepository _repository;

  Future<Result<List<Message>>> call({
    required String conversationId,
    int page = 1,
    int limit = 50,
  }) {
    return _repository.getMessages(conversationId: conversationId, page: page, limit: limit);
  }
}

class SendMessageUseCase {
  const SendMessageUseCase(this._repository);
  final MessagingRepository _repository;

  Future<Result<Message>> call({
    required String conversationId,
    required String content,
    String? mediaUrl,
  }) {
    return _repository.sendMessage(
      conversationId: conversationId,
      content: content,
      mediaUrl: mediaUrl,
    );
  }
}

class MarkAsReadUseCase {
  const MarkAsReadUseCase(this._repository);
  final MessagingRepository _repository;

  Future<Result<void>> call(String conversationId) {
    return _repository.markAsRead(conversationId);
  }
}
