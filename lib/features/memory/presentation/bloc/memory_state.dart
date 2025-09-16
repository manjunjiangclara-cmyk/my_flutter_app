import 'package:equatable/equatable.dart';
import 'package:my_flutter_app/core/utils/date_formatter.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';

/// Key for grouping memories by month and year
class MonthYearKey extends Equatable {
  final int month;
  final int year;

  const MonthYearKey({required this.month, required this.year});

  @override
  List<Object> get props => [month, year];

  @override
  String toString() => 'MonthYearKey(month: $month, year: $year)';

  /// Get display string for UI (e.g., "August, 2024")
  String get displayString {
    return DateFormatter.formatMonthYear(month, year);
  }

  /// Create from DateTime
  factory MonthYearKey.fromDateTime(DateTime date) {
    return MonthYearKey(month: date.month, year: date.year);
  }
}

/// Single state class for all memory operations
class MemoryState extends Equatable {
  final List<MemoryCardModel> memories;
  final Map<MonthYearKey, List<MemoryCardModel>> groupedMemories;
  final List<MonthYearKey> sortedGroupKeys;
  final bool isLoading;
  final String? errorMessage;
  final String? searchQuery;
  final String? filterTag;

  const MemoryState({
    this.memories = const [],
    this.groupedMemories = const {},
    this.sortedGroupKeys = const [],
    this.isLoading = false,
    this.errorMessage,
    this.searchQuery,
    this.filterTag,
  });

  /// Copy with method for immutable state updates
  MemoryState copyWith({
    List<MemoryCardModel>? memories,
    Map<MonthYearKey, List<MemoryCardModel>>? groupedMemories,
    List<MonthYearKey>? sortedGroupKeys,
    bool? isLoading,
    String? errorMessage,
    String? searchQuery,
    String? filterTag,
  }) {
    return MemoryState(
      memories: memories ?? this.memories,
      groupedMemories: groupedMemories ?? this.groupedMemories,
      sortedGroupKeys: sortedGroupKeys ?? this.sortedGroupKeys,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      filterTag: filterTag ?? this.filterTag,
    );
  }

  @override
  List<Object?> get props => [
    memories,
    groupedMemories,
    sortedGroupKeys,
    isLoading,
    errorMessage,
    searchQuery,
    filterTag,
  ];
}
