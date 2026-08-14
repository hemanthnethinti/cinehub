import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/notifications/domain/entities/notification_entity.dart';
import 'package:cinehubapp/shared/widgets/media/media_widgets.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
    required this.onMarkRead,
  });

  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback onMarkRead;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        color: AppColors.error,
        child: const Icon(Icons.delete_outline, color: AppColors.textPrimary),
      ),
      child: InkWell(
        onTap: () {
          if (!notification.isRead) {
            onMarkRead();
          }
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: notification.isRead ? AppColors.background : AppColors.surfaceElevated.withValues(alpha: 0.5),
            border: const Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAvatar(),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: AppTypography.labelLarge.copyWith(
                              fontWeight: notification.isRead ? FontWeight.normal : FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          _formatDate(notification.createdAt),
                          style: AppTypography.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification.message,
                      style: AppTypography.bodyMedium.copyWith(
                        color: notification.isRead ? AppColors.textSecondary : AppColors.textPrimary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Container(
                  margin: const EdgeInsets.only(left: AppSpacing.md, top: AppSpacing.sm),
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    if (notification.sender != null) {
      return CachedAvatar(imageUrl: notification.sender!.avatarUrl, size: 48);
    }
    
    IconData icon;
    Color color;

    switch (notification.type) {
      case NotificationType.mention:
        icon = Icons.alternate_email_rounded;
        color = AppColors.info;
        break;
      case NotificationType.project:
        icon = Icons.movie_creation_rounded;
        color = AppColors.primary;
        break;
      case NotificationType.message:
        icon = Icons.chat_bubble_rounded;
        color = AppColors.success;
        break;
      case NotificationType.teamInvite:
        icon = Icons.group_add_rounded;
        color = AppColors.warning;
        break;
      case NotificationType.system:
      default:
        icon = Icons.notifications_rounded;
        color = AppColors.textSecondary;
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.full,
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  String _formatDate(DateTime d) {
    final now = DateTime.now();
    final diff = now.difference(d);
    
    if (diff.inDays == 0) {
      if (diff.inHours == 0) {
        if (diff.inMinutes == 0) return 'Just now';
        return '${diff.inMinutes}m';
      }
      return '${diff.inHours}h';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d';
    } else {
      return DateFormat('MMM d').format(d);
    }
  }
}
