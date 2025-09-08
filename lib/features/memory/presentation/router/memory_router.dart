import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/features/memory/presentation/screens/memory_screen.dart';

/// Memory feature router configuration
class MemoryRouter {
  static const String memoryPath = '/memory';
  static const String memoryName = 'memory';

  /// Memory feature routes
  static List<RouteBase> get routes => [
    GoRoute(
      path: memoryPath,
      name: memoryName,
      builder: (context, state) => const MemoryScreen(),
    ),
  ];
}
