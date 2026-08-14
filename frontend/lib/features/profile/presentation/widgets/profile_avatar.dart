import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_decorations.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';
import 'package:cinehubapp/shared/widgets/feedback/feedback_widgets.dart';
import 'package:cinehubapp/shared/widgets/media/app_cached_image.dart';

/// Circular avatar with gradient-initials fallback, camera overlay,
/// and upload spinner.
///
/// - Pass [avatarUrl] to show a network image.
/// - Omit [avatarUrl] to show [initials] on a violet→pink gradient.
/// - Set [showCameraOverlay] on the edit screen to show the edit badge.
/// - Set [isUploading] to show a circular progress indicator.
class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.initials,
    this.avatarUrl,
    this.size = 80,
    this.onTap,
    this.showCameraOverlay = false,
    this.isUploading = false,
  });

  final String initials;
  final String? avatarUrl;

  /// Diameter of the avatar circle in logical pixels.
  final double size;

  final VoidCallback? onTap;

  /// Shows a camera-icon badge in the bottom-right corner.
  final bool showCameraOverlay;

  /// Overlays a spinner — used while the upload is in progress.
  final bool isUploading;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          // ── Avatar circle ──────────────────────────────────────
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: avatarUrl == null ? AppGradients.primary : null,
              border: Border.all(color: AppColors.border, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.18),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: avatarUrl != null && avatarUrl!.isNotEmpty
                  ? AppCachedImage(
                      imageUrl: avatarUrl!,
                      width: size,
                      height: size,
                      fit: BoxFit.cover,
                      errorWidget: _AvatarInitials(initials: initials, size: size),
                    )
                  : _AvatarInitials(initials: initials, size: size),
            ),
          ),

          // ── Upload spinner overlay ─────────────────────────────
          if (isUploading)
            Positioned.fill(
              child: ClipOval(
                child: ColoredBox(
                  color: AppColors.scrim,
                  child: Center(
                    child: SizedBox(
                      width: size * 0.28,
                      height: size * 0.28,
                      child: const ShimmerBox(width: 24, height: 24, borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                ),
              ),
            ),

          // ── Camera badge ───────────────────────────────────────
          if (showCameraOverlay && !isUploading)
            Container(
              width: size * 0.32,
              height: size * 0.32,
              decoration: BoxDecoration(
                gradient: AppGradients.primary,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.background, width: 2),
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                size: size * 0.16,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

/// Internal initials text on the gradient background.
class _AvatarInitials extends StatelessWidget {
  const _AvatarInitials({required this.initials, required this.size});

  final String initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        initials.isEmpty ? '?' : initials,
        style: AppTypography.headlineMedium.copyWith(
          fontSize: size * 0.32,
          color: Colors.white,
          fontWeight: FontWeight.w800,
          height: 1,
        ),
      ),
    );
  }
}
