import 'package:cinehubapp/core/error/app_error.dart';
import 'package:cinehubapp/core/result/result.dart';
import 'package:cinehubapp/features/messaging/data/datasources/messaging_remote_datasource.dart';
import 'package:cinehubapp/features/messaging/domain/entities/conversation.dart';
import 'package:cinehubapp/features/messaging/domain/repositories/messaging_repository.dart';

class MessagingRepositoryImpl implements MessagingRepository {
  const MessagingRepositoryImpl(this._remote);
  final MessagingRemoteDataSource _remote;

  @override
  Future<Result<List<Conversation>>> getConversations({int page = 1, int limit = 20}) async {
    try {
      final dtos = await _remote.getConversations(page: page, limit: limit);
      return Result.success(dtos.map((e) => e.toDomain()).toList());
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<List<Message>>> getMessages({
    required String conversationId,
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final dtos = await _remote.getMessages(conversationId, page: page, limit: limit);
      return Result.success(dtos.map((e) => e.toDomain()).toList());
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<Message>> sendMessage({
    required String conversationId,
    required String content,
    String? mediaUrl,
  }) async {
    try {
      final dto = await _remote.sendMessage(conversationId, content, mediaUrl);
      return Result.success(dto.toDomain());
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }

  @override
  Future<Result<void>> markAsRead(String conversationId) async {
    try {
      await _remote.markAsRead(conversationId);
      return Result.success(null);
    } on UnimplementedError catch (e) {
      return Result.failure(AppError.unknown(message: e.message ?? 'Unimplemented'));
    } catch (e) {
      return Result.failure(AppError.unknown(message: e.toString()));
    }
  }
}
