import 'package:easy_localization/easy_localization.dart';
import 'package:base_bloc_3/common/utils/date_time_format_pattern.dart';

class DateTimeUtilities {
  static DateTime? fromServerDateAndTime(String? date) {
    try {
      if (date == null) return null;
      return DateTime.parse(date);
    } catch (e) {
      return null;
    }
  }

  static String formatToDateTimeDisplay(DateTime date) {
    return DateFormat(DateTimeFormatPatternConstants.dateTimeFormat)
        .format(date);
  }

  static String? formatServerDateAndTime(DateTime? date) {
    if (date == null) {
      return null;
    }
    return date.toIso8601String();
  }

  static String formatToDateTimeDisplayTwoLine(DateTime date) {
    return DateFormat(DateTimeFormatPatternConstants.dateTimeFormatTwoLine)
        .format(date);
  }

  static String formatDate(DateTime date) {
    return DateFormat(DateTimeFormatPatternConstants.dateFormat).format(date);
  }

  static String formatDateDashStyle(DateTime date) {
    return DateFormat(DateTimeFormatPatternConstants.dateFormatDashStyle)
        .format(date);
  }

  static String formatDateYYYYMM(DateTime date) {
    return DateFormat(DateTimeFormatPatternConstants.dateFormatYYYYMM)
        .format(date);
  }

  static String formatDateTextJanPan(DateTime date) {
    return DateFormat(DateTimeFormatPatternConstants.dateFormatTextJapan)
        .format(date);
  }

  static String formatMinuteSecondFormat(DateTime date) {
    return DateFormat(DateTimeFormatPatternConstants.minuteSecondFormat)
        .format(date);
  }

  static DateTime? fromYYYYMMHyphenToDateTime(String? date) {
    if (date == null) return null;
    return DateFormat(DateTimeFormatPatternConstants.dateFormatYYYYMMHyphen)
        .parse(date);
  }

  static DateTime? fromYYYYMMToDateTime(String? date) {
    if (date == null) return null;
    return DateFormat(DateTimeFormatPatternConstants.dateFormatYYYYMM)
        .parse(date);
  }

  static DateTime? fromStringDateAndTime(String? date) {
    if (date == null || date.isEmpty) return null;

    return DateFormat(DateTimeFormatPatternConstants.dateFormatDateAndTime)
        .parse(date);
  }

  static DateTime? stringToDateTime(String? date) {
    if (date == null) return null;
    return DateTime.parse(date);
  }

  static DateTime? stringDateTimeDashStyle(String? date) {
    if (date == null || date.isEmpty) return null;
    return DateFormat(DateTimeFormatPatternConstants.dateFormatDashStyle)
        .parse(date);
  }

  static DateTime? stringToDate(String? date) {
    if (date == null) return null;
    return DateFormat(DateTimeFormatPatternConstants.dateFormat).parse(date);
  }

  static DateTime? stringToManufacturedDate(String? date) {
    try {
      return stringToDate(date);
    } catch (e) {
      return stringDateTimeDashStyle(date);
    }
  }

  static String? formatISOTime(DateTime? date) {
    if (date == null) {
      return null;
    }
    return DateFormat(DateTimeFormatPatternConstants.serverDateTimeFormat)
        .format(date);
  }

  static String? changeFormatISOToDateTime(String? date) {
    if (date == null) {
      return null;
    }
    final dateTimeFromServer = fromServerDateAndTime(date);
    if (dateTimeFromServer == null) {
      return null;
    }
    return formatToDateTimeDisplay(dateTimeFromServer);
  }
}
