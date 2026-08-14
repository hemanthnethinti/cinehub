import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:shimmer/shimmer.dart';

class SearchLoadingSkeleton extends StatelessWidget {
  const SearchLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: 10,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.surfaceElevated,
                highlightColor: AppColors.surfaceElevated.withValues(alpha: 0.5),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: AppColors.surfaceElevated,
                      highlightColor: AppColors.surfaceElevated.withValues(alpha: 0.5),
                      child: Container(height: 14, width: double.infinity, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: AppColors.surfaceElevated,
                      highlightColor: AppColors.surfaceElevated.withValues(alpha: 0.5),
                      child: Container(height: 12, width: 100, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
