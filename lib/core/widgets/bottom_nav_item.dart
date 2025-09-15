import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/fonts.dart';

/// A reusable bottom navigation bar item factory that creates BottomNavigationBarItem instances.
class BottomNavItem {
  /// The emoji character to display as the icon.
  final String emoji;

  /// The text label to display below the icon.
  final String label;

  /// Whether this item is currently selected.
  final bool isSelected;

  const BottomNavItem({
    required this.emoji,
    required this.label,
    this.isSelected = false,
  });

  /// Creates a BottomNavigationBarItem with the configured emoji and label.
  BottomNavigationBarItem build(BuildContext context) {
    return BottomNavigationBarItem(
      icon: Text(emoji, style: AppTypography.titleMedium),
      label: label,
    );
  }
}
