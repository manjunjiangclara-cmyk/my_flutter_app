/// Validation-related constants
class ValidationConstants {
  ValidationConstants._();

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
}
