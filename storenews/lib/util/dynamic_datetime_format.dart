
import 'package:intl/intl.dart';

/// Formats a DateTime object to a String depending on how long ago the DateTime was.
String formatDateTimeDynamically(DateTime dateTime) {
  final currentDateTime = DateTime.now();

  if(dateTime.day == currentDateTime.day
      && dateTime.month == currentDateTime.month
      && dateTime.year == currentDateTime.year) {
    return DateFormat('HH:mm').format(dateTime);
  } else if(dateTime.year == currentDateTime.year) {
    return DateFormat('dd.MM. HH:mm').format(dateTime);
  } else {
    return DateFormat('dd.MM.yyyy').format(dateTime);
  }
}