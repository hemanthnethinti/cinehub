import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';

class ProjectLoadingSkeleton extends StatelessWidget {
  const ProjectLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      itemCount: 4,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xl),
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: AppRadius.card,
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ShimmerBox(width: double.infinity, height: 160, borderRadius: BorderRadius.zero),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        ShimmerBox(width: 80, height: 24),
                        SizedBox(width: AppSpacing.sm),
                        ShimmerBox(width: 60, height: 24),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const ShimmerBox(width: 200, height: 24),
                    const SizedBox(height: AppSpacing.xs),
                    const ShimmerBox(width: double.infinity, height: 16),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: const [
                        ShimmerBox(width: 24, height: 24, borderRadius: AppRadius.full),
                        SizedBox(width: AppSpacing.sm),
                        ShimmerBox(width: 120, height: 16),
                      ],
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
