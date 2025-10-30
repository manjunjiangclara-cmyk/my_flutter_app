import 'package:my_flutter_app/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to persist splash-related user preferences.
class SplashSettingsService {
  SplashSettingsService._();
  static final SplashSettingsService _instance = SplashSettingsService._();
  static SplashSettingsService get instance => _instance;

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Whether to show quote and minimum delay on splash (default: true)
  bool get showQuote {
    if (_prefs == null) return true;
    return _prefs!.getBool(AppConstants.splashShowQuoteKey) ?? true;
  }

  Future<void> setShowQuote(bool value) async {
    if (_prefs == null) return;
    await _prefs!.setBool(AppConstants.splashShowQuoteKey, value);
  }
}
