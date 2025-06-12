import 'package:base_bloc_3/import.dart';

class Validators {
  static String? fullNameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.validators_full_name_required;
    }
    return null;
  }

  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.validators_username_required;
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.validators_password_required;
    }
    if (value.length < 8) {
      return S.current.validators_password_min_length;
    }
    const pattern =  r"""^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$""";
    final regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return S.current.validators_password_invalid;
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return S.current.validators_email_required;
    }
    const pattern =
    r"""^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$""";
    final regex = RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return S.current.validators_email_invalid;
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value == null || value.isEmpty) {
      return S.current.validators_password_confirmation_required;
    } else if (value != password) {
      return S.current.validators_password_confirmation_mismatch;
    }
    return null;
  }
}
