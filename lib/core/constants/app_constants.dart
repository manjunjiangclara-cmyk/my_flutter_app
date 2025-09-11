/// App-wide constants that are used across multiple features
class AppConstants {
  AppConstants._();

  // ---------- App Info ----------
  static const String appName = 'Hibi';
  static const String appVersion = '1.0.0';

  // ---------- Storage Keys ----------
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';

  // ---------- Validation ----------
  static const int minPasswordLength = 8;
  static const int maxTitleLength = 100;
  static const int maxContentLength = 10000;

  // ---------- Date Formats ----------
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String timeFormat = 'HH:mm';
}
