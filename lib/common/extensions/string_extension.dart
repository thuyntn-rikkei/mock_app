import 'package:collection/collection.dart';

extension StringExtension on String? {
  static const int validatePhoneLength = 10;
  static const int maxLengthPrefixEmail = 64;
  static const int maxLengthSuffixEmail = 255;

  bool get isValidEmail {
    if (this == null || this!.isEmpty) return false;
    return RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
        ).hasMatch(this!.trim()) &&
        isValidLengthEmail;
  }

  bool get isValidLengthEmail {
    if (this == null || this!.isEmpty) return false;
    if (this!.contains("@")) {
      return this!.trim().split("@")[0].length <= maxLengthPrefixEmail &&
          this!.trim().split("@")[1].length <= maxLengthSuffixEmail;
    } else {
      return false;
    }
  }

  bool get isValidFormatEmail {
    if (this == null || this!.isEmpty) return false;
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this!.trim());
  }

  bool get isValidPhone {
    if (this == null) return false;
    return RegExp(
          r'^(0?)(3[2-9]|5[6|8|9]|7[0|6-9]|8[0-6|8|9]|9[0-4|6-9])[0-9]{7}$',
        ).hasMatch(this!.trim()) &&
        this!.trim().length == validatePhoneLength;
  }

  String get formatSpacePhoneNumber {
    String value = this!;
    List<String> splitString = value.split('');
    [3, 7].map((e) => splitString.insert(e, ' ')).toList();
    String concatString = splitString.join('');
    return concatString;
  }

  String formatPhoneNumber(String value) {
    var regExp = RegExp(r'^(\d{0,3})(\d{0,3})(\d{0,4})');
    var matches = regExp.firstMatch(value);

    var ver1 = '${matches?.group(1)} ${matches?.group(2)} ${matches?.group(3)}';
    return ver1;
  }

  int codeColorToHexColor() {
    String hexColor = this!.replaceAll("#", "");
    hexColor = "0xff$hexColor";
    return int.tryParse(hexColor)!;
  }

// upper first letter of string
  String get capitalizeFirstLetter {
    if (this == null || this!.isEmpty) return '';
    return '${this![0].toUpperCase()}${this!.substring(1)}';
  }

  //upper first letter of each word
  String capitalizeFirstLetterOfEachWord() {
    if (this == null || this!.isEmpty) return '';
    return this!.split(" ").map((str) => str.capitalizeFirstLetter).join(" ");
  }

  bool containsOrFalse(String? url) {
    if (this == null || url == null) return false;
    return this!.contains(url);
  }

  String convertFullNameToAvatarText() {
    final name = this?.split(" ").lastOrNull;
    if (name == null || name.isEmpty) return "";
    return name.substring(0, 1).toUpperCase();
  }

  // remove - symbol, and to lower case string
  String get removeDashSymbol {
    if (this == null || this!.isEmpty) return '';
    return this!.replaceAll("-", "").toLowerCase();
  }

  String toStringOrEmpty() {
    return this == null ? '' : toString();
  }

  String? replaceNamedArgs({Map<String, String>? args}) {
    if (args == null || args.isEmpty) return this;
    String? result = this;
    args.forEach(
      (String key, String value) =>
          result = result?.replaceAll(RegExp('{$key}'), value),
    );
    return result;
  }
}

extension StringNonNullableExtension on String {
  String useCorrectEllipsis() {
    return replaceAll('', '\u200B');
  }
}

extension OptionalStringExtension on String? {
  bool isNullOrEmpty() {
    return this == null || this!.isEmpty;
  }
}
