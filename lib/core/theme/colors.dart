import 'package:flutter/material.dart';

/// App color tokens (Hibi design system)
class AppColors {
  AppColors._();

  // ========== LIGHT MODE COLORS ==========

  // Base palette
  static const Color primaryLight = Color(0xFFFFE8A3);
  static const Color backgroundLight = Color(0xFFFFF9F2);
  static const Color borderLight = Color(0xFFE6E6E6);
  static const Color accentLight = Color(0xFFA3C293);

  // Generated color scheme properties
  static const Color primaryContainerLight = Color(0xFFFFF3CC);
  static const Color onPrimaryContainerLight = Color(0xFF2D2D2D);
  static const Color secondaryLight = Color(0xFF8B6F47);
  static const Color onSecondaryLight = Color(0xFFFFFFFF);
  static const Color secondaryContainerLight = Color(0xFFFFE8A3);
  static const Color onSecondaryContainerLight = Color(0xFF2D2D2D);
  static const Color tertiaryContainerLight = Color(0xFFE8F5E0);
  static const Color onTertiaryContainerLight = Color(0xFF1B2E1A);
  static const Color surfaceVariantLight = Color(0xFFF5F5F5);
  static const Color outlineVariantLight = Color(0xFFCCCCCC);
  static const Color shadowLight = Color(0xFF000000);
  static const Color scrimLight = Color(0xFF000000);
  static const Color inverseSurfaceLight = Color(0xFF2D2D2D);
  static const Color onInverseSurfaceLight = Color(0xFFFFFFFF);
  static const Color inversePrimaryLight = Color(0xFFFFE8A3);

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
  // ========== THEME SCHEMES ==========

  /// Light theme color scheme
  static ColorScheme get lightColorScheme => ColorScheme.fromSeed(
    seedColor: primaryLight,
    brightness: Brightness.light,
    // ).copyWith(
    primary: primaryLight,
    // onPrimary: textPrimaryLight,
    // primaryContainer: primaryContainerLight,
    // onPrimaryContainer: onPrimaryContainerLight,
    // tertiary: accentLight,
    // onTertiary: Colors.white,
    // tertiaryContainer: tertiaryContainerLight,
    // onTertiaryContainer: onTertiaryContainerLight,
    secondary: secondaryLight,
    // onSecondary: onSecondaryLight,
    // secondaryContainer: secondaryContainerLight,
    // onSecondaryContainer: onSecondaryContainerLight,
    surface: backgroundLight,
    onSurface: textPrimaryLight,
    surfaceContainerHighest: surfaceVariantLight,
    onSurfaceVariant: textSecondaryLight,
    outline: borderLight,
    outlineVariant: outlineVariantLight,
    shadow: shadowLight,
    scrim: scrimLight,
    inverseSurface: inverseSurfaceLight,
    onInverseSurface: onInverseSurfaceLight,
    inversePrimary: inversePrimaryLight,
    error: errorLight,
    onError: Colors.white,
  );

  /// Dark theme color scheme
  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: primaryLight,
    // primary: primaryDark,
    // secondary: accentDark,
    // surface: backgroundDark,
    // onPrimary: textPrimaryDark,
    // onSecondary: Colors.white,
    // onSurface: textPrimaryDark,
    // onSurfaceVariant: textSecondaryDark,
    // outline: borderDark,
    // error: errorDark,
    // onError: Colors.white,
    brightness: Brightness.dark,
  );

  // ========== LEGACY SUPPORT ==========
  static ColorScheme get colorScheme => lightColorScheme;
}
