import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/messaging/domain/entities/conversation.dart';
import 'package:cinehubapp/shared/widgets/media/media_widgets.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    this.showAvatar = false,
    this.avatarUrl,
  });

  final Message message;
  final bool isMe;
  final bool showAvatar;
  final String? avatarUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.sm),
              child: showAvatar
                  ? CachedAvatar(imageUrl: avatarUrl, size: 28)
                  : const SizedBox(width: 28),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? AppColors.primary : AppColors.surfaceElevated,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe || !showAvatar ? 16 : 4),
                  bottomRight: Radius.circular(!isMe ? 16 : 4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (message.mediaUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                      child: ClipRRect(
                        borderRadius: AppRadius.sm,
                        child: CachedImage(
                          url: message.mediaUrl!,
                          width: 200,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  if (message.content.isNotEmpty)
                    Text(
                      message.content,
                      style: AppTypography.bodyMedium.copyWith(
                        color: isMe ? AppColors.primaryLight : AppColors.textPrimary,
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isMe)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: _buildStatusIcon(),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (message.status) {
      case MessageStatus.sending:
        return const Icon(Icons.access_time, size: 12, color: AppColors.textTertiary);
      case MessageStatus.sent:
        return const Icon(Icons.check, size: 14, color: AppColors.textSecondary);
      case MessageStatus.delivered:
        return const Icon(Icons.done_all, size: 14, color: AppColors.textSecondary);
      case MessageStatus.read:
        return const Icon(Icons.done_all, size: 14, color: AppColors.primary);
      case MessageStatus.error:
        return const Icon(Icons.error_outline, size: 14, color: AppColors.error);
    }
  }
}
