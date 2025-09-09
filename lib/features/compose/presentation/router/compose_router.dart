import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/features/compose/presentation/screens/compose_screen.dart';

/// Compose feature router configuration
class ComposeRouter {
  static const String composePath = '/compose';
  static const String composeName = 'compose';

  /// Compose feature routes
  static List<RouteBase> get routes => [
    GoRoute(
      path: composePath,
      name: composeName,
      builder: (context, state) => const ComposeScreen(),
    ),
  ];
}
