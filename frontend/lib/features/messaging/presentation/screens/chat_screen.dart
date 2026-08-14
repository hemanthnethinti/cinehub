import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:cinehubapp/features/messaging/presentation/providers/messaging_providers.dart';
import 'package:cinehubapp/features/messaging/presentation/widgets/chat_app_bar.dart';
import 'package:cinehubapp/features/messaging/presentation/widgets/chat_loading_skeleton.dart';
import 'package:cinehubapp/features/messaging/presentation/widgets/date_separator.dart';
import 'package:cinehubapp/features/messaging/presentation/widgets/message_bubble.dart';
import 'package:cinehubapp/features/messaging/presentation/widgets/message_composer.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key, required this.conversationId});

  final String conversationId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    // Mark as read when opening
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chatProvider(widget.conversationId).notifier).markAsRead();
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider(widget.conversationId));
    final authState = ref.watch(authNotifierProvider);
    final currentUserId = authState is AuthAuthenticated ? authState.user.id : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: ChatAppBar(
        name: 'Chat', // Ideally fetched from conversation details
        isOnline: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: chatState.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(child: Text('Say hello!'));
                }
                return ListView.builder(
                  reverse: true, // Assuming newest messages are at index 0
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isMe = message.senderId == currentUserId;
                    
                    // Simple date separator logic
                    final showDate = index == messages.length - 1 || 
                        messages[index].createdAt.day != messages[index + 1].createdAt.day;

                    return Column(
                      children: [
                        if (showDate) DateSeparator(date: message.createdAt),
                        MessageBubble(
                          message: message,
                          isMe: isMe,
                          showAvatar: !isMe,
                        ),
                      ],
                    );
                  },
                );
              },
              loading: () => const ChatLoadingSkeleton(),
              error: (error, _) => ErrorStateWidget(
                message: error.toString(),
                onRetry: () => ref.refresh(chatProvider(widget.conversationId).future),
              ),
            ),
          ),
          MessageComposer(
            onSend: (text) {
              ref.read(chatProvider(widget.conversationId).notifier).sendMessage(text);
            },
            onAttach: () {
              // Attachment logic
            },
          ),
        ],
      ),
    );
  }
}
