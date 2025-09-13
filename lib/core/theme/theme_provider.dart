import 'package:flutter/material.dart';
import 'package:my_flutter_app/core/theme/theme_service.dart';

/// Provider for managing theme state across the app
class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _initializeTheme();
  }

  ThemeMode _themeMode = ThemeMode.system;
  bool _isInitialized = false;

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Whether the provider has been initialized
  bool get isInitialized => _isInitialized;

  /// Initialize theme from storage
  Future<void> _initializeTheme() async {
    await ThemeService.instance.init();
    _themeMode = ThemeService.instance.themeMode;
    _isInitialized = true;
    notifyListeners();
  }

  /// Set theme mode and persist to storage
  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode == mode) return;

    _themeMode = mode;
    await ThemeService.instance.setThemeMode(mode);
    notifyListeners();
  }

  /// Toggle between light and dark mode (ignores system)
  Future<void> toggleTheme() async {
    final newMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Check if dark mode is currently active
  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get theme mode as string for display
  String getThemeModeString() {
    return ThemeService.instance.getThemeModeString();
  }
}
