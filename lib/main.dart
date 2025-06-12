import 'package:base_bloc_3/firebase_options.dart';
import 'package:base_bloc_3/import.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
    );
  }
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );
  await EnvConfig.loadEnv();

  configureDependencies();
  await getIt<PushNotificationHelper>().initialize();
  // await getIt<LocalNotificationHelper>().init();

  // initFirebaseDynamicLink();
  // initUniLinks();
  runApp(
    const MyApp(),
  );
}
