import 'package:flutter/material.dart';

/// CineHub border radius tokens.
abstract final class AppRadius {
  /// 4px
  static const BorderRadius sm = BorderRadius.all(Radius.circular(4));
  /// 8px
  static const BorderRadius md = BorderRadius.all(Radius.circular(8));
  /// 12px
  static const BorderRadius lg = BorderRadius.all(Radius.circular(12));
  /// 16px
  static const BorderRadius xl = BorderRadius.all(Radius.circular(16));
  /// 20px
  static const BorderRadius xxl = BorderRadius.all(Radius.circular(20));
  /// 24px
  static const BorderRadius card = BorderRadius.all(Radius.circular(24));
  /// 999px — pill / fully rounded
  static const BorderRadius full = BorderRadius.all(Radius.circular(999));

  /// Radius values (for BoxDecoration.borderRadius etc.)
  static const double rSm  = 4;
  static const double rMd  = 8;
  static const double rLg  = 12;
  static const double rXl  = 16;
  static const double rXxl = 20;
  static const double rCard = 24;
  static const double rFull = 999;
}
