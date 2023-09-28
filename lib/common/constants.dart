import 'package:flutter/material.dart';

class LocalizationConstants {
  static const Locale viLocale = Locale('vi', 'VN');
  static const Locale enUSLocale = Locale('en', 'US');
  static const path = 'assets/translations';
}

class NotificationConfig {
  static const highImportance = "High Importance channel";
  static const highChannelId = "high_importance_channel";
  static const highChannelDescription = "Floating notification with sound";
  static const notificationIconPath = 'ic_notification';
}

class Config {
  static const memCacheHeight = 150;
  static const memCacheWidth = 150;
  static const defaultDurationShowToast = 2; //seconds
}

class PrefKeys {
  static const String initLink = 'initLink';
  static const String initFirebaseLink = 'initFirebaseLink';
  static const String splashLoaded = 'splashLoaded';
}

class PasswordConfig {
  static const int maxLength = 8;
  static const int minLength = 8;
  static const int minimumRuleMatch = 3;
}

class Constants {
  static const int maxLengthTextArea = 1000;
  static const int maxLengthTextAreaRating = 200;
}
