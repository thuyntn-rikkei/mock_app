import 'package:easy_localization/easy_localization.dart';

extension IntExtension on int {
  String get formatIntToPrice {
    final f = NumberFormat("###,###.###", "tr_TR");
    return f.format(truncate());
  }

  String get secondsToHHMMss {
    final duration = Duration(seconds: this);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)} : $twoDigitMinutes : $twoDigitSeconds";
  }

  String get secondsToMMss {
    final duration = Duration(seconds: this);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes);
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  String get addPointPrefix {
    if (this >= 0) {
      return "+$this";
    } else {
      return "$this";
    }
  }
}

extension IntNullable on int? {
  String toStringOrEmpty() {
    if (this == null) {
      return "";
    } else {
      return toString();
    }
  }

  String toCurrencyOrEmpty() {
    if (this == null) {
      return "";
    } else {
      return this!.formatIntToPrice;
    }
  }
}
