import 'package:base_bloc_3/import.dart';

class LanguageRuntimeLoader extends AssetLoader {
  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) {
    return Future.value(TranslationKey.translations[locale.languageCode]);
  }
}
