import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/presentation/splash_screen.dart';
import 'package:my_flutter_app/core/router/bottom_navigation_shell.dart';
import 'package:my_flutter_app/core/theme/ui_constants.dart';
import 'package:my_flutter_app/features/compose/presentation/router/compose_router.dart';
import 'package:my_flutter_app/features/journal/presentation/router/journal_router.dart';

/// App router configuration using GoRouter
class AppRouter {
  static final GoRouter _router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // Splash screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      // Main app with bottom navigation
      GoRoute(
        path: '/',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: const BottomNavigationShell(),
            transitionDuration: UIConstants.splashRouteTransitionDuration,
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
              return FadeTransition(opacity: curved, child: child);
            },
          );
        },
      ),
      // Journal view screen (full screen, not part of bottom nav)
      ...JournalRouter.routes,
      // Compose screens (independent routes)
      ...ComposeRouter.routes,
    ],
  );

  static GoRouter get router => _router;
}
