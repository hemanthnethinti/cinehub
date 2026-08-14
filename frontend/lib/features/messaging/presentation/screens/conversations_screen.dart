import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';

import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart';
import 'package:cinehubapp/features/messaging/presentation/providers/messaging_providers.dart';
import 'package:cinehubapp/features/messaging/presentation/widgets/conversation_tile.dart';
import 'package:cinehubapp/features/messaging/presentation/widgets/empty_conversation_state.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final conversationsState = ref.watch(conversationsProvider);
    final authState = ref.watch(authNotifierProvider);
    final currentUserId = authState is AuthAuthenticated ? authState.user.id : '';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Messages', style: AppTypography.displaySmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_rounded),
            onPressed: () {
              context.push(Routes.newConversation);
            },
          ),
        ],
      ),
      body: conversationsState.when(
        data: (conversations) {
          if (conversations.isEmpty) {
            return EmptyConversationState(
              onNewChat: () => context.push(Routes.newConversation),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(conversationsProvider.notifier).refresh(),
            child: ListView.separated(
              itemCount: conversations.length,
              separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.border),
              itemBuilder: (context, index) {
                final conv = conversations[index];
                return ConversationTile(
                  conversation: conv,
                  currentUserId: currentUserId,
                  onTap: () {
                    context.push(Routes.chatPath(conv.id));
                  },
                );
              },
            ),
          );
        },
        loading: () => ListView.separated(
          itemCount: 8,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, __) => const ShimmerBox(width: double.infinity, height: 72),
        ),
        error: (error, stack) => ErrorStateWidget(
          message: error.toString(),
          onRetry: () => ref.read(conversationsProvider.notifier).refresh(),
        ),
      ),
    );
  }
}
