// date_time_formatter.dart
import 'package:intl/intl.dart';

class DateTimeFormatter {
  static String formatMessageTime(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = date.toLocal();

    if (messageDate.isAfter(today)) {
      return _formatTime(messageDate);
    } else if (messageDate.isAfter(today.subtract(const Duration(days: 1)))) {
      return 'Yesterday ${_formatTime(messageDate)}';
    } else if (now.difference(messageDate).inDays < 7) {
      return '${_formatDay(messageDate)} ${_formatTime(messageDate)}';
    } else {
      return '${_formatFullDate(messageDate)} ${_formatTime(messageDate)}';
    }
  }

  static String formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (date.isToday()) {
      return 'Today';
    } else if (date.isYesterday()) {
      return 'Yesterday';
    } else if (difference < 7) {
      return _formatDay(date);
    } else {
      return _formatFullDate(date);
    }
  }

  static bool isDifferentDay(DateTime previous, DateTime current) {
    return previous.day != current.day ||
        previous.month != current.month ||
        previous.year != current.year;
  }

  // Helper methods
  static String _formatTime(DateTime date) =>
      DateFormat('hh:mm a').format(date);
  static String _formatDay(DateTime date) => DateFormat('EEEE').format(date);
  static String _formatFullDate(DateTime date) =>
      DateFormat('MMM d, y').format(date);
}

extension DateHelpers on DateTime {
  bool isToday() {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool isYesterday() {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }
}
