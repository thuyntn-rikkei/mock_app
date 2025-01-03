class Validators {
  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter username.";
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter password.";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters long.";
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter email.";
    } else if (!(value.contains('@') && value.contains('.'))) {
      return "Invalid email";
    }
    return null;
  }

  static String? confirmPasswordValidator(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Please enter password.";
    } else if (value != password) {
      return "Password doesn't match.";
    }
    return null;
  }
}
