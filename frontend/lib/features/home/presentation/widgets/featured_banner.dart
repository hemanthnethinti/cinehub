import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_decorations.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/shared/widgets/media/media_widgets.dart';

class FeaturedBanner extends StatelessWidget {
  const FeaturedBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: AppRadius.card,
          boxShadow: AppShadows.md,
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image
            const CachedImage(
              url: 'https://picsum.photos/seed/featured/800/400',
              fit: BoxFit.cover,
            ),
            
            // Gradient overlay
            Container(
              decoration: const BoxDecoration(
                gradient: AppGradients.scrimBottom,
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppRadius.sm,
                    ),
                    child: Text(
                      'FEATURED',
                      style: AppTypography.overline.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'The Future of Independent Cinema',
                    style: AppTypography.headlineLarge.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
