import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_flutter_app/core/utils/base_bloc.dart';
import 'package:my_flutter_app/core/utils/performance_monitor.dart';
import 'package:my_flutter_app/core/utils/usecase.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';
import 'package:my_flutter_app/features/memory/presentation/utils/memory_grouping_utils.dart';
import 'package:my_flutter_app/shared/domain/entities/journal.dart';
import 'package:my_flutter_app/shared/domain/usecases/get_journals.dart';

import 'memory_event.dart';
import 'memory_state.dart';

/// BLoC for managing memory screen state and business logic
@injectable
class MemoryBloc extends BaseBloc<MemoryEvent, MemoryState> {
  final GetJournals _getJournals;

  MemoryBloc({required GetJournals getJournals})
    : _getJournals = getJournals,
      super(const MemoryState()) {
    on<MemoryLoadRequested>(_onLoadRequested);
    on<MemoryRefreshRequested>(_onRefreshRequested);
    on<MemoryFilterByTagRequested>(_onFilterByTagRequested);
    on<MemoryFilterCleared>(_onFilterCleared);
    on<MemorySearchRequested>(_onSearchRequested);

    // Don't load data automatically - let the UI trigger it when needed
  }

  /// Maps a Journal entity to MemoryCardModel for UI display
  MemoryCardModel _mapJournalToMemoryCard(Journal journal) {
    // Truncate content if too long for description
    final description = journal.content.length > 100
        ? '${journal.content.substring(0, 100)}...'
        : journal.content;

    return MemoryCardModel(
      journalId: journal.id,
      date: journal.createdAt,
      location: journal.location,
      tags: journal.tags,
      description: description,
      imagePaths: journal.imagePaths.isNotEmpty ? journal.imagePaths : const [],
    );
  }

  void _onLoadRequested(
    MemoryLoadRequested event,
    Emitter<MemoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    PerformanceMonitor.startTiming('Get Journals Query');
    final result = await _getJournals(NoParams());
    PerformanceMonitor.endTiming('Get Journals Query');

    handleUseCaseResult(
      result,
      (journals) {
        final memoryCards = journals.map(_mapJournalToMemoryCard).toList();
        final groupedMemories = _groupMemoriesByMonthYear(memoryCards);
        final sortedKeys = _getSortedGroupKeys(groupedMemories);

        emit(
          state.copyWith(
            memories: memoryCards,
            groupedMemories: groupedMemories,
            sortedGroupKeys: sortedKeys,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
      onFailure: (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: mapFailureToMessageWithContext(
            failure,
            'Failed to load memories',
          ),
        ),
      ),
    );
  }

  void _onRefreshRequested(
    MemoryRefreshRequested event,
    Emitter<MemoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getJournals(NoParams());

    handleUseCaseResult(
      result,
      (journals) {
        final memoryCards = journals.map(_mapJournalToMemoryCard).toList();
        final groupedMemories = _groupMemoriesByMonthYear(memoryCards);
        final sortedKeys = _getSortedGroupKeys(groupedMemories);

        emit(
          state.copyWith(
            memories: memoryCards,
            groupedMemories: groupedMemories,
            sortedGroupKeys: sortedKeys,
            isLoading: false,
            errorMessage: null,
          ),
        );
      },
      onFailure: (failure) => emit(
        state.copyWith(
          isLoading: false,
          errorMessage: mapFailureToMessageWithContext(
            failure,
            'Failed to refresh memories',
          ),
        ),
      ),
    );
  }

  void _onFilterByTagRequested(
    MemoryFilterByTagRequested event,
    Emitter<MemoryState> emit,
  ) {
    final filteredMemories = _filterMemories(
      state.memories,
      event.tag,
      state.searchQuery,
    );
    final groupedMemories = _groupMemoriesByMonthYear(filteredMemories);
    final sortedKeys = _getSortedGroupKeys(groupedMemories);

    emit(
      state.copyWith(
        filterTag: event.tag,
        groupedMemories: groupedMemories,
        sortedGroupKeys: sortedKeys,
      ),
    );
  }

  void _onFilterCleared(MemoryFilterCleared event, Emitter<MemoryState> emit) {
    final filteredMemories = _filterMemories(
      state.memories,
      null,
      state.searchQuery,
    );
    final groupedMemories = _groupMemoriesByMonthYear(filteredMemories);
    final sortedKeys = _getSortedGroupKeys(groupedMemories);

    emit(
      state.copyWith(
        filterTag: null,
        groupedMemories: groupedMemories,
        sortedGroupKeys: sortedKeys,
      ),
    );
  }

  void _onSearchRequested(
    MemorySearchRequested event,
    Emitter<MemoryState> emit,
  ) {
    final filteredMemories = _filterMemories(
      state.memories,
      state.filterTag,
      event.query,
    );
    final groupedMemories = _groupMemoriesByMonthYear(filteredMemories);
    final sortedKeys = _getSortedGroupKeys(groupedMemories);

    emit(
      state.copyWith(
        searchQuery: event.query,
        groupedMemories: groupedMemories,
        sortedGroupKeys: sortedKeys,
      ),
    );
  }

  // Helper methods for filtering, grouping and sorting
  List<MemoryCardModel> _filterMemories(
    List<MemoryCardModel> memories,
    String? filterTag,
    String? searchQuery,
  ) {
    if (filterTag == null && (searchQuery == null || searchQuery.isEmpty)) {
      return memories;
    }

    return memories
        .where((memory) => _matchesFilters(memory, filterTag, searchQuery))
        .toList();
  }

  bool _matchesFilters(
    MemoryCardModel memory,
    String? filterTag,
    String? searchQuery,
  ) {
    // Apply tag filter
    if (filterTag != null && filterTag.isNotEmpty) {
      if (!memory.tags.contains(filterTag)) {
        return false;
      }
    }

    // Apply search query
    if (searchQuery != null && searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      final matchesDescription = memory.description.toLowerCase().contains(
        query,
      );
      final matchesLocation =
          memory.location?.toLowerCase().contains(query) ?? false;
      final matchesTags = memory.tags.any(
        (tag) => tag.toLowerCase().contains(query),
      );

      if (!matchesDescription && !matchesLocation && !matchesTags) {
        return false;
      }
    }

    return true;
  }

  Map<MonthYearKey, List<MemoryCardModel>> _groupMemoriesByMonthYear(
    List<MemoryCardModel> memories,
  ) {
    return MemoryGroupingUtils.groupMemoriesByMonthYear(memories);
  }

  List<MonthYearKey> _getSortedGroupKeys(
    Map<MonthYearKey, List<MemoryCardModel>> groupedMemories,
  ) {
    return MemoryGroupingUtils.getSortedMonthYearKeys(groupedMemories);
  }
}
