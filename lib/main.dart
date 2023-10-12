import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:base_bloc_3/app.dart';
import 'package:base_bloc_3/common/config/env_config.dart';
import 'package:base_bloc_3/translations/runtime_language_loader.dart';
import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:base_bloc_3/common/index.dart';
import 'package:base_bloc_3/di/di_setup.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  const flavor = String.fromEnvironment('flavor', defaultValue: 'dev');
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  log("flavor: $flavor");
  await EnvConfig.loadEnv();

  /// uncomment if api domain is not have https
  // HttpOverrides.global = MyHttpOverrides();
  await EasyLocalization.ensureInitialized();
  configureDependencies();
  await getIt<PushNotificationHelper>().initialize();
  // await getIt<LocalNotificationHelper>().init();

  // initFirebaseDynamicLink();
  // initUniLinks();
  runApp(
    DevicePreview(
      enabled: false, // !kReleaseMode,
      builder: (context) {
        return EasyLocalization(
          startLocale: LocalizationConstants.viLocale,
          supportedLocales: const [
            LocalizationConstants.viLocale,
            LocalizationConstants.enUSLocale,
          ],
          path: LocalizationConstants.path,
          fallbackLocale: LocalizationConstants.enUSLocale,
          assetLoader: LanguageRuntimeLoader(),
          child: const MyApp(),
        );
      },
    ),
  );
}
