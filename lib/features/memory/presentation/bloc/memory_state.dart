import 'package:equatable/equatable.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';

/// Base class for all memory states
abstract class MemoryState extends Equatable {
  const MemoryState();

  @override
  List<Object?> get props => [];
}

/// Initial state when memory screen is first loaded
class MemoryInitial extends MemoryState {
  const MemoryInitial();
}

/// State when memories are being loaded
class MemoryLoading extends MemoryState {
  const MemoryLoading();
}

/// State when memories are loaded successfully
class MemoryLoaded extends MemoryState {
  final List<MemoryCardModel> memories;
  final String? searchQuery;
  final String? filterTag;

  const MemoryLoaded({
    required this.memories,
    this.searchQuery,
    this.filterTag,
  });

  /// Get filtered memories based on search query and tag filter
  List<MemoryCardModel> get filteredMemories {
    List<MemoryCardModel> filtered = memories;

    // Apply tag filter
    if (filterTag != null && filterTag!.isNotEmpty) {
      filtered = filtered
          .where((memory) => memory.tags.contains(filterTag!))
          .toList();
    }

    // Apply search query
    if (searchQuery != null && searchQuery!.isNotEmpty) {
      final query = searchQuery!.toLowerCase();
      filtered = filtered.where((memory) {
        return memory.description.toLowerCase().contains(query) ||
            memory.location.toLowerCase().contains(query) ||
            memory.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
    }

    return filtered;
  }

  /// Copy with method for immutable state updates
  MemoryLoaded copyWith({
    List<MemoryCardModel>? memories,
    String? searchQuery,
    String? filterTag,
  }) {
    return MemoryLoaded(
      memories: memories ?? this.memories,
      searchQuery: searchQuery ?? this.searchQuery,
      filterTag: filterTag ?? this.filterTag,
    );
  }

  @override
  List<Object?> get props => [memories, searchQuery, filterTag];
}

/// State when memory operation fails
class MemoryError extends MemoryState {
  final String message;

  const MemoryError(this.message);

  @override
  List<Object?> get props => [message];
}

/// State when memory is being added
class MemoryAdding extends MemoryState {
  final List<MemoryCardModel> memories;

  const MemoryAdding({required this.memories});

  @override
  List<Object?> get props => [memories];
}

/// State when memory is being updated
class MemoryUpdating extends MemoryState {
  final List<MemoryCardModel> memories;

  const MemoryUpdating({required this.memories});

  @override
  List<Object?> get props => [memories];
}

/// State when memory is being deleted
class MemoryDeleting extends MemoryState {
  final List<MemoryCardModel> memories;

  const MemoryDeleting({required this.memories});

  @override
  List<Object?> get props => [memories];
}
