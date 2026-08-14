import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/portfolio/domain/entities/portfolio_entity.dart';
import 'package:cinehubapp/shared/widgets/media/app_cached_image.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PortfolioCard extends StatelessWidget {
  const PortfolioCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  final PortfolioItemEntity item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 160,
              width: double.infinity,
              child: _buildCover(),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: AppTypography.labelLarge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.favorite_rounded, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(item.likeCount.toString(), style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                      const SizedBox(width: AppSpacing.sm),
                      const Icon(Icons.remove_red_eye_rounded, size: 14, color: AppColors.textTertiary),
                      const SizedBox(width: 4),
                      Text(item.viewCount.toString(), style: AppTypography.labelSmall.copyWith(color: AppColors.textTertiary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 400.ms).scale(begin: const Offset(0.95, 0.95), duration: 400.ms);
  }

  Widget _buildCover() {
    if (item.media.isEmpty) {
      return Container(
        color: AppColors.surfaceElevated,
        child: const Icon(Icons.image_not_supported_rounded, color: AppColors.textTertiary),
      );
    }
    final coverMedia = item.media.first;
    return AppCachedImage(
      imageUrl: coverMedia.thumbnail ?? coverMedia.url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
