import 'package:flutter/material.dart';
import 'package:cinehubapp/core/theme/app_colors.dart';
import 'package:cinehubapp/core/theme/app_radius.dart';
import 'package:cinehubapp/core/theme/app_spacing.dart';

/// Full-screen skeleton loader for the profile feature.
///
/// Implements a simple custom shimmer animation using an AnimatedBuilder
/// and a sliding LinearGradient.
class ProfileLoadingSkeleton extends StatefulWidget {
  const ProfileLoadingSkeleton({super.key});

  @override
  State<ProfileLoadingSkeleton> createState() => _ProfileLoadingSkeletonState();
}

class _ProfileLoadingSkeletonState extends State<ProfileLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: const [
                AppColors.shimmerBase,
                AppColors.shimmerHighlight,
                AppColors.shimmerBase,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: const Alignment(-1.0, -0.3),
              end: const Alignment(1.0, 0.3),
              transform: _SlidingGradientTransform(
                slidePercent: _controller.value,
              ),
            ).createShader(bounds);
          },
          child: const _SkeletonLayout(),
        );
      },
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({required this.slidePercent});

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * (slidePercent * 2 - 1), 0.0, 0.0);
  }
}

class _SkeletonLayout extends StatelessWidget {
  const _SkeletonLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppSpacing.xxl),
          
          // Avatar
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          
          // Name
          _SkeletonBox(width: 160, height: 28),
          const SizedBox(height: AppSpacing.sm),
          
          // Role
          _SkeletonBox(width: 80, height: 24, borderRadius: AppRadius.rFull),
          const SizedBox(height: AppSpacing.xl),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _SkeletonBox(width: 60, height: 40),
              _SkeletonBox(width: 60, height: 40),
              _SkeletonBox(width: 60, height: 40),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          
          // Action Buttons
          Row(
            children: [
              Expanded(child: _SkeletonBox(height: 48, borderRadius: AppRadius.rMd)),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: _SkeletonBox(height: 48, borderRadius: AppRadius.rMd)),
            ],
          ),
          const SizedBox(height: AppSpacing.xxl),
          
          // Bio / Content
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(width: 120, height: 20),
                const SizedBox(height: AppSpacing.md),
                _SkeletonBox(width: double.infinity, height: 16),
                const SizedBox(height: AppSpacing.sm),
                _SkeletonBox(width: double.infinity, height: 16),
                const SizedBox(height: AppSpacing.sm),
                _SkeletonBox(width: 200, height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    this.width,
    this.height,
    this.borderRadius = AppRadius.rSm,
  });

  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white, // Will be masked by the ShaderMask
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
