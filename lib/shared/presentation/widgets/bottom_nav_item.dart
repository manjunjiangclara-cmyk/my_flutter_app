import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';

/// A reusable bottom navigation bar item factory that creates BottomNavigationBarItem instances.
class BottomNavItem {
  /// The emoji character to display as the icon.
  final String emoji;

  /// The text label to display below the icon.
  final String label;

  const BottomNavItem({required this.emoji, required this.label});

  /// Creates a BottomNavigationBarItem with the configured emoji and label.
  BottomNavigationBarItem build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return BottomNavigationBarItem(
      icon: Text(
        emoji,
        style: AppTypography.titleMedium.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      activeIcon: Text(
        emoji,
        style: AppTypography.titleMedium.copyWith(color: colorScheme.primary),
      ),
      label: label,
    );
  }
}
