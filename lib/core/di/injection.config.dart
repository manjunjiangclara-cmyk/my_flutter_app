// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:my_flutter_app/core/database/database_helper.dart' as _i607;
import 'package:my_flutter_app/core/router/tab_controller.dart' as _i1002;
import 'package:my_flutter_app/core/services/google_places_service.dart'
    as _i805;
import 'package:my_flutter_app/core/services/image_picker_service.dart'
    as _i193;
import 'package:my_flutter_app/core/services/journal_change_notifier.dart'
    as _i870;
import 'package:my_flutter_app/core/utils/file_storage_service.dart' as _i658;
import 'package:my_flutter_app/core/utils/image_path_service.dart' as _i1035;
import 'package:my_flutter_app/features/compose/presentation/bloc/compose_bloc.dart'
    as _i1036;
import 'package:my_flutter_app/features/compose/presentation/bloc/location_picker/location_picker_bloc.dart'
    as _i794;
import 'package:my_flutter_app/features/compose/presentation/services/location_search_service.dart'
    as _i750;
import 'package:my_flutter_app/features/journal/presentation/bloc/journal_view/journal_view_bloc.dart'
    as _i478;
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_bloc.dart'
    as _i160;
import 'package:my_flutter_app/shared/data/datasources/journal_local_datasource.dart'
    as _i424;
import 'package:my_flutter_app/shared/data/repositories_impl/journal_repository_impl.dart'
    as _i705;
import 'package:my_flutter_app/shared/domain/repositories/journal_repository.dart'
    as _i690;
import 'package:my_flutter_app/shared/domain/usecases/cleanup_orphaned_files.dart'
    as _i600;
import 'package:my_flutter_app/shared/domain/usecases/create_journal.dart'
    as _i808;
import 'package:my_flutter_app/shared/domain/usecases/delete_journal.dart'
    as _i682;
import 'package:my_flutter_app/shared/domain/usecases/delete_journal_with_files.dart'
    as _i308;
import 'package:my_flutter_app/shared/domain/usecases/get_journal_by_id.dart'
    as _i368;
import 'package:my_flutter_app/shared/domain/usecases/get_journals.dart'
    as _i654;
import 'package:my_flutter_app/shared/domain/usecases/search_journals.dart'
    as _i1017;
import 'package:my_flutter_app/shared/domain/usecases/update_journal.dart'
    as _i513;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i1035.ImagePathService>(() => _i1035.ImagePathService());
    gh.factory<_i658.FileStorageService>(() => _i658.FileStorageService());
    gh.factory<_i193.ImagePickerService>(() => _i193.ImagePickerService());
    gh.factory<_i1002.AppTabController>(() => _i1002.AppTabController());
    gh.singleton<_i607.DatabaseHelper>(() => _i607.DatabaseHelper.new());
    gh.singleton<_i805.GooglePlacesService>(() => _i805.GooglePlacesService());
    gh.lazySingleton<_i870.JournalChangeNotifier>(
      () => _i870.JournalChangeNotifier(),
    );
    gh.factory<_i424.JournalLocalDataSource>(
      () => _i424.JournalLocalDataSourceImpl(),
    );
    gh.factory<_i690.JournalRepository>(
      () => _i705.JournalRepositoryImpl(
        localDataSource: gh<_i424.JournalLocalDataSource>(),
        fileStorageService: gh<_i658.FileStorageService>(),
      ),
    );
    gh.factory<_i750.LocationSearchService>(
      () => _i750.LocationSearchService(gh<_i805.GooglePlacesService>()),
    );
    gh.factory<_i308.DeleteJournalWithFiles>(
      () => _i308.DeleteJournalWithFiles(
        gh<_i690.JournalRepository>(),
        gh<_i658.FileStorageService>(),
      ),
    );
    gh.factory<_i600.CleanupOrphanedFiles>(
      () => _i600.CleanupOrphanedFiles(
        gh<_i690.JournalRepository>(),
        gh<_i658.FileStorageService>(),
      ),
    );
    gh.factory<_i1017.SearchJournals>(
      () => _i1017.SearchJournals(gh<_i690.JournalRepository>()),
    );
    gh.factory<_i654.GetJournals>(
      () => _i654.GetJournals(gh<_i690.JournalRepository>()),
    );
    gh.factory<_i808.CreateJournal>(
      () => _i808.CreateJournal(gh<_i690.JournalRepository>()),
    );
    gh.factory<_i513.UpdateJournal>(
      () => _i513.UpdateJournal(gh<_i690.JournalRepository>()),
    );
    gh.factory<_i682.DeleteJournal>(
      () => _i682.DeleteJournal(gh<_i690.JournalRepository>()),
    );
    gh.factory<_i368.GetJournalById>(
      () => _i368.GetJournalById(gh<_i690.JournalRepository>()),
    );
    gh.factory<_i1036.ComposeBloc>(
      () => _i1036.ComposeBloc(
        gh<_i808.CreateJournal>(),
        gh<_i368.GetJournalById>(),
        gh<_i513.UpdateJournal>(),
      ),
    );
    gh.factory<_i794.LocationPickerBloc>(
      () => _i794.LocationPickerBloc(gh<_i750.LocationSearchService>()),
    );
    gh.factory<_i160.MemoryBloc>(
      () => _i160.MemoryBloc(getJournals: gh<_i654.GetJournals>()),
    );
    gh.factory<_i478.JournalViewBloc>(
      () => _i478.JournalViewBloc(
        getJournalById: gh<_i368.GetJournalById>(),
        deleteJournal: gh<_i682.DeleteJournal>(),
      ),
    );
    return this;
  }
}
