import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../features/journal/data/datasources/journal_local_datasource.dart';
import '../../features/journal/data/repositories_impl/journal_repository_impl.dart';
import '../../features/journal/domain/repositories/journal_repository.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.init();

  // Register abstract types with their implementations
  getIt.registerLazySingleton<JournalLocalDataSource>(
    () => getIt<JournalLocalDataSourceImpl>(),
  );
  getIt.registerLazySingleton<JournalRepository>(
    () => getIt<JournalRepositoryImpl>(),
  );
}
