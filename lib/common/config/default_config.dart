import 'package:flutter_dotenv/flutter_dotenv.dart';

class DefaultConfig {
  static String get getBaseUrl => dotenv.get('BASE_URL');
}
