import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service for managing app theme preferences
class ThemeService {
  ThemeService._();
  static final ThemeService _instance = ThemeService._();
  static ThemeService get instance => _instance;

  SharedPreferences? _prefs;

  /// Initialize the theme service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Get the current theme mode
  ThemeMode get themeMode {
    if (_prefs == null) return ThemeMode.system;

    final themeIndex = _prefs!.getInt(AppConstants.themeKey) ?? 0;
    return ThemeMode.values[themeIndex];
  }

  /// Set the theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_prefs == null) return;

    await _prefs!.setInt(AppConstants.themeKey, mode.index);
  }

  /// Get theme mode as string for display
  String getThemeModeString() {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Check if dark mode is currently active
  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }
}
