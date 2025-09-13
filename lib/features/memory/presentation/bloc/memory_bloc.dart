import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:my_flutter_app/core/bloc/base_bloc.dart';
import 'package:my_flutter_app/core/usecase/usecase.dart';
import 'package:my_flutter_app/core/utils/date_formatter.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';
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

    // Load initial data
    add(const MemoryLoadRequested());
  }

  /// Maps a Journal entity to MemoryCardModel for UI display
  MemoryCardModel _mapJournalToMemoryCard(Journal journal) {
    // Format date as "EEE, MMMM d" (e.g., "Thu, August 28")
    final formattedDate = DateFormatter.formatDate(
      journal.createdAt,
      format: 'EEE, MMMM d',
    );

    // Use first image URL if available, otherwise use default
    final imageUrl = journal.imageUrls.isNotEmpty
        ? journal.imageUrls.first
        : null;

    // Truncate content if too long for description
    final description = journal.content.length > 100
        ? '${journal.content.substring(0, 100)}...'
        : journal.content;

    return MemoryCardModel(
      journalId: journal.id,
      date: formattedDate,
      location: journal.location ?? 'Unknown',
      tags: journal.tags,
      description: description,
      imageUrl: imageUrl,
    );
  }

  void _onLoadRequested(
    MemoryLoadRequested event,
    Emitter<MemoryState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    final result = await _getJournals(NoParams());

    handleUseCaseResult(
      result,
      (journals) {
        final memoryCards = journals.map(_mapJournalToMemoryCard).toList();
        emit(
          state.copyWith(
            memories: memoryCards,
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
        emit(
          state.copyWith(
            memories: memoryCards,
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
    emit(state.copyWith(filterTag: event.tag));
  }

  void _onFilterCleared(MemoryFilterCleared event, Emitter<MemoryState> emit) {
    emit(state.copyWith(filterTag: null));
  }

  void _onSearchRequested(
    MemorySearchRequested event,
    Emitter<MemoryState> emit,
  ) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
