import 'package:intl/intl.dart';

String formatMessageTime(DateTime time) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final date = DateTime(time.year, time.month, time.day);

  if (date == today) {
    return DateFormat('HH:mm').format(time);
  } else if (now.difference(date).inDays < 7 && date.isAfter(now.subtract(Duration(days: now.weekday)))) {
    return '${DateFormat('EEEE').format(time)}, ${DateFormat('HH:mm').format(time)}';
  } else if (time.year == now.year) {
    return DateFormat('dd/MM').format(time);
  } else {
    return DateFormat('dd/MM/yyyy').format(time);
  }
}
