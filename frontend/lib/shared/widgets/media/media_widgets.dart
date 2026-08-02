import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_typography.dart';

// ═══════════════════════════════════════════════════════════════
//  CACHED AVATAR
// ═══════════════════════════════════════════════════════════════

/// Circular user avatar backed by [CachedNetworkImage].
///
/// Shows initials when [imageUrl] is null or fails to load.
class CachedAvatar extends StatelessWidget {
  const CachedAvatar({
    super.key,
    this.imageUrl,
    required this.size,
    this.initials,
    this.onTap,
    this.showOnlineBadge = false,
    this.isOnline = false,
    this.borderColor,
    this.borderWidth = 0,
  });

  final String? imageUrl;
  final double size;
  final String? initials;
  final VoidCallback? onTap;
  final bool showOnlineBadge;
  final bool isOnline;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _buildAvatar(),
          if (showOnlineBadge) _buildOnlineDot(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderWidth > 0
            ? Border.all(
                color: borderColor ?? AppColors.border,
                width: borderWidth,
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: AppRadius.full,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                placeholder: (_, __) => _buildPlaceholder(),
                errorWidget: (_, __, ___) => _buildPlaceholder(),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    final text = initials ?? '?';
    return Container(
      width: size,
      height: size,
      color: AppColors.primaryMuted,
      child: Center(
        child: Text(
          text.length > 2 ? text.substring(0, 2).toUpperCase() : text.toUpperCase(),
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.primaryLight,
            fontSize: size * 0.32,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineDot() {
    final dotSize = size * 0.26;
    return Positioned(
      bottom: 0,
      right: 0,
      child: Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          color: isOnline ? AppColors.online : AppColors.offline,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.background, width: 1.5),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  CACHED IMAGE
// ═══════════════════════════════════════════════════════════════

/// Rectangular cached image with shimmer placeholder.
class CachedImage extends StatelessWidget {
  const CachedImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        placeholder: (_, __) => Container(
          width: width,
          height: height,
          color: AppColors.shimmerBase,
        ),
        errorWidget: (_, __, ___) => Container(
          width: width,
          height: height,
          color: AppColors.surfaceElevated,
          child: const Icon(Icons.image_not_supported_outlined,
              color: AppColors.textTertiary),
        ),
      ),
    );
  }
}
