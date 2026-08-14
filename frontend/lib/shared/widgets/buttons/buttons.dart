import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_decorations.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:shimmer/shimmer.dart';

// ═══════════════════════════════════════════════════════════════
//  PRIMARY BUTTON
// ═══════════════════════════════════════════════════════════════

/// Full gradient CineHub action button.
///
/// Use for the primary call-to-action on any screen.
/// [isExpanded] stretches to fill available width.
/// Pass [isLoading] to show a spinner and disable interaction.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = false,
    this.height = 48,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;
  final double height;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;

    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: height,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled ? AppGradients.primary : null,
          color: enabled ? null : AppColors.surfaceElevated,
          borderRadius: AppRadius.md,
          boxShadow: enabled ? AppShadows.primaryGlow() : null,
        ),
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          ),
          child: isLoading
                ? Shimmer.fromColors(
                    baseColor: Colors.white,
                    highlightColor: Colors.white.withAlpha(50),
                    child: Text(label, style: AppTypography.button),
                  )
              : Row(
                  mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, size: 18, color: Colors.white),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Text(
                      label,
                      style: AppTypography.button.copyWith(color: Colors.white),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  GHOST / OUTLINE BUTTON
// ═══════════════════════════════════════════════════════════════

/// Outline button — secondary actions, less visual weight than [PrimaryButton].
class GhostButton extends StatelessWidget {
  const GhostButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isExpanded = false,
    this.height = 44,
    this.color,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isExpanded;
  final double height;

  /// Override border/text color. Defaults to [AppColors.border].
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.border;
    return SizedBox(
      width: isExpanded ? double.infinity : null,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: c, width: 1),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.md),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        ),
        child: Row(
          mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 16, color: AppColors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(label, style: AppTypography.button),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  ICON BUTTON
// ═══════════════════════════════════════════════════════════════

/// Compact icon-only button with a surface background.
class AppIconButton extends StatelessWidget {
  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 40,
    this.iconSize = 20,
    this.color,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final double iconSize;
  final Color? color;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? AppColors.textSecondary;

    return Tooltip(
      message: tooltip ?? '',
      child: InkWell(
        onTap: onPressed,
        borderRadius: AppRadius.md,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: AppRadius.md,
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
      ),
    );
  }
}
