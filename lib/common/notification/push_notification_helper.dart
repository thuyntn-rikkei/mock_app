import 'package:base_bloc_3/import.dart';

@singleton
class PushNotificationHelper {
  late final FirebaseMessaging _firebaseMessaging;
  Function(String)? handleNotificationOnTap;
  String? pushToken;
  String? _payLoad;

  Future<void> initialize({
    Function(String)? handleNotificationOnTap,
  }) async {
    await Firebase.initializeApp();
    _firebaseMessaging = FirebaseMessaging.instance;
    this.handleNotificationOnTap = handleNotificationOnTap;
    await _fcmInitialization();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future _fcmInitialization() async {
    try {
      await getPushToken();
      FirebaseMessaging.instance.onTokenRefresh.listen((token) {
        pushToken = token;
      });

      final RemoteMessage? initMessage =
          await _firebaseMessaging.getInitialMessage();
      if (initMessage != null) {
        _payLoad = jsonEncode(initMessage);
      }

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        _payLoad = getNotificationContent(message);
        if (message.notification != null) {
          getIt<LogUtils>().logD("Message: ${message.notification.toString()}");
          getIt<LogUtils>().logD("Message: ${message.data}");
          if (Platform.isAndroid) {
            getIt<LocalNotificationHelper>().showNotification(
              title: message.notification?.title ?? '',
              body: message.notification?.body ?? '',
              payload: _payLoad,
            );
          }
        }

        ///Gửi event load lại các trang hiện chấm đỏ của notification
        //   NotificationFCM notificationFCM = NotificationFCM.fromJson(
        //     jsonDecode(_payLoad ?? "") as Map<String, dynamic>,
        //   );
        //   getIt<EventBus>().fire(
        //     ChangeStatusNotificationEvent(
        //       isNewNotification:
        //           (message.notification?.title?.isNotEmpty ?? false) &&
        //               (message.notification?.body?.isNotEmpty ?? false),
        //       notificationEnum:
        //           int.tryParse(notificationFCM.data?.notificationType ?? "0")
        //               ?.getTypeNotificationByInt,
        //     ),
        //   );
      });
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        _payLoad = getNotificationContent(message);
        if (handleNotificationOnTap != null && _payLoad != null) {
          handleNotificationOnTap!(_payLoad!);
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  Future<String?> getPushToken() async {
    pushToken ??= await _firebaseMessaging.getToken();
    getIt<LogUtils>().logD('fcm token: $pushToken');
    return pushToken;
  }

  Future<void> unSubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> deleteToken() async {
    pushToken = null;
    await _firebaseMessaging.deleteToken();
  }

  FirebaseMessaging getFirebaseInstance() {
    return _firebaseMessaging;
  }
}

String getNotificationContent(RemoteMessage? message) {
  if (message == null) return 'RemoteMessage is Null';
  final body = {
    'notification': {
      'title': message.notification?.title,
      'body': message.notification?.body,
    },
    'data': message.data,
    "collapse_key": message.collapseKey,
    "message_id": message.messageId,
    "sent_time": message.sentTime?.millisecondsSinceEpoch,
    "from": message.from,
    "ttl": message.ttl,
  };
  return jsonEncode(body);
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage remoteMessage,
) async {
  printDebug(
    'Handling a background message: ${getNotificationContent(remoteMessage)}',
  );
  // injector<LogUtils>()
  //     .logD('Handling a background message ${remoteMessage.messageId}');
  // injector<LogUtils>()
  //     .logD('message data ${getNotificationContent(remoteMessage)}');
}
