import 'package:equatable/equatable.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';

/// Single state class for all memory operations
class MemoryState extends Equatable {
  final List<MemoryCardModel> memories;
  final bool isLoading;
  final String? errorMessage;
  final String? searchQuery;
  final String? filterTag;

  const MemoryState({
    this.memories = const [],
    this.isLoading = false,
    this.errorMessage,
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
  MemoryState copyWith({
    List<MemoryCardModel>? memories,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    String? filterTag,
  }) {
    return MemoryState(
      memories: memories ?? this.memories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      filterTag: filterTag ?? this.filterTag,
    );
  }

  @override
  List<Object?> get props => [
    memories,
    isLoading,
    errorMessage,
    searchQuery,
    filterTag,
  ];
}
