import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';

/// Displays a row of profile statistics: Followers, Following, Projects.
///
/// Tapping on a stat can trigger navigation (e.g., to the followers list).
class ProfileStats extends StatelessWidget {
  const ProfileStats({
    super.key,
    required this.followerCount,
    required this.followingCount,
    required this.projectCount,
    this.onFollowersTap,
    this.onFollowingTap,
    this.onProjectsTap,
  });

  final int followerCount;
  final int followingCount;
  final int projectCount;

  final VoidCallback? onFollowersTap;
  final VoidCallback? onFollowingTap;
  final VoidCallback? onProjectsTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _StatItem(
            label: 'Followers',
            value: followerCount,
            onTap: onFollowersTap,
          ),
          _StatDivider(),
          _StatItem(
            label: 'Following',
            value: followingCount,
            onTap: onFollowingTap,
          ),
          _StatDivider(),
          _StatItem(
            label: 'Projects',
            value: projectCount,
            onTap: onProjectsTap,
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    this.onTap,
  });

  final String label;
  final int value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _formatCount(value),
            style: AppTypography.headlineMedium,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    }
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 24,
      color: AppColors.border,
    );
  }
}
