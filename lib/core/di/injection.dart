import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../shared/data/datasources/journal_local_datasource.dart';
import '../../shared/data/repositories_impl/journal_repository_impl.dart';
import '../../shared/domain/repositories/journal_repository.dart';
import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  // Register abstract types with their implementations first
  getIt.registerLazySingleton<JournalLocalDataSource>(
    () => getIt<JournalLocalDataSourceImpl>(),
  );
  getIt.registerLazySingleton<JournalRepository>(
    () => getIt<JournalRepositoryImpl>(),
  );

  // Then initialize the generated dependencies
  getIt.init();
}
