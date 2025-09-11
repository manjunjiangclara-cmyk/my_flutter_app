import 'package:bloc/bloc.dart';
import 'package:my_flutter_app/features/memory/presentation/constants/memory_constants.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';

import 'memory_event.dart';
import 'memory_state.dart';

/// BLoC for managing memory screen state and business logic
class MemoryBloc extends Bloc<MemoryEvent, MemoryState> {
  MemoryBloc() : super(const MemoryInitial()) {
    on<MemoryLoadRequested>(_onLoadRequested);
    on<MemoryRefreshRequested>(_onRefreshRequested);
    on<MemoryFilterByTagRequested>(_onFilterByTagRequested);
    on<MemoryFilterCleared>(_onFilterCleared);
    on<MemorySearchRequested>(_onSearchRequested);

    // Load initial data
    add(const MemoryLoadRequested());
  }

  // Mock data - in a real app, this would come from a repository
  final List<MemoryCardModel> _mockMemories = [
    MemoryCardModel(
      journalId: 'journal_1',
      date: 'Thu, August 28',
      location: 'Melbourne',
      tags: <String>['Life', 'Travel'],
      description:
          'Praeterea, ex culpa non invenies unum aut non accusatis unum. Et nihil inuitam. Nemo nocere tibi erit, et non inimicos, et ne illa',
    ),
    MemoryCardModel(
      journalId: 'journal_2',
      date: 'Wed, August 27',
      location: 'Melbourne',
      tags: <String>['Life', 'Travel'],
      description:
          'Praeterea, ex culpa non invenies unum aut non accusatis unum. Et nihil inuitam. Nemo nocere tibi erit, et non inimicos, et ne illa',
    ),
    MemoryCardModel(
      journalId: 'journal_3',
      date: 'Tue, August 26',
      location: 'Sydney',
      tags: <String>['Work', 'Conference'],
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
    ),
    MemoryCardModel(
      journalId: 'journal_4',
      date: 'Mon, August 25',
      location: 'Brisbane',
      tags: <String>['Friends', 'Adventure'],
      description:
          'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
    ),
  ];

  void _onLoadRequested(
    MemoryLoadRequested event,
    Emitter<MemoryState> emit,
  ) async {
    emit(const MemoryLoading());

    try {
      // Simulate loading delay
      await Future.delayed(
        const Duration(milliseconds: MemoryConstants.loadDelayMs),
      );
      emit(MemoryLoaded(memories: _mockMemories));
    } catch (e) {
      emit(MemoryError('Failed to load memories: $e'));
    }
  }

  void _onRefreshRequested(
    MemoryRefreshRequested event,
    Emitter<MemoryState> emit,
  ) async {
    if (state is MemoryLoaded) {
      final currentState = state as MemoryLoaded;
      emit(currentState.copyWith());

      try {
        // Simulate refresh delay
        await Future.delayed(
          const Duration(milliseconds: MemoryConstants.refreshDelayMs),
        );
        emit(
          MemoryLoaded(
            memories: _mockMemories,
            searchQuery: currentState.searchQuery,
            filterTag: currentState.filterTag,
          ),
        );
      } catch (e) {
        emit(MemoryError('Failed to refresh memories: $e'));
      }
    }
  }

  void _onFilterByTagRequested(
    MemoryFilterByTagRequested event,
    Emitter<MemoryState> emit,
  ) {
    if (state is MemoryLoaded) {
      final currentState = state as MemoryLoaded;
      emit(currentState.copyWith(filterTag: event.tag));
    }
  }

  void _onFilterCleared(MemoryFilterCleared event, Emitter<MemoryState> emit) {
    if (state is MemoryLoaded) {
      final currentState = state as MemoryLoaded;
      emit(currentState.copyWith(filterTag: null));
    }
  }

  void _onSearchRequested(
    MemorySearchRequested event,
    Emitter<MemoryState> emit,
  ) {
    if (state is MemoryLoaded) {
      final currentState = state as MemoryLoaded;
      emit(currentState.copyWith(searchQuery: event.query));
    }
  }
}
