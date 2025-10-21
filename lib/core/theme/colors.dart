import 'package:flutter/material.dart';

/// App color tokens (Hibi design system)
class AppColors {
  AppColors._();

  // ========== LIGHT MODE COLORS ==========

  // Base palette
  static const Color primaryLight = Color(0xFFFFF3CC);
  static const Color backgroundLight = Color(0xFFF7F3E9);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color borderLight = Color(0xFFE6E0D6);
  static const Color accentLight = Color(0xFFD49A7B);
  static const Color accentAltLight = Color(0xFFA3C293);

  // Feedback
  static const Color successLight = Color(0xFF88B04B);
  static const Color errorLight = Color(0xFFE57373);

  // Text
  static const Color textPrimaryLight = Color(0xFF5A4A3A);
  static const Color textSecondaryLight = Color(0xFF666666);

  // ========== DARK MODE COLORS ==========

  // Base palette
  static const Color primaryDark = Color(0xFF2D2D2D);
  static const Color backgroundDark = Color(0xFF1A1A1A);
  static const Color surfaceDark = Color(0xFF222222);
  static const Color borderDark = Color(0xFF404040);
  static const Color accentDark = Color(0xFFB37758);
  static const Color accentAltDark = Color(0xFF6B8E5A);

  // Feedback
  static const Color successDark = Color(0xFF7BA05B);
  static const Color errorDark = Color(0xFFD32F2F);

  // Text
  static const Color textPrimaryDark = Color(0xFFE8D5C7);
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

  // Subtle shadow tint that blends a hint of primary into shadows
  static const Color shadowTint = Color(0xFF19120E);

  // ========== UI COMPONENT COLORS ==========

  // Liquid Glass Icon Button
  static const Color liquidGlassIconBackground = Color(
    0xFFF2F2F2,
  ); // Light gray background for journal app bar icons

  // ========== THEME SCHEMES ==========

  /// Light theme color scheme (no seed)
  static ColorScheme get lightColorScheme => ColorScheme.light(
    primary: accentLight,
    onPrimary: Colors.white,
    secondary: primaryLight,
    onSecondary: textPrimaryLight,
    tertiary: accentAltLight,
    onTertiary: Colors.white,
    surface: surfaceLight,
    onSurface: textPrimaryLight,
    surfaceContainerHighest: surfaceLight,
    onSurfaceVariant: textSecondaryLight,
    outline: borderLight,
    error: errorLight,
    onError: Colors.white,
  );

  /// Dark theme color scheme (no seed)
  static ColorScheme get darkColorScheme => ColorScheme.dark(
    primary: accentDark,
    onPrimary: Colors.white,
    secondary: accentAltDark,
    onSecondary: Colors.white,
    tertiary: accentAltDark,
    onTertiary: Colors.white,
    surface: surfaceDark,
    onSurface: textPrimaryDark,
    surfaceContainerHighest: surfaceDark,
    onSurfaceVariant: textSecondaryDark,
    outline: borderDark,
    error: errorDark,
    onError: Colors.white,
  );

  // ========== LEGACY SUPPORT ==========
  static ColorScheme get colorScheme => lightColorScheme;
}
