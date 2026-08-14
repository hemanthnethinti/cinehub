import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/shared/widgets/buttons/buttons.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart';


class HomeAppBar extends ConsumerWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final userName = authState is AuthAuthenticated 
      ? authState.user.firstName 
      : 'Creator';

    return SliverAppBar(
      pinned: true,
      floating: true,
      elevation: 0,
      backgroundColor: AppColors.background.withValues(alpha: 0.95),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Good morning,',
            style: AppTypography.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          Text(
            userName,
            style: AppTypography.headlineMedium,
          ),
        ],
      ),
      actions: [
        AppIconButton(
          icon: Icons.search_rounded,
          onPressed: () {
            // TODO: Implement search
          },
          tooltip: 'Search',
        ),
        const SizedBox(width: AppSpacing.lg),
      ],
    );
  }
}
