import 'package:base_bloc_3/import.dart';

enum EnvFlavor { dev, staging, uat, production }

// extension
extension EnvFlavorExtension on EnvFlavor {
  String get configFile {
    switch (this) {
      case EnvFlavor.dev:
        return Assets.env.aEnvDev;
      case EnvFlavor.staging:
        return Assets.env.aEnvStaging;
      case EnvFlavor.production:
        return Assets.env.aEnvProduction;
      default:
        return Assets.env.aEnvDev;
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
