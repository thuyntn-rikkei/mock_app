import 'package:base_bloc_3/import.dart';

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
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
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
    EasyLocalization(
      startLocale: LocalizationConstants.viLocale,
      supportedLocales: const [
        LocalizationConstants.viLocale,
        LocalizationConstants.enUSLocale,
      ],
      path: LocalizationConstants.path,
      fallbackLocale: LocalizationConstants.enUSLocale,
      assetLoader: LanguageRuntimeLoader(),
      child: const MyApp(),
    ),
  );
}
