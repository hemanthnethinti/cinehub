import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';

class RoleBadge extends StatelessWidget {
  const RoleBadge({super.key, required this.role, required this.status});

  final String role;
  final String status;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color textColor;

    if (status == 'invited') {
      bgColor = AppColors.warning.withValues(alpha: 0.15);
      textColor = AppColors.warning;
    } else if (role == 'owner') {
      bgColor = AppColors.primaryMuted;
      textColor = AppColors.primary;
    } else {
      bgColor = AppColors.surfaceElevated;
      textColor = AppColors.textSecondary;
    }

    final displayText = status == 'invited' ? 'Pending ($role)' : _formatRole(role);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: AppRadius.sm,
      ),
      child: Text(
        displayText,
        style: AppTypography.labelSmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _formatRole(String role) {
    return role.split('_').map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '').join(' ');
  }
}
