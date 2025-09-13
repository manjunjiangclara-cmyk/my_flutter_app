import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/domain/usecases/delete_journal.dart'
    as delete_use_case;
import '../../../../../shared/domain/usecases/get_journal_by_id.dart';
import 'journal_view_event.dart';
import 'journal_view_state.dart';

@injectable
class JournalViewBloc extends Bloc<JournalViewEvent, JournalViewState> {
  final GetJournalById getJournalById;
  final delete_use_case.DeleteJournal deleteJournal;

  JournalViewBloc({required this.getJournalById, required this.deleteJournal})
    : super(const JournalInitial()) {
    on<LoadJournal>(_onLoadJournal);
    on<DeleteJournal>(_onDeleteJournal);
  }

  Future<void> _onLoadJournal(
    LoadJournal event,
    Emitter<JournalViewState> emit,
  ) async {
    emit(const JournalLoading());

    final result = await getJournalById(GetJournalByIdParams(event.id));
    result.fold(
      (failure) => emit(JournalError(failure.message)),
      (journal) => emit(JournalLoaded(journal)),
    );
  }

  Future<void> _onDeleteJournal(
    DeleteJournal event,
    Emitter<JournalViewState> emit,
  ) async {
    emit(const JournalDeleting());

    final result = await deleteJournal(
      delete_use_case.DeleteJournalParams(event.id),
    );
    result.fold(
      (failure) => emit(JournalError(failure.message)),
      (success) => emit(const JournalDeleted()),
    );
  }
}
