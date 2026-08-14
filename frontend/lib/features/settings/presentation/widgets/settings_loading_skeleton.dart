import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:shimmer/shimmer.dart';

class SettingsLoadingSkeleton extends StatelessWidget {
  const SettingsLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      padding: const EdgeInsets.all(AppSpacing.md),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.surfaceElevated,
                highlightColor: AppColors.surfaceElevated.withValues(alpha: 0.5),
                child: Container(
                  width: 120,
                  height: 16,
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceElevated,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: List.generate(3, (i) => _buildItem()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Shimmer.fromColors(
        baseColor: AppColors.surfaceElevated,
        highlightColor: AppColors.surfaceElevated.withValues(alpha: 0.5),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Container(
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
