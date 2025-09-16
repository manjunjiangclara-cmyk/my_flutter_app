import 'package:my_flutter_app/core/utils/date_formatter.dart';

/// Centralized app string constants.
///
/// Organize by feature/domain to keep usage clear and maintainable.
class AppStrings {
  AppStrings._();

  // ---------- App ----------
  static const String appName = 'Hibi';

  // ---------- Common UI ----------
  static const String ok = 'OK';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String settings = 'Settings';
  static const String memory = 'Memory';
  static const String compose = 'Compose';
  static const String helpAndSupport = 'Help & Support';
  static const String appVersion = 'App Version';

  // ---------- Screens: Memory ----------
  static const String myMemories = 'My Memories';
  static const String currentMonthYear = 'August, 2025';

  // ---------- Screens: Compose ----------
  static const String composePrompt = 'Hey, What is on your mind today?';
  static String get sampleDate => DateFormatter.getTodayFormatted();
  static const String post = 'Post';
  static const String addLocation = 'Add Location';
  static const String addTag = 'Add Tag';
  static const String searchLocationHint = 'Search for a location...';
  static const String enterTagHint = 'Enter a tag...';
  static const String memoryLodgedSuccessfully =
      'Your memory has been safely lodged ❤️';

  // ---------- Screens: Journal ----------
  static const String location = 'Location';

  // ---------- Settings ----------
  static const String general = 'General';
  static const String dataAndPrivacy = 'Data & Privacy';
  static const String theme = 'Theme';
  static const String notifications = 'Notifications';
  static const String backupAndSync = 'Backup & Sync';
  static const String privacy = 'Privacy';
  static const String changeAppAppearance = 'Change app appearance';
  static const String manageNotificationPreferences =
      'Manage notification preferences';
  static const String manageYourDataBackup = 'Manage your data backup';
  static const String controlYourPrivacySettings =
      'Control your privacy settings';

  // ---------- Theme Settings ----------
  static const String lightTheme = 'Light';
  static const String darkTheme = 'Dark';
  static const String systemTheme = 'System';
  static const String selectTheme = 'Select Theme';
  static const String themeDescription = 'Choose how the app looks';
  static const String followSystemTheme = 'Follow system setting';
  static const String alwaysLight = 'Always light';
  static const String alwaysDark = 'Always dark';

  // ---------- Date Formatting ----------
  static const String memoryCardDateFormat = 'EEE, MMMM d';
}
