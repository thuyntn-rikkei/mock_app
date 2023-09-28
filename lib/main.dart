import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:base_bloc_3/common/index.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/routes/app_pages.dart';
import 'package:base_bloc_3/routes/route_observer.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

String envConfig(String flavor) {
  switch (flavor) {
    case 'dev':
      return 'assets/env/.env_dev';
    case 'staging':
      return 'assets/env/.env_staging';
    case 'production':
      return 'assets/env/.env_production';
    default:
      return 'assets/env/.env_dev';
  }
}

Future<void> initFirebaseDynamicLink() async {
  try {
    PendingDynamicLinkData? initialLink;
    if (Platform.isIOS) {
      await Future.delayed(const Duration(milliseconds: 200), () async {
        initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
      });
    } else {
      initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
    }

    if (initialLink != null) {
      //save to shared pref
      getIt<LocalStorage>()
          .save(PrefKeys.initLink, initialLink!.link.toString());
    }
  } on Exception {
    /// todo handle exception
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
  await dotenv.load(
    fileName: envConfig(flavor),
  );
  HttpOverrides.global = MyHttpOverrides();
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
          child: const MyApp(),
        );
      },
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _appRoute = getIt<AppPages>();

  void initDynamicLinks() async {
    //get initlink
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLinkData) async {
      /// TODO: handle dynamic link
    }).onError((error) {
      // Handle errors
    });
  }

  // late StreamSubscription tokenExpiredStream;
  // final localPref = getIt<LocalStorage>();
  // bool isShowDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initDynamicLinks();
      getIt<LocalStorage>().save(PrefKeys.splashLoaded, false);
    });
    // tokenExpiredStream = getIt<EventBus>().on<AppHashExpiredEvent>().listen(
    //   (event) async {
    //     if (isShowDialog) return;
    //     if (_appRoute.current.name.endsWith(LoginPageRoute.name)) return;
    //     isShowDialog = true;
    //     SmartDialog.show(
    //       clickMaskDismiss: false,
    //       keepSingle: true,
    //       builder: (context) {
    //         return Dialog(
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(8),
    //           ),
    //           elevation: 0,
    //           backgroundColor: Colors.white,
    //           child: DialogWidget(
    //             description: 'app_hash_expired'.tr(),
    //             onPressedLeftButton: () async {
    //               //Clear when logout
    //               try {
    //                 await localPref.clearExceptSomeKeys();
    //                 await localPref.remove(PrefKeys.customerId);
    //                 await localPref.remove(PrefKeys.passwordHash);
    //                 await localPref.remove(PrefKeys.loginWithEmail);
    //                 await localPref.remove(PrefKeys.dob);
    //                 await localPref.remove(PrefKeys.phoneNumber);
    //                 await localPref.remove(PrefKeys.genderUser);
    //                 await localPref.remove(PrefKeys.settingNotification);
    //                 await localPref.remove(PrefKeys.cartTotal);
    //                 await localPref.remove(PrefKeys.quoteId);
    //                 final brandGuest =
    //                     await localPref.get(PrefKeys.itemLookingForGuest);
    //                 if (brandGuest != null && brandGuest.isNotEmpty) {
    //                   await localPref.save(PrefKeys.itemLookingFor, brandGuest);
    //                 } else {
    //                   await localPref.save(
    //                     PrefKeys.itemLookingFor,
    //                     BrandConfig.owen,
    //                   );
    //                 }
    //               } catch (e) {
    //                 /// do nothing
    //               }
    //
    //               _appRoute.pushAndPopUntil(
    //                 const CorePageRoute(),
    //                 predicate: (route) => false,
    //               );
    //               _appRoute.push(
    //                 LoginPageRoute(initText: ""),
    //               );
    //               SmartDialog.dismiss();
    //             },
    //             leftButtonText: 'login'.tr(),
    //           ),
    //         );
    //       },
    //     ).whenComplete(() => isShowDialog = false);
    //   },
    // );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // tokenExpiredStream.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive) {}
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(
        ScreenUtilsConfig.designWidth,
        ScreenUtilsConfig.designHeight,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          builder: FlutterSmartDialog.init(
            loadingBuilder: (msg) => const LoadingWidget(),
          ),
          routerDelegate:
              _appRoute.delegate(navigatorObservers: () => [MyObserver()]),
          routeInformationParser: _appRoute.defaultRouteParser(),
        );
      },
    );
  }
}
