import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/features/settings/presentation/screens/settings_screen.dart';

/// Settings feature router configuration
class SettingsRouter {
  static const String settingsPath = '/settings';
  static const String settingsName = 'settings';

  /// Settings feature routes
  static List<RouteBase> get routes => [
    GoRoute(
      path: settingsPath,
      name: settingsName,
      builder: (context, state) => const SettingsScreen(),
    ),
  ];
}
