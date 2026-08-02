import 'package:flutter/material.dart';

/// CineHub animation constants.
///
/// All durations and curves used across the app.
/// Never hardcode [Duration] or [Curve] values elsewhere.
abstract final class AppAnimations {
  // ── Durations ──────────────────────────────────────────────────
  /// 100ms — instant micro-feedback (press states)
  static const Duration instant = Duration(milliseconds: 100);

  /// 180ms — fast hover / toggle transitions
  static const Duration fast = Duration(milliseconds: 180);

  /// 280ms — standard widget transitions
  static const Duration normal = Duration(milliseconds: 280);

  /// 400ms — page / modal transitions
  static const Duration slow = Duration(milliseconds: 400);

  /// 600ms — enter animations on large elements
  static const Duration xSlow = Duration(milliseconds: 600);

  // ── Curves ─────────────────────────────────────────────────────
  /// Standard easing — most UI transitions.
  static const Curve easeOut = Curves.easeOut;

  /// Fast deceleration — dropdown / sheet enter.
  static const Curve easeOutCubic = Curves.easeOutCubic;

  /// Elastic bounce — optional delight animations.
  static const Curve elasticOut = Curves.elasticOut;

  /// Smooth ease in-out — symmetric transitions.
  static const Curve easeInOut = Curves.easeInOut;
}
