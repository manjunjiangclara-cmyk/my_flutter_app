/// Centralized app constants organized by domain.
///
/// This file contains all non-UI constants used across the application.
/// UI-specific constants are kept in theme/ui_constants.dart.
class AppConstants {
  AppConstants._();

  // ---------- App Info ----------
  static const String appName = 'Hibi';
  static const String appVersion = '1.0.0';

  // ---------- API Configuration ----------
  static const String baseUrl = 'https://api.example.com';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // ---------- API Endpoints ----------
  static const String journalsEndpoint = '/journals';
  static const String memoriesEndpoint = '/memories';
  static const String authEndpoint = '/auth';

  // ---------- Storage Keys ----------
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'app_theme';

  // ---------- Text Validation ----------
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 50;
  static const int maxTitleLength = 100;
  static const int maxContentLength = 10000;
  static const int maxTagLength = 50;
  static const int maxLocationLength = 100;

  // ---------- Email Validation ----------
  static const String emailRegex = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // ---------- Password Validation ----------
  static const String passwordRegex =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d@$!%*?&]{8,}$';

  // ---------- Date Formats ----------
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String timeFormat = 'HH:mm';

  // ---------- Compose Screen Constants ----------
  static const int postingDelaySeconds = 1;
  static const int postingSuccessDelayMs = 500;
}
