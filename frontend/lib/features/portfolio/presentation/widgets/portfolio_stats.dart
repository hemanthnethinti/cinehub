import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/portfolio/domain/entities/portfolio_entity.dart';

class PortfolioStats extends StatelessWidget {
  const PortfolioStats({
    super.key,
    required this.item,
  });

  final PortfolioItemEntity item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStat(Icons.favorite_rounded, item.likeCount.toString(), 'Likes'),
        _buildStat(Icons.remove_red_eye_rounded, item.viewCount.toString(), 'Views'),
        _buildStat(Icons.chat_bubble_rounded, '0', 'Comments'), // Assumed 0 if not fetched
      ],
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primaryLight, size: 28),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: AppTypography.bodyLarge),
        Text(label, style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
      ],
    );
  }
}
