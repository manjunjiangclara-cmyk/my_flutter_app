import 'package:flutter/material.dart';

class AppTypography {
  AppTypography._();

  // ---------- Lora 字体（文学风格） ----------
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'Lora',
    fontWeight: FontWeight.bold,
    fontSize: 28, // 大标题
    height: 48 / 40, // 行高 = 48px
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Lora',
    fontWeight: FontWeight.w400,
    fontSize: 16, // 正文
    height: 24 / 16,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Lora',
    fontWeight: FontWeight.w400,
    fontSize: 14, // 小正文 / 次要说明
    height: 20 / 14,
  );

  // ---------- Inter 字体（UI 元素） ----------
  static const TextStyle headlineMedium = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 28, // 小标题
    height: 36 / 28,
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500, // Medium
    fontSize: 20, // 副标题 / Emphasis
    height: 28 / 20,
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 16, // 按钮文字
    height: 24 / 16,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 14, // 按钮文字
    height: 20 / 14,
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 12, // 辅助文字 / Caption
    height: 18 / 12,
  );

  // ---------- 可选：TextTheme ----------
  static TextTheme get textTheme => const TextTheme(
    displayLarge: displayLarge,
    headlineMedium: headlineMedium,
    titleMedium: titleMedium,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}
