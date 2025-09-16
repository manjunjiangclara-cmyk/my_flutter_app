import 'package:flutter/material.dart';

/// App color tokens (Hibi design system)
class AppColors {
  AppColors._();

  // ========== LIGHT MODE COLORS ==========

  // Base palette
  static const Color primaryLight = Color(0xFFFFF3CC);
  static const Color backgroundLight = Color(0xFFFFF9F2);
  static const Color borderLight = Color(0xFFE6E6E6);
  static const Color accentLight = Color(0xFFA3C293);

  // Feedback
  static const Color successLight = Color(0xFF88B04B);
  static const Color errorLight = Color(0xFFE57373);

  // Text
  static const Color textPrimaryLight = Color(0xFF333333);
  static const Color textSecondaryLight = Color(0xFF666666);

  // ========== DARK MODE COLORS ==========

  // Base palette
  static const Color primaryDark = Color(0xFF2D2D2D);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color borderDark = Color(0xFF404040);
  static const Color accentDark = Color(0xFF6B8E5A);

  // Feedback
  static const Color successDark = Color(0xFF7BA05B);
  static const Color errorDark = Color(0xFFD32F2F);

  // Text
  static const Color textPrimaryDark = Color(0xFFE0E0E0);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // ========== LEGACY SUPPORT (for backward compatibility) ==========
  static const Color primary = primaryLight;
  static const Color background = backgroundLight;
  static const Color border = borderLight;
  static const Color accent = accentLight;
  static const Color success = successLight;
  static const Color error = errorLight;
  static const Color textPrimary = textPrimaryLight;
  static const Color textSecondary = textSecondaryLight;

  // ========== THEME SCHEMES ==========

  /// Light theme color scheme
  static ColorScheme get lightColorScheme => ColorScheme.fromSeed(
    seedColor: primaryLight,
    primary: primaryLight,
    secondary: accentLight,
    surface: backgroundLight,
    onPrimary: textPrimaryLight,
    onSecondary: Colors.white,
    onSurface: textPrimaryLight,
    onSurfaceVariant: textSecondaryLight,
    error: errorLight,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  /// Dark theme color scheme
  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: Colors.deepPurple,
    // primary: primaryDark,
    // secondary: accentDark,
    // surface: backgroundDark,
    // onPrimary: textPrimaryDark,
    // onSecondary: Colors.white,
    // onSurface: textPrimaryDark,
    // onSurfaceVariant: textSecondaryDark,
    // error: errorDark,
    // onError: Colors.white,
    brightness: Brightness.dark,
  );

  // ========== LEGACY SUPPORT ==========
  static ColorScheme get colorScheme => lightColorScheme;
}
