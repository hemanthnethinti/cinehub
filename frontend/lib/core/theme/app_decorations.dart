import 'package:flutter/material.dart';
import 'app_colors.dart';

/// CineHub gradient tokens.
abstract final class AppGradients {
  /// Primary brand gradient — violet to pink.
  static const LinearGradient primary = LinearGradient(
    colors: [AppColors.primary, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Subtle violet gradient for card surfaces.
  static const LinearGradient primarySubtle = LinearGradient(
    colors: [Color(0xFF1A1230), Color(0xFF0D0D18)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Amber / warm gradient for accent elements.
  static const LinearGradient accent = LinearGradient(
    colors: [AppColors.accent, AppColors.secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark background shimmer gradient (transparent sides, bright center).
  static const LinearGradient shimmer = LinearGradient(
    colors: [
      AppColors.shimmerBase,
      AppColors.shimmerHighlight,
      AppColors.shimmerBase,
    ],
    stops: [0.0, 0.5, 1.0],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  /// Scrim gradient from bottom — for images with text overlay.
  static const LinearGradient scrimBottom = LinearGradient(
    colors: [Colors.transparent, AppColors.scrim],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

/// CineHub box shadow tokens.
abstract final class AppShadows {
  /// Subtle surface elevation.
  static const List<BoxShadow> sm = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  /// Card shadow.
  static const List<BoxShadow> md = [
    BoxShadow(
      color: Color(0x26000000),
      blurRadius: 12,
      offset: Offset(0, 4),
    ),
  ];

  /// Modal / sheet shadow.
  static const List<BoxShadow> lg = [
    BoxShadow(
      color: Color(0x33000000),
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  /// Primary color glow — used on active buttons.
  static List<BoxShadow> primaryGlow({double opacity = 0.25}) => [
        BoxShadow(
          color: AppColors.primary.withValues(alpha: opacity),
          blurRadius: 20,
          spreadRadius: 0,
          offset: const Offset(0, 4),
        ),
      ];
}
