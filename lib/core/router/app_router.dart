import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/router/bottom_navigation_shell.dart';
import 'package:my_flutter_app/features/journal/presentation/router/journal_router.dart';

/// App router configuration using GoRouter
class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      // Main app with bottom navigation
      GoRoute(
        path: '/',
        builder: (context, state) => const BottomNavigationShell(),
      ),
      // Journal view screen (full screen, not part of bottom nav)
      ...JournalRouter.routes,
    ],
  );

  static GoRouter get router => _router;
}
