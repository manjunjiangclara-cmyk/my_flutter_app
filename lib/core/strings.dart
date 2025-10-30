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
  static const String delete = 'Delete';
  static const String settings = 'Settings';
  static const String memory = 'Memory';
  static const String compose = 'Compose';
  static const String helpAndSupport = 'Help & Support';
  static const String appVersion = 'App Version';
  static const String selected = 'Selected';
  static const String loading = 'Loading...';

  // ---------- Delete Dialog ----------
  static const String deleteConfirmTitle = 'Delete Content?';
  static const String deleteConfirmMessage =
      'This action cannot be undone. Are you sure you want to delete?';

  // ---------- Screens: Memory ----------
  static const String myMemories = 'My Memories';
  static const String currentMonthYear = 'August, 2025';

  // ---------- Screens: Compose ----------
  static const String composePrompt = 'Hey, What is on your mind today?';
  static String get sampleDate => DateFormatter.getTodayFormattedCached();
  static const String post = 'Post';
  static const String addLocation = 'Add Location';
  static const String addTag = 'Add Tag';
  static const String selectDate = 'Select Date';
  static const String searchTagsHint = 'Search or add tags...';
  static const String searchLocationHint = 'Search for a location...';
  static const String enterTagHint = 'Enter a tag...';
  static const String noTags = 'No tags';
  static const String memoryLodgedSuccessfully =
      'Your memory has been safely lodged ❤️';
  static const String tagFunctionalityComingSoon = 'Tags coming soon';
  static const String noLocationsFound = 'No locations found';
  static const String tryDifferentLocation =
      'Try searching for a different location';
  static const String locationSearchError = 'Failed to search locations';
  static const String locationSearchTimeout =
      'Search timed out. Please try again.';
  static const String locationSearchRetry = 'Retry';
  static const String locationSearching = 'Searching...';
  static const String locationSearchHint = 'Somewhere that holds a memory';
  static const String locationRecentSearches = 'Recent Searches';
  static const String locationNearby = 'Nearby';
  static const String locationSelectLocation = 'Select Location';
  static const String locationAddCustom = 'Add Custom Location';
  static const String locationCustomName = 'Location Name';
  static const String locationCustomAddress = 'Address (Optional)';
  static const String locationCustomLatitude = 'Latitude';
  static const String locationCustomLongitude = 'Longitude';
  static const String locationCustomAdd = 'Add Custom Location';
  static const String locationCustomCancel = 'Cancel';

  // ---------- Screens: Journal ----------
  static const String location = 'Location';
  static const String shareToApps = 'Share to Apps';
  static const String saveToPhotos = 'Save to Photos';
  static const String shareOptionsTitle = 'Share Options';
  static const String shareAsImage = 'Share as Image';
  static const String shareAsPdf = 'Share as PDF';
  static const String shareImagePreparing = 'Preparing image…';
  static const String sharePdfPreparing = 'Preparing PDF…';

  // ---------- Settings ----------
  static const String general = 'General';
  static const String dataAndPrivacy = 'Data & Privacy';
  static const String theme = 'Theme';
  static const String notifications = 'Notifications';
  static const String showSplashQuote = 'Show splash quote';
  static const String showSplashQuoteSubtitle =
      'Show a quote on startup and pause briefly';
  static const String requireBiometricOnLaunch = 'Require authentication';
  static const String biometricDescription =
      'Sign in with Face ID when opening the app';
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

  // Theme display values for settings
  static const String themeValueLight = 'Light';
  static const String themeValueDark = 'Dark';
  static const String themeValueSystem = 'System';

  // ---------- Date Formatting ----------
  static const String memoryCardDateFormat = 'EEE, MMM d';

  // ---------- Image Error Messages ----------
  static const String imageUnavailable = 'Image unavailable';
  static const String imageNotFound = 'Image not found';
  static const String imageLoading = 'Loading image...';

  // ---------- Splash Screen ----------
  static const String splashTitle = 'Hibi';
  static const String splashSubtitle = 'Capture your memories';
  static const String splashLoading = 'Loading...';

  // Splash quotes were moved to `core/strings/splash_quotes.dart`.

  // ---------- Biometric Auth ----------
  static const String biometricUnlockReason = 'Unlock to continue';
  static const String biometricUnavailable = 'Authentication unavailable';
  static const String biometricNotEnrolled = 'No authentication method set up';
  static const String biometricLockedOut = 'Too many attempts. Try again later';
  static const String biometricCancel = 'Cancel';
  static const String biometricTryAgain = 'Try Again';
}
