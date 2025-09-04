import 'dart:async';

import '../../../domain/usecases/get_journal_by_id.dart';
import 'journal_view_event.dart';
import 'journal_view_state.dart';

class JournalViewBloc {
  final GetJournalById getJournalById;

  JournalViewBloc({required this.getJournalById});

  final StreamController<JournalViewState> _stateController =
      StreamController<JournalViewState>.broadcast();

  JournalViewState _state = JournalInitial();

  Stream<JournalViewState> get stream => _stateController.stream;
  JournalViewState get state => _state;

  void _emit(JournalViewState newState) {
    _state = newState;
    if (!_stateController.isClosed) {
      _stateController.add(newState);
    }
  }

  Future<void> add(JournalViewEvent event) async {
    if (event is LoadJournal) {
      _emit(JournalLoading());
      final result = await getJournalById(GetJournalByIdParams(event.id));
      result.fold(
        (failure) => _emit(JournalError(failure.message)),
        (journal) => _emit(JournalLoaded(journal)),
      );
    }
  }

  void dispose() {
    _stateController.close();
  }
}
