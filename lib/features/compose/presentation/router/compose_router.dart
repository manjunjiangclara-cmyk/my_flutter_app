import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/features/compose/presentation/bloc/compose_bloc.dart';
import 'package:my_flutter_app/features/compose/presentation/screens/compose_home_screen.dart';
import 'package:my_flutter_app/features/compose/presentation/screens/compose_screen.dart';

/// Compose feature router configuration
class ComposeRouter {
  static const String composeHomePath = '/compose';
  static const String composeHomeName = 'compose';
  static const String composePath = '/compose/new';
  static const String composeName = 'compose-new';
  static const String composeEditPath = '/compose/edit/:journalId';
  static const String composeEditName = 'compose-edit';

  /// Compose feature routes
  static List<RouteBase> get routes => [
    GoRoute(
      path: composeHomePath,
      name: composeHomeName,
      builder: (context, state) => const ComposeHomeScreen(),
    ),
    GoRoute(
      path: composePath,
      name: composeName,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<ComposeBloc>(),
        child: const ComposeScreen(),
      ),
    ),
    GoRoute(
      path: composeEditPath,
      name: composeEditName,
      builder: (context, state) {
        final journalId = state.pathParameters['journalId'];
        return BlocProvider(
          create: (_) => getIt<ComposeBloc>(),
          child: ComposeScreen(journalId: journalId),
        );
      },
    ),
  ];
}
