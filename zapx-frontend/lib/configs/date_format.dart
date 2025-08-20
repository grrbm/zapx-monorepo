import 'package:intl/intl.dart';

String formatTime(String dateTimeString) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeString);
    // Don't convert UTC times to local time - display as selected
    if (dateTimeString.endsWith('Z')) {
      // Keep UTC time as is for display
      return DateFormat('h:mm a').format(dateTime); // 12-hour format with AM/PM
    } else {
      // Convert local times to local for display
      dateTime = dateTime.toLocal();
      return DateFormat('h:mm a').format(dateTime); // 12-hour format with AM/PM
    }
  } catch (e) {
    return 'Invalid date';
  }
}

String formatDate(String dateTimeString) {
  try {
    DateTime dateTime = DateTime.parse(dateTimeString).toLocal();
    return DateFormat(
      'MMMM d, y',
    ).format(dateTime); // Month name, date, and year
  } catch (e) {
    return 'Invalid date';
  }
}
