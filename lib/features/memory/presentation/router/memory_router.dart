import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/core/di/injection.dart';
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_bloc.dart';
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
      builder: (context, state) {
        return BlocProvider(
          create: (context) => getIt<MemoryBloc>(),
          child: const MemoryScreen(),
        );
      },
    ),
  ];
}
