import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('About CineHub', style: AppTypography.headlineSmall),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AppColors.primaryMuted,
                  borderRadius: AppRadius.lg,
                ),
                child: const Icon(Icons.movie_filter_rounded, size: 48, color: AppColors.primary),
              ),
              const SizedBox(height: AppSpacing.lg),
              const Text('CineHub', style: AppTypography.displaySmall),
              const SizedBox(height: AppSpacing.xs),
              Text('Version 1.0.0 (Build 42)', style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: AppSpacing.xxl),
              Text('© 2026 CineHub. All rights reserved.', style: AppTypography.bodySmall.copyWith(color: AppColors.textTertiary)),
            ],
          ),
        ),
      ),
    );
  }
}
