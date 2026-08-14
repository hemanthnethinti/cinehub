import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/auth/presentation/providers/auth_providers.dart';

class LogoutDialog extends ConsumerWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceElevated,
      title: const Text('Log Out', style: AppTypography.headlineSmall),
      content: const Text(
        'Are you sure you want to log out of CineHub?',
        style: AppTypography.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            ref.read(authNotifierProvider.notifier).logout();
            Navigator.of(context).pop();
          },
          child: Text('Log Out', style: AppTypography.bodyMedium.copyWith(color: AppColors.error)),
        ),
      ],
    );
  }
}
