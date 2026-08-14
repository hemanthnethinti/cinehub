import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:shimmer/shimmer.dart';

class AiLoadingSkeleton extends StatelessWidget {
  const AiLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceElevated,
      highlightColor: AppColors.surfaceElevated.withValues(alpha: 0.5),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 150, height: 20, color: Colors.white),
            const SizedBox(height: AppSpacing.md),
            Container(width: double.infinity, height: 14, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: double.infinity, height: 14, color: Colors.white),
            const SizedBox(height: 8),
            Container(width: 200, height: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
