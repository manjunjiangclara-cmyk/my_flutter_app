import 'package:flutter/foundation.dart';
import 'package:my_flutter_app/core/services/splash_settings_service.dart';

class SplashSettingsProvider extends ChangeNotifier {
  SplashSettingsProvider() {
    _initialize();
  }

  bool _initialized = false;
  bool _showQuote = true;

  bool get initialized => _initialized;
  bool get showQuote => _showQuote;

  Future<void> _initialize() async {
    await SplashSettingsService.instance.init();
    _showQuote = SplashSettingsService.instance.showQuote;
    _initialized = true;
    notifyListeners();
  }

  Future<void> setShowQuote(bool value) async {
    if (_showQuote == value) return;
    _showQuote = value;
    await SplashSettingsService.instance.setShowQuote(value);
    notifyListeners();
  }
}
