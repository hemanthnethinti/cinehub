import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/shared/widgets/media/media_widgets.dart';

class ChatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ChatAppBar({
    super.key,
    required this.name,
    this.avatarUrl,
    this.isOnline = false,
    this.onInfoTap,
  });

  final String name;
  final String? avatarUrl;
  final bool isOnline;
  final VoidCallback? onInfoTap;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      titleSpacing: 0,
      title: Row(
        children: [
          CachedAvatar(
            imageUrl: avatarUrl,
            size: 36,
            isOnline: isOnline,
            showOnlineBadge: isOnline,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTypography.headlineSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isOnline ? 'Online' : 'Offline',
                  style: AppTypography.labelSmall.copyWith(
                    color: isOnline ? AppColors.online : AppColors.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        if (onInfoTap != null)
          IconButton(
            icon: const Icon(Icons.info_outline_rounded),
            onPressed: onInfoTap,
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
