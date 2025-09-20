import 'package:intl/intl.dart';

class DateFormatter {
  // Abbreviated weekdays for compact display
  static const List<String> _weekdaysAbbr = [
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ];

  // Single source of truth for month data
  static const List<String> _months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  // Abbreviated months for compact display
  static const List<String> _monthsAbbr = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  // Helper method to get month number (1-based)
  static int _getMonthNumber(String monthName) {
    final index = _months.indexOf(monthName);
    return index >= 0 ? index + 1 : 1; // Return 1 as fallback
  }

  // Helper method to get month name by number (1-based)
  static String _getMonthName(int monthNumber) {
    final index = monthNumber - 1;
    return (index >= 0 && index < _months.length) ? _months[index] : _months[0];
  }

  // Private constructor to prevent instantiation
  DateFormatter._();

  // Basic formatting methods using intl package
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format).format(date);
  }

  static String formatDateTime(
    DateTime dateTime, {
    String format = 'yyyy-MM-dd HH:mm:ss',
  }) {
    return DateFormat(format).format(dateTime);
  }

  static String formatTime(DateTime time, {String format = 'HH:mm'}) {
    return DateFormat(format).format(time);
  }

  // Relative time formatting
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }

  // Day and month name getters using intl package
  static String getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static String getMonthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  // Specific date formatting methods
  static String getTodayFormatted() {
    final today = DateTime.now();
    return DateFormat('MMMM d, yyyy').format(today);
  }

  /// Formats a date in the journal view style (e.g., "Thu, Sep 18")
  static String formatJournalDate(DateTime date) {
    final weekday = _weekdaysAbbr[date.weekday - 1];
    final month = _monthsAbbr[date.month - 1];
    final day = date.day;

    return '$weekday, $month $day';
  }

  /// Extracts month and year from DateTime for grouping
  /// Input: DateTime -> Output: "August, 2025"
  static String? extractMonthYear(DateTime date) {
    try {
      final month = _getMonthName(date.month);
      final year = date.year;
      return '$month, $year';
    } catch (e) {
      return null;
    }
  }

  /// Gets sorted month-year keys (newest first) for grouping
  static List<String> getSortedMonthYearKeys(
    Map<String, List<dynamic>> groupedItems,
  ) {
    final keys = groupedItems.keys.toList();
    keys.sort(_compareMonthYearKeys);
    return keys;
  }

  /// Formats month and year for display (e.g., "August, 2024")
  static String formatMonthYear(int month, int year) {
    final monthName = (month >= 1 && month <= 12)
        ? _months[month - 1]
        : 'Unknown';
    return '$monthName, $year';
  }

  // Private helper method for sorting month-year keys
  static int _compareMonthYearKeys(String a, String b) {
    final aParts = a.split(', ');
    final bParts = b.split(', ');

    if (aParts.length >= 2 && bParts.length >= 2) {
      final aYear = int.tryParse(aParts[1]) ?? 0;
      final bYear = int.tryParse(bParts[1]) ?? 0;

      if (aYear != bYear) {
        return bYear.compareTo(aYear); // Newest year first
      }

      // If same year, sort by month
      final aMonth = _getMonthNumber(aParts[0]);
      final bMonth = _getMonthNumber(bParts[0]);

      return bMonth.compareTo(aMonth); // Newest month first
    }

    return 0;
  }
}
