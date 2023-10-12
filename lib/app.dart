
import 'package:base_bloc_3/common/index.dart';
import 'package:base_bloc_3/di/di_setup.dart';
import 'package:base_bloc_3/routes/app_pages.dart';
import 'package:base_bloc_3/routes/route_observer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

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
