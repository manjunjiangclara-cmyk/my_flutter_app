import 'package:flutter/material.dart';

/// Utility class for UI-related calculations
class UICalculations {
  UICalculations._();

  /// Calculate the top bar area based on app bar visibility
  ///
  /// When [isAppBarVisible] is false, returns only the status bar height.
  /// When [isAppBarVisible] is true, returns both status bar and app bar height.
  static double getTopBarArea(BuildContext context, bool isAppBarVisible) {
    if (!isAppBarVisible) {
      // When app bar is hidden, only status bar is present
      return MediaQuery.of(context).padding.top;
    }

    // When app bar is visible, include both status bar and app bar
    return kToolbarHeight + MediaQuery.of(context).padding.top;
  }

  /// Get the available content height excluding top and bottom safe areas
  static double getAvailableContentHeight(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return screenHeight - topPadding - bottomPadding;
  }

  /// Get the available content height excluding top bar area and bottom safe area
  static double getAvailableContentHeightWithTopBar(
    BuildContext context,
    bool isAppBarVisible,
  ) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topBarArea = getTopBarArea(context, isAppBarVisible);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return screenHeight - topBarArea - bottomPadding;
  }
}
