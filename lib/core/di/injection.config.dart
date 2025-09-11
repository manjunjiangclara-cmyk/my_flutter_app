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
import 'package:my_flutter_app/features/compose/presentation/bloc/compose_bloc.dart'
    as _i1036;
import 'package:my_flutter_app/features/journal/data/datasources/journal_local_datasource.dart'
    as _i377;
import 'package:my_flutter_app/features/journal/data/repositories_impl/journal_repository_impl.dart'
    as _i828;
import 'package:my_flutter_app/features/journal/domain/repositories/journal_repository.dart'
    as _i116;
import 'package:my_flutter_app/features/journal/domain/usecases/get_journal_by_id.dart'
    as _i521;
import 'package:my_flutter_app/features/journal/presentation/bloc/journal_view/journal_view_bloc.dart'
    as _i478;
import 'package:my_flutter_app/features/memory/presentation/bloc/memory_bloc.dart'
    as _i160;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.factory<_i1002.AppTabController>(() => _i1002.AppTabController());
    gh.factory<_i377.JournalLocalDataSourceImpl>(
      () => _i377.JournalLocalDataSourceImpl(),
    );
    gh.factory<_i160.MemoryBloc>(() => _i160.MemoryBloc());
    gh.factory<_i1036.ComposeBloc>(() => _i1036.ComposeBloc());
    gh.singleton<_i607.DatabaseHelper>(() => _i607.DatabaseHelper.new());
    gh.factory<_i521.GetJournalById>(
      () => _i521.GetJournalById(gh<_i116.JournalRepository>()),
    );
    gh.factory<_i828.JournalRepositoryImpl>(
      () => _i828.JournalRepositoryImpl(
        localDataSource: gh<_i377.JournalLocalDataSource>(),
      ),
    );
    gh.factory<_i478.JournalViewBloc>(
      () => _i478.JournalViewBloc(getJournalById: gh<_i521.GetJournalById>()),
    );
    return this;
  }
}
