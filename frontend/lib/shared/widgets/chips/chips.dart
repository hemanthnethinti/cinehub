import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';

// ═══════════════════════════════════════════════════════════════
//  SKILL CHIP
// ═══════════════════════════════════════════════════════════════

/// Compact pill chip for displaying a single skill or tag.
class SkillChip extends StatelessWidget {
  const SkillChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryMuted : AppColors.surfaceElevated,
          borderRadius: AppRadius.full,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1 : 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 12,
                color: isSelected ? AppColors.primaryLight : AppColors.textTertiary,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: AppTypography.labelSmall.copyWith(
                color: isSelected ? AppColors.primaryLight : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  STATUS CHIP
// ═══════════════════════════════════════════════════════════════

enum StatusType { active, draft, completed, pending, error }

/// Status badge chip — used on project cards, team invites, etc.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required this.status,
  });

  final String label;
  final StatusType status;

  @override
  Widget build(BuildContext context) {
    final (bg, fg, dot) = switch (status) {
      StatusType.active    => (AppColors.successMuted, AppColors.success, AppColors.success),
      StatusType.completed => (AppColors.primaryMuted, AppColors.primaryLight, AppColors.primary),
      StatusType.draft     => (AppColors.surfaceOverlay, AppColors.textTertiary, AppColors.textTertiary),
      StatusType.pending   => (AppColors.warningMuted, AppColors.warning, AppColors.warning),
      StatusType.error     => (AppColors.errorMuted, AppColors.error, AppColors.error),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: AppRadius.full,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTypography.labelSmall.copyWith(color: fg)),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ROLE CHIP
// ═══════════════════════════════════════════════════════════════

/// Role selector chip used on the register screen.
class RoleChip extends StatelessWidget {
  const RoleChip({
    super.key,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceElevated,
          borderRadius: AppRadius.full,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.labelSmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
