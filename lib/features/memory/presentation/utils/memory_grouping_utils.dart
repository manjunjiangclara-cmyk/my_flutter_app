import 'package:my_flutter_app/features/memory/presentation/bloc/memory_state.dart';
import 'package:my_flutter_app/features/memory/presentation/models/memory_card_model.dart';

/// Utility class for grouping memories by month and year
class MemoryGroupingUtils {
  MemoryGroupingUtils._();

  /// Groups memories by month and year combination using MonthYearKey
  /// Returns a map where key is MonthYearKey and value is list of memories
  static Map<MonthYearKey, List<MemoryCardModel>> groupMemoriesByMonthYear(
    List<MemoryCardModel> memories,
  ) {
    final Map<MonthYearKey, List<MemoryCardModel>> groupedMemories = {};

    for (final memory in memories) {
      try {
        final monthYearKey = MonthYearKey.fromDateTime(memory.date);
        groupedMemories.putIfAbsent(monthYearKey, () => []).add(memory);
      } catch (e) {
        // Skip memories with invalid dates
        continue;
      }
    }

    // Sort each group by date (newest first)
    for (final group in groupedMemories.values) {
      try {
        group.sort((a, b) => b.date.compareTo(a.date));
      } catch (e) {
        // Skip sorting if there are date comparison issues
        continue;
      }
    }

    return groupedMemories;
  }

  /// Gets sorted month-year keys (newest first)
  static List<MonthYearKey> getSortedMonthYearKeys(
    Map<MonthYearKey, List<MemoryCardModel>> groupedMemories,
  ) {
    final keys = groupedMemories.keys.toList();
    keys.sort((a, b) {
      // Sort by year first, then by month (newest first)
      if (a.year != b.year) {
        return b.year.compareTo(a.year);
      }
      return b.month.compareTo(a.month);
    });
    return keys;
  }
}
