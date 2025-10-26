import 'package:flutter/foundation.dart';
import 'package:my_flutter_app/core/services/biometric_auth_service.dart';

class BiometricAuthProvider extends ChangeNotifier {
  BiometricAuthProvider() {
    _initialize();
  }

  bool _initialized = false;
  bool _requireOnLaunch = false;

  bool get initialized => _initialized;
  bool get requireOnLaunch => _requireOnLaunch;

  Future<void> _initialize() async {
    await BiometricAuthService.instance.init();
    _requireOnLaunch = BiometricAuthService.instance.requireOnLaunch;
    _initialized = true;
    notifyListeners();
  }

  Future<void> setRequireOnLaunch(bool value) async {
    if (_requireOnLaunch == value) return;
    _requireOnLaunch = value;
    await BiometricAuthService.instance.setRequireOnLaunch(value);
    notifyListeners();
  }
}
