import 'package:my_flutter_app/core/utils/date_formatter.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';

/// Utility class for grouping memories by month and year
class MemoryGroupingUtils {
  MemoryGroupingUtils._();

  /// Groups memories by month and year combination
  /// Returns a map where key is "Month, Year" format and value is list of memories
  static Map<String, List<MemoryCardModel>> groupMemoriesByMonthYear(
    List<MemoryCardModel> memories,
  ) {
    final Map<String, List<MemoryCardModel>> groupedMemories = {};

    for (final memory in memories) {
      final monthYear = DateFormatter.extractMonthYear(memory.date);
      if (monthYear != null) {
        groupedMemories.putIfAbsent(monthYear, () => []).add(memory);
      }
    }

    // Sort each group by date (newest first)
    for (final group in groupedMemories.values) {
      group.sort((a, b) => b.date.compareTo(a.date));
    }

    return groupedMemories;
  }

  /// Gets sorted month-year keys (newest first)
  static List<String> getSortedMonthYearKeys(
    Map<String, List<MemoryCardModel>> groupedMemories,
  ) {
    return DateFormatter.getSortedMonthYearKeys(groupedMemories);
  }
}
