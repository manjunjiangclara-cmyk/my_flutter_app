import 'package:flutter/material.dart';

import 'colors.dart';

/// Typography scale for the app.
class AppTypography {
  AppTypography._();

  // Families (ensure fonts are added in pubspec if custom)
  static const String fontSans = 'Inter';
  static const String fontSerif = 'Merriweather';

  static const TextStyle headline1 = TextStyle(
    fontFamily: fontSans,
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 1.25,
    color: AppColors.textPrimary,
  );

  static const TextStyle headline2 = TextStyle(
    fontFamily: fontSans,
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 1.3,
    color: AppColors.textPrimary,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontSerif,
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.6,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: fontSans,
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  static TextTheme toTextTheme() {
    return const TextTheme(
      headlineLarge: headline1,
      headlineMedium: headline2,
      bodyLarge: body,
      labelMedium: caption,
    );
  }
}
