import 'package:base_bloc_3/import.dart';

bool hasMatchLengthPassword(String? pass) {
  if ((pass ?? "").trim().isEmpty) {
    return false;
  }
  return pass!.trim().length >= (PasswordConfig.minLength);
}

bool hasMatchTypePassword(String? pass) {
  if ((pass ?? "").isEmpty) {
    return false;
  }
  bool hasDigit = RegExp(r'[0-9]').hasMatch(pass!);
  bool hasLowercase = RegExp(r'[a-z]').hasMatch(pass);
  bool hasUppercase = RegExp(r'[A-Z]').hasMatch(pass);
  bool hasSpecialCharacter = !RegExp(r'^[a-zA-Z0-9]*$').hasMatch(pass);
  int count = 0;
  if (hasDigit) count++;
  if (hasLowercase) count++;
  if (hasUppercase) count++;
  if (hasSpecialCharacter) count++;
  return count >= (PasswordConfig.minimumRuleMatch);
}

bool isNotDuplicateEmail(String? pass, String email) {
  if ((pass ?? "").isEmpty || (email).isEmpty) {
    return false;
  }
  return pass!.trim().toLowerCase() != email.trim().toLowerCase();
}

List<FilteringTextInputFormatter> getFormatValidTextFieldBlockSpace() {
  return [
    FilteringTextInputFormatter.deny(
      RegExp(r'\s'),
    ),
  ];
}

List<FilteringTextInputFormatter> getFormatValidTextFieldOnlyAlphabet() {
  return [
    FilteringTextInputFormatter.allow(
      //only allow alphabet vietnamese
      RegExp(
        '[a-zA-ZÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵỷỹ ]',
      ),
    ),
  ];
}

String formatPhoneNumber(String value) {
  var regExp = RegExp(r'^(\d{0,3})(\d{0,3})(\d{0,4})');
  var matches = regExp.firstMatch(value);
  var ver1 = '${matches?.group(1)} ${matches?.group(2)} ${matches?.group(3)}';
  return ver1;
}

bool isRestrictedEmoji(String value) {
  return RegExp(
    '(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
  ).hasMatch(value);
}

String getMessagePassError(String password) {
  String messageError = '';
  if (!hasMatchLengthPassword(password)) {
    messageError = "${'password_not_specified_format'.tr()} \n";
  }
  if (!hasMatchTypePassword(password)) {
    messageError = "${'password_not_specified_format'.tr()}\n";
  }
  return messageError;
}

/// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
Color colorFromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

int? getIntegerFromDynamic(dynamic value) {
  if (value is double) {
    return value.toInt();
  } else if (value is int) {
    return value;
  } else if (value is String) {
    return int.tryParse(value);
  }
  return null;
}

/// open phone phone app in device
Future<void> openPhoneApp(String phoneNumber) async {
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  try {
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  } catch (e) {
    throw "Can't launch url";
  }
}
