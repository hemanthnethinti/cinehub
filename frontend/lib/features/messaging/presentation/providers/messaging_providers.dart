import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/di/providers.dart';
import 'package:cinehubapp/features/messaging/data/datasources/messaging_remote_datasource.dart';
import 'package:cinehubapp/features/messaging/data/repositories/messaging_repository_impl.dart';
import 'package:cinehubapp/features/messaging/domain/entities/conversation.dart';
import 'package:cinehubapp/features/messaging/domain/repositories/messaging_repository.dart';
import 'package:cinehubapp/features/messaging/domain/usecases/messaging_usecases.dart';

// ── Data & Domain ────────────────────────────────────────────────────────────

final messagingRemoteDataSourceProvider = Provider<MessagingRemoteDataSource>((ref) {
  return MessagingRemoteDataSource(ref.watch(apiClientProvider));
});

final messagingRepositoryProvider = Provider<MessagingRepository>((ref) {
  return MessagingRepositoryImpl(ref.watch(messagingRemoteDataSourceProvider));
});

final getConversationsUseCaseProvider = Provider<GetConversationsUseCase>((ref) {
  return GetConversationsUseCase(ref.watch(messagingRepositoryProvider));
});

final getMessagesUseCaseProvider = Provider<GetMessagesUseCase>((ref) {
  return GetMessagesUseCase(ref.watch(messagingRepositoryProvider));
});

final sendMessageUseCaseProvider = Provider<SendMessageUseCase>((ref) {
  return SendMessageUseCase(ref.watch(messagingRepositoryProvider));
});

final markAsReadUseCaseProvider = Provider<MarkAsReadUseCase>((ref) {
  return MarkAsReadUseCase(ref.watch(messagingRepositoryProvider));
});

// ── State ────────────────────────────────────────────────────────────────────

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final conversationsProvider = AsyncNotifierProvider.autoDispose<ConversationsNotifier, List<Conversation>>(
  ConversationsNotifier.new,
);

class ConversationsNotifier extends AutoDisposeAsyncNotifier<List<Conversation>> {
  @override
  Future<List<Conversation>> build() async {
    final result = await ref.watch(getConversationsUseCaseProvider).call();
    return result.when(
      success: (data) => data,
      failure: (error) => throw Exception(error.userMessage),
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    final result = await ref.read(getConversationsUseCaseProvider).call();
    state = result.when(
      success: (data) => AsyncData(data),
      failure: (error) => AsyncError(Exception(error.userMessage), StackTrace.current),
    );
  }
}

final chatProvider = AsyncNotifierProvider.autoDispose.family<ChatNotifier, List<Message>, String>(
  ChatNotifier.new,
);

class ChatNotifier extends AutoDisposeFamilyAsyncNotifier<List<Message>, String> {
  @override
  Future<List<Message>> build(String arg) async {
    final result = await ref.watch(getMessagesUseCaseProvider).call(conversationId: arg);
    return result.when(
      success: (data) => data,
      failure: (error) => throw Exception(error.userMessage),
    );
  }

  Future<void> sendMessage(String content, {String? mediaUrl}) async {
    final result = await ref.read(sendMessageUseCaseProvider).call(
      conversationId: arg,
      content: content,
      mediaUrl: mediaUrl,
    );
    
    result.when(
      success: (message) {
        if (state.hasValue) {
          state = AsyncData([message, ...state.value!]);
        }
      },
      failure: (error) {
        // Optimistic UI failure handling could go here.
      },
    );
  }

  Future<void> markAsRead() async {
    await ref.read(markAsReadUseCaseProvider).call(arg);
  }
}
