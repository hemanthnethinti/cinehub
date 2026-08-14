import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/features/auth/domain/entities/user_role.dart';
import 'profile_avatar.dart';

/// Profile header section — avatar, name, role badge, headline,
/// location, and profile completion bar.
///
/// Reused by [ProfileScreen] (own profile) and [UserProfileScreen]
/// (public view). The avatar edit affordance is shown only when
/// [isOwnProfile] is true.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.initials,
    required this.fullName,
    required this.role,
    this.avatarUrl,
    this.headline,
    this.locationDisplay,
    this.completionPercent = 0,
    this.onAvatarTap,
    this.isOwnProfile = false,
    this.isUploadingAvatar = false,
  });

  final String initials;
  final String fullName;
  final UserRole role;
  final String? avatarUrl;

  /// Short professional tagline.
  final String? headline;

  /// Human-readable location — e.g. "Mumbai, India".
  final String? locationDisplay;

  /// Profile completion 0–100 — shown only for [isOwnProfile].
  final int completionPercent;

  final VoidCallback? onAvatarTap;
  final bool isOwnProfile;
  final bool isUploadingAvatar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.xxl),

          // ── Avatar ────────────────────────────────────────────
          ProfileAvatar(
            initials: initials,
            avatarUrl: avatarUrl,
            size: 96,
            onTap: isOwnProfile ? onAvatarTap : null,
            showCameraOverlay: isOwnProfile,
            isUploading: isUploadingAvatar,
          ),
          const SizedBox(height: AppSpacing.md),

          // ── Full name ─────────────────────────────────────────
          Text(
            fullName,
            style: AppTypography.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),

          // ── Role badge ────────────────────────────────────────
          _RoleBadge(role: role),

          // ── Headline ──────────────────────────────────────────
          if (headline != null && headline!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              headline!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],

          // ── Location ──────────────────────────────────────────
          if (locationDisplay != null && locationDisplay!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 14,
                  color: AppColors.textTertiary,
                ),
                const SizedBox(width: AppSpacing.xxs),
                Text(
                  locationDisplay!,
                  style: AppTypography.caption,
                ),
              ],
            ),
          ],

          // ── Completion bar (own profile only) ─────────────────
          if (isOwnProfile && completionPercent < 100) ...[
            const SizedBox(height: AppSpacing.lg),
            _CompletionBar(percent: completionPercent),
          ],

          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}

// ── Internal widgets ──────────────────────────────────────────────

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryMuted,
        borderRadius: AppRadius.full,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Text(
        role.label,
        style: AppTypography.labelSmall.copyWith(
          color: AppColors.primaryLight,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _CompletionBar extends StatelessWidget {
  const _CompletionBar({required this.percent});

  final int percent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Profile completion',
              style: AppTypography.caption,
            ),
            Text(
              '$percent%',
              style: AppTypography.caption.copyWith(
                color: AppColors.primaryLight,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        ClipRRect(
          borderRadius: AppRadius.full,
          child: LinearProgressIndicator(
            value: percent / 100,
            backgroundColor: AppColors.surfaceElevated,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}
