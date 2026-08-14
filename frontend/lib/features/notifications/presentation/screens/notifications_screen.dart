import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/notifications/domain/entities/notification_entity.dart';
import 'package:cinehubapp/features/notifications/presentation/providers/notification_providers.dart';
import 'package:cinehubapp/features/notifications/presentation/widgets/empty_notifications_state.dart';
import 'package:cinehubapp/features/notifications/presentation/widgets/notification_filter_bar.dart';
import 'package:cinehubapp/features/notifications/presentation/widgets/notification_loading_skeleton.dart';
import 'package:cinehubapp/features/notifications/presentation/widgets/notification_tile.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsState = ref.watch(notificationsProvider);
    final selectedFilter = ref.watch(notificationFilterProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Notifications', style: AppTypography.displaySmall),
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded),
            tooltip: 'Mark all as read',
            onPressed: () {
              ref.read(notificationsProvider.notifier).markAllAsRead();
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: NotificationFilterBar(
            selectedFilter: selectedFilter,
            onFilterSelected: (filter) {
              ref.read(notificationFilterProvider.notifier).state = filter;
              // Wait for state to update, then refresh
              WidgetsBinding.instance.addPostFrameCallback((_) {
                ref.read(notificationsProvider.notifier).refresh();
              });
            },
          ),
        ),
      ),
      body: notificationsState.when(
        data: (notifications) {
          if (notifications.isEmpty) {
            return const EmptyNotificationsState();
          }

          return RefreshIndicator(
            onRefresh: () => ref.read(notificationsProvider.notifier).refresh(),
            child: ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return NotificationTile(
                  notification: notification,
                  onTap: () => _handleNavigation(context, notification),
                  onDelete: () => ref.read(notificationsProvider.notifier).deleteNotification(notification.id),
                  onMarkRead: () => ref.read(notificationsProvider.notifier).markAsRead(notification.id),
                );
              },
            ),
          );
        },
        loading: () => const NotificationLoadingSkeleton(),
        error: (error, _) => ErrorStateWidget( // from feedback_widgets ideally
          message: error.toString(),
          onRetry: () => ref.read(notificationsProvider.notifier).refresh(),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, NotificationEntity notification) {
    // Example deep-linking based on type
    if (notification.actionUrl != null && notification.actionUrl!.isNotEmpty) {
      context.push(notification.actionUrl!);
      return;
    }

    switch (notification.type) {
      case NotificationType.project:
        // context.pushNamed(Routes.projectDetail, pathParameters: {'id': notification.data['projectId']});
        break;
      case NotificationType.message:
        // context.pushNamed(Routes.chat, pathParameters: {'id': notification.data['conversationId']});
        break;
      case NotificationType.mention:
        if (notification.sender != null) {
          context.push(Routes.userProfilePath(notification.sender!.id));
        }
        break;
      default:
        break;
    }
  }
}
