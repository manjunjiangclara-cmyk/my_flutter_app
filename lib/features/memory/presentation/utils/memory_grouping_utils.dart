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
      final monthYear = _extractMonthYear(memory.date);
      if (monthYear != null) {
        groupedMemories.putIfAbsent(monthYear, () => []).add(memory);
      }
    }

    // Sort each group by date (newest first)
    for (final group in groupedMemories.values) {
      group.sort((a, b) => _parseDate(b.date).compareTo(_parseDate(a.date)));
    }

    return groupedMemories;
  }

  /// Extracts month and year from formatted date string
  /// Input: "Thu, August 28" -> Output: "August, 2025"
  static String? _extractMonthYear(String dateString) {
    try {
      // Parse the date string to extract month and year
      final parts = dateString.split(', ');
      if (parts.length >= 2) {
        final monthDay = parts[1].split(' ');
        if (monthDay.length >= 2) {
          final month = monthDay[0];
          // For now, we'll use the current year since the date format doesn't include year
          // In a real app, you'd want to store the full date in the model
          final currentYear = DateTime.now().year;
          return '$month, $currentYear';
        }
      }
    } catch (e) {
      // If parsing fails, return null
    }
    return null;
  }

  /// Parses the date string for sorting purposes
  /// This is a simplified parser - in production you'd want more robust date handling
  static DateTime _parseDate(String dateString) {
    try {
      final parts = dateString.split(', ');
      if (parts.length >= 2) {
        final monthDay = parts[1].split(' ');
        if (monthDay.length >= 2) {
          final month = monthDay[0];
          final day = int.tryParse(monthDay[1]) ?? 1;

          // Map month names to numbers
          final monthMap = {
            'January': 1,
            'February': 2,
            'March': 3,
            'April': 4,
            'May': 5,
            'June': 6,
            'July': 7,
            'August': 8,
            'September': 9,
            'October': 10,
            'November': 11,
            'December': 12,
          };

          final monthNumber = monthMap[month] ?? 1;
          final currentYear = DateTime.now().year;

          return DateTime(currentYear, monthNumber, day);
        }
      }
    } catch (e) {
      // If parsing fails, return current date
    }
    return DateTime.now();
  }

  /// Gets sorted month-year keys (newest first)
  static List<String> getSortedMonthYearKeys(
    Map<String, List<MemoryCardModel>> groupedMemories,
  ) {
    final keys = groupedMemories.keys.toList();
    keys.sort((a, b) {
      // Sort by year first, then by month
      final aParts = a.split(', ');
      final bParts = b.split(', ');

      if (aParts.length >= 2 && bParts.length >= 2) {
        final aYear = int.tryParse(aParts[1]) ?? 0;
        final bYear = int.tryParse(bParts[1]) ?? 0;

        if (aYear != bYear) {
          return bYear.compareTo(aYear); // Newest year first
        }

        // If same year, sort by month
        final monthMap = {
          'January': 1,
          'February': 2,
          'March': 3,
          'April': 4,
          'May': 5,
          'June': 6,
          'July': 7,
          'August': 8,
          'September': 9,
          'October': 10,
          'November': 11,
          'December': 12,
        };

        final aMonth = monthMap[aParts[0]] ?? 1;
        final bMonth = monthMap[bParts[0]] ?? 1;

        return bMonth.compareTo(aMonth); // Newest month first
      }

      return 0;
    });

    return keys;
  }
}
