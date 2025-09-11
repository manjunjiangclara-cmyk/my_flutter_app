import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_bloc.dart';
import 'package:my_flutter_app/features/memory/presentation/screens/memory_screen.dart';
import 'package:my_flutter_app/shared/data/datasources/journal_local_datasource.dart';
import 'package:my_flutter_app/shared/data/repositories_impl/journal_repository_impl.dart';
import 'package:my_flutter_app/shared/domain/usecases/get_journals.dart';

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
        // Create the dependency chain for GetJournals
        final localDataSource = JournalLocalDataSourceImpl();
        final repository = JournalRepositoryImpl(
          localDataSource: localDataSource,
        );
        final getJournals = GetJournals(repository);

        return BlocProvider(
          create: (context) => MemoryBloc(getJournals: getJournals),
          child: const MemoryScreen(),
        );
      },
    ),
  ];
}
