import 'package:intl/intl.dart';

class DateFormatter {
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

  static String getDayOfWeek(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  static String getMonthName(DateTime date) {
    return DateFormat('MMMM').format(date);
  }

  /// Formats today's date in the format used by compose screens (e.g., "August 28, 2025")
  static String getTodayFormatted() {
    final today = DateTime.now();
    return DateFormat('MMMM d, yyyy').format(today);
  }

  /// Formats a date in the journal view style (e.g., "Thursday, August 28")
  static String formatJournalDate(DateTime date) {
    const months = [
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
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    final weekday = weekdays[date.weekday - 1];
    final month = months[date.month - 1];
    final day = date.day;

    return '$weekday, $month $day';
  }
}
