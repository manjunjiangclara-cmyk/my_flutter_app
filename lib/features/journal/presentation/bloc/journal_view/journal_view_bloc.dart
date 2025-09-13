import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../shared/domain/usecases/get_journal_by_id.dart';
import 'journal_view_event.dart';
import 'journal_view_state.dart';

@injectable
class JournalViewBloc extends Bloc<JournalViewEvent, JournalViewState> {
  final GetJournalById getJournalById;

  JournalViewBloc({required this.getJournalById})
    : super(const JournalInitial()) {
    on<LoadJournal>(_onLoadJournal);
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
}
