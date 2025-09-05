import 'package:flutter/material.dart';

/// App color tokens (Hibi design system)
class AppColors {
  AppColors._();

  // Base palette
  static const Color primary = Color(0xFFFFF3CC);
  static const Color background = Color(0xFFFFF9F2);
  static const Color border = Color(0xFFE6E6E6);
  static const Color accent = Color(0xFFA3C293);

  // Feedback
  static const Color success = Color(0xFF88B04B);
  static const Color error = Color(0xFFE57373);

  // Text
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF666666);

  // Derived scheme
  static ColorScheme colorScheme = ColorScheme.fromSeed(
    seedColor: primary,
    primary: primary,
    secondary: accent,
    surface: background,
    onPrimary: textPrimary,
    onSecondary: Colors.white,
    onSurface: textPrimary,
    error: error,
    onError: Colors.white,
    brightness: Brightness.light,
  );
}
