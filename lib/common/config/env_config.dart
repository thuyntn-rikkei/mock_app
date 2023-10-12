import 'dart:developer';

import 'package:base_bloc_3/gen/assets.gen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvFlavor { dev, staging, uat, production }

// extension
extension EnvFlavorExtension on EnvFlavor {
  String get configFile {
    switch (this) {
      case EnvFlavor.dev:
        return Assets.env.envDev;
      case EnvFlavor.staging:
        return Assets.env.envStaging;
      case EnvFlavor.production:
        return Assets.env.envProduction;
      default:
        return Assets.env.envDev;
    }
  }
}

class EnvConfig {
  static String flavor =
      const String.fromEnvironment('flavor', defaultValue: 'dev');

  // load env file
  static Future<void> loadEnv() async {
    log("flavor: $flavor");
    await dotenv.load(fileName: getEnvFlavor().configFile);
  }

  static EnvFlavor getEnvFlavor() {
    switch (flavor) {
      case 'dev':
        return EnvFlavor.dev;
      case 'staging':
        return EnvFlavor.staging;
      case 'uat':
        return EnvFlavor.uat;
      case 'production':
        return EnvFlavor.production;
      default:
        return EnvFlavor.dev;
    }
  }

  static bool isDevelopmentEnv() {
    return flavor != 'production';
  }
}
