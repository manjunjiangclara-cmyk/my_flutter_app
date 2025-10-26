import 'package:local_auth/local_auth.dart';
import 'package:my_flutter_app/core/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service to handle biometric authentication and persisted preference
class BiometricAuthService {
  BiometricAuthService._();
  static final BiometricAuthService _instance = BiometricAuthService._();
  static BiometricAuthService get instance => _instance;

  final LocalAuthentication _localAuth = LocalAuthentication();
  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Whether biometric prompt should be shown on app launch
  bool get requireOnLaunch {
    if (_prefs == null) return false;
    return _prefs!.getBool(AppConstants.biometricOnLaunchKey) ?? false;
  }

  Future<void> setRequireOnLaunch(bool value) async {
    if (_prefs == null) return;
    await _prefs!.setBool(AppConstants.biometricOnLaunchKey, value);
  }

  Future<bool> isDeviceSupported() async {
    return await _localAuth.isDeviceSupported();
  }

  Future<bool> canCheckBiometrics() async {
    try {
      return await _localAuth.canCheckBiometrics;
    } catch (_) {
      return false;
    }
  }

  /// Authenticate user using biometrics or device credential if available
  Future<bool> authenticate({required String localizedReason}) async {
    try {
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: const AuthenticationOptions(
          biometricOnly: false,
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
      return didAuthenticate;
    } catch (_) {
      return false;
    }
  }
}
