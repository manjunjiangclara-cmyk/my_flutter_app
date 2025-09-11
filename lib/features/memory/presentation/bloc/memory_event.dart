import 'package:equatable/equatable.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';

/// Base class for all memory events
abstract class MemoryEvent extends Equatable {
  const MemoryEvent();

  @override
  List<Object?> get props => [];
}

/// Event for loading memories
class MemoryLoadRequested extends MemoryEvent {
  const MemoryLoadRequested();
}

/// Event for refreshing memories
class MemoryRefreshRequested extends MemoryEvent {
  const MemoryRefreshRequested();
}

/// Event for adding a new memory
class MemoryAddRequested extends MemoryEvent {
  final MemoryCardModel memory;

  const MemoryAddRequested(this.memory);

  @override
  List<Object?> get props => [memory];
}

/// Event for updating an existing memory
class MemoryUpdateRequested extends MemoryEvent {
  final MemoryCardModel memory;

  const MemoryUpdateRequested(this.memory);

  @override
  List<Object?> get props => [memory];
}

/// Event for deleting a memory
class MemoryDeleteRequested extends MemoryEvent {
  final String journalId;

  const MemoryDeleteRequested(this.journalId);

  @override
  List<Object?> get props => [journalId];
}

/// Event for filtering memories by tag
class MemoryFilterByTagRequested extends MemoryEvent {
  final String tag;

  const MemoryFilterByTagRequested(this.tag);

  @override
  List<Object?> get props => [tag];
}

/// Event for clearing memory filters
class MemoryFilterCleared extends MemoryEvent {
  const MemoryFilterCleared();
}

/// Event for searching memories
class MemorySearchRequested extends MemoryEvent {
  final String query;

  const MemorySearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}
