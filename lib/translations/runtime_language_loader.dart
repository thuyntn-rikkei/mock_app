import 'dart:ui';

import 'package:base_bloc_3/translations/translate_key.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageRuntimeLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(TranslationKey.translations[locale.languageCode]);
  }
}
