import 'package:go_router/go_router.dart';
import 'package:my_flutter_app/features/journal/data/datasources/journal_local_datasource.dart';
import 'package:my_flutter_app/features/journal/data/repositories_impl/journal_repository_impl.dart';
import 'package:my_flutter_app/features/journal/domain/usecases/get_journal_by_id.dart';
import 'package:my_flutter_app/features/journal/presentation/screens/journal_view_screen.dart';

/// Journal feature router configuration
class JournalRouter {
  static const String journalViewPath = '/journal/:journalId';
  static const String journalViewName = 'journal-view';

  /// Journal feature routes
  static List<RouteBase> get routes => [
    GoRoute(
      path: journalViewPath,
      name: journalViewName,
      builder: (context, state) {
        final journalId = state.pathParameters['journalId']!;
        // Create the dependency chain for GetJournalById
        final localDataSource = JournalLocalDataSourceImpl();
        final repository = JournalRepositoryImpl(
          localDataSource: localDataSource,
        );
        final getJournalById = GetJournalById(repository);

        return JournalViewScreen(
          journalId: journalId,
          getJournalById: getJournalById,
        );
      },
    ),
  ];
}
