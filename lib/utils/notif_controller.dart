part of 'utils.dart';

class NotifController{
  static Future initLocalNotification() async {
    final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      var initializationSettingsAndroid =
          AndroidInitializationSettings('icon_notification');
      var initializationSettingsIOS = IOSInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload) async {},
      );
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: (payload) async {},
      );
    } else {
      var initializationSettingsAndroid =
          AndroidInitializationSettings('icon_notification');
      var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) async {},
      );
      var initializationSettings = InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS);
      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onSelectNotification: (payload) async {},
      );
    }
  }

  static Future<void> sendNotification({
    required String type,
    required String myLastChat,
    required String myUid,
    required String myName,
    required String photo,
    required String personToken,
  }) async {
    String serverKey = //buat cloud messaging, di project settings firebase, cloud messaging tab
        '	AAAAp3xgUvc:APA91bHZ-Yr6MHQNpnpvtCugH0hgLOklENsirlIcleJy2ucoi6zlbxRQyN4e9ZwezRj8TvWK6ut17SyNfb7iCzSm3dX3QtwM62kaBmkPMpA0ZgCunRpjF6mC16PHvISsv2LQqmYjrAkk';
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$serverKey',
        },
        body: json.encode( //interface notifikasi
          {
            'notification': {
              'body': type == 'text'
                  ? myLastChat.length >= 25
                      ? myLastChat.substring(0, 25) + '...'
                      : myLastChat
                  : '<Image>',
              'title': myName,
              "sound": "default",
              'tag': myUid,
            },
            'priority': 'high',
            'to': personToken,
          },
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<String> getTokenFromDevice() async {
    String token = '';
    try {
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      String vapidKey = //kata kunci akses untuk website messaging, di project settings firebase, cloud messaging tab, web configuration, generate new pair
          'BNoklGnQrzh9zm0MSo6IwVQ_s7IWO6F2-IERTMXxo4d1eM444Tlx1LoalnmfMt4DHYnJQ_TNLWch0eXAv9I6JZE';
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // token = await FirebaseMessaging.instance.getToken(vapidKey: vapidKey);
        token = (await FirebaseMessaging.instance.getToken(vapidKey: vapidKey))!;
        print('User granted permission');
      } else if (settings.authorizationStatus ==
          AuthorizationStatus.provisional) {
        FirebaseMessaging.instance.getToken(vapidKey: vapidKey).then((value) {
          print('token : $value');
        });
        print('User granted provisional permission');
      } else {
        print('User declined or has not accepted permission');
      }

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('A new onMessageOpenedApp event was published!');
      });
    } catch (e) {
      print(e);
    }
    return token;
  }
}