import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_decorations.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';

/// Top section shared by all auth screens.
///
/// Displays the CineHub wordmark, optional tagline, and the screen title.
class AuthHeader extends StatelessWidget {
  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
  });

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── CineHub wordmark ─────────────────────────────────────
        ShaderMask(
          shaderCallback: (bounds) =>
              AppGradients.primary.createShader(bounds),
          child: Text(
            'CineHub',
            style: AppTypography.displaySmall.copyWith(
              color: Colors.white, // masked by gradient
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),

        // ── Screen title ─────────────────────────────────────────
        Text(title, style: AppTypography.displaySmall),
        if (subtitle != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            subtitle!,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  PASSWORD STRENGTH INDICATOR
// ═══════════════════════════════════════════════════════════════

/// Animated password strength bar shown while typing.
class PasswordStrengthIndicator extends StatelessWidget {
  const PasswordStrengthIndicator({super.key, required this.password});

  final String password;

  @override
  Widget build(BuildContext context) {
    final strength = _getStrength(password);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: List.generate(4, (i) {
            final filled = i < strength.level;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < 3 ? 4 : 0),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 3,
                  decoration: BoxDecoration(
                    color: filled ? strength.color : AppColors.surfaceOverlay,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            );
          }),
        ),
        if (password.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            strength.label,
            style: AppTypography.caption.copyWith(color: strength.color),
          ),
        ],
      ],
    );
  }

  _PasswordStrength _getStrength(String pw) {
    if (pw.isEmpty) return _PasswordStrength.empty;
    int score = 0;
    if (pw.length >= 8) score++;
    if (pw.length >= 12) score++;
    if (RegExp(r'[A-Z]').hasMatch(pw) && RegExp(r'[a-z]').hasMatch(pw)) score++;
    if (RegExp(r'\d').hasMatch(pw)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(pw)) score++;

    if (score <= 1) return _PasswordStrength.weak;
    if (score == 2) return _PasswordStrength.fair;
    if (score == 3) return _PasswordStrength.good;
    return _PasswordStrength.strong;
  }
}

enum _PasswordStrength {
  empty(level: 0, label: '', color: Colors.transparent),
  weak(level: 1, label: 'Weak', color: AppColors.error),
  fair(level: 2, label: 'Fair', color: AppColors.warning),
  good(level: 3, label: 'Good', color: AppColors.accent),
  strong(level: 4, label: 'Strong', color: AppColors.success);

  const _PasswordStrength({
    required this.level,
    required this.label,
    required this.color,
  });

  final int level;
  final String label;
  final Color color;
}

// ═══════════════════════════════════════════════════════════════
//  AUTH DIVIDER
// ═══════════════════════════════════════════════════════════════

/// "— or —" divider between primary and social auth.
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key, this.label = 'or'});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Text(
            label,
            style: AppTypography.caption,
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
