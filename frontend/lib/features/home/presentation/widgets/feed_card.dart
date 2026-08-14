import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/home/domain/entities/feed_item.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cinehubapp/features/home/presentation/providers/home_providers.dart';
import 'package:cinehubapp/shared/widgets/media/media_widgets.dart';
import 'package:cinehubapp/core/router/routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FeedCard extends ConsumerWidget {
  const FeedCard({super.key, required this.item});

  final FeedItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push(Routes.projectDetailPath(item.id)),
      child: Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar, Name, Type, Time
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (item.author.id != 'unknown') {
                  context.push(Routes.userProfilePath(item.author.id));
                }
              },
              child: Row(
                children: [
                CachedAvatar(
                  imageUrl: item.author.avatarUrl,
                  size: 40,
                  initials: item.author.firstName.substring(0, 1),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.author.firstName} ${item.author.lastName}',
                        style: AppTypography.labelLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${item.type} • ${_formatTimeAgo(item.createdAt)}',
                        style: AppTypography.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  color: AppColors.textSecondary,
                  onPressed: () {
                    // TODO: Show options menu
                  },
                ),
              ],
            ),
          ),
        ),
          
          // Image/Poster
          if (item.imageUrl != null)
            CachedImage(
              url: item.imageUrl!,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            
          // Title & Description
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: AppTypography.headlineMedium,
                ),
                if (item.description != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    item.description!,
                    style: AppTypography.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          
          const Divider(),
          
          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _ActionButton(
                      icon: item.isLiked 
                          ? Icons.favorite_rounded 
                          : Icons.favorite_border_rounded,
                      color: item.isLiked 
                          ? AppColors.error 
                          : AppColors.textSecondary,
                      label: item.likeCount.toString(),
                      onPressed: () {
                        ref.read(homeNotifierProvider.notifier).toggleLike(item.id);
                      },
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _ActionButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: item.commentCount.toString(),
                      onPressed: () {
                        // TODO: Open comments
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    _ActionButton(
                      icon: Icons.share_outlined,
                      onPressed: () {
                        // TODO: Share functionality
                      },
                    ),
                    _ActionButton(
                      icon: item.isBookmarked 
                          ? Icons.bookmark_rounded 
                          : Icons.bookmark_border_rounded,
                      color: item.isBookmarked 
                          ? AppColors.primary 
                          : AppColors.textSecondary,
                      onPressed: () {
                        ref.read(homeNotifierProvider.notifier).toggleBookmark(item.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    )).animate().fade(duration: 500.ms).slideY(begin: 0.1, duration: 500.ms);
  }

  String _formatTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m';
    return 'now';
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    this.label,
    required this.onPressed,
    this.color,
  });

  final IconData icon;
  final String? label;
  final VoidCallback onPressed;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final defaultColor = AppColors.textSecondary;
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: color ?? defaultColor,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        minimumSize: const Size(0, 36),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          if (label != null) ...[
            const SizedBox(width: AppSpacing.xs),
            Text(label!),
          ],
        ],
      ),
    );
  }
}
