import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  static String serverKey =
      'AAAAzoBXrJc:APA91bGtW2AGK7Fc9LPFstqo31-9lCqWnwjZ6_V7g8suMEEqAHpiy8pWzqKWYf7GAyXvat9pvdYEpV5uXx8lTnFf-kExYzrdUDLvzaxxHdBdzfpLd9wPlojzR9RMqnjWnxHXUTiV_iv3';

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );
  static void initialize() async {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@drawable/ic_stat_logo"));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static void display(RemoteMessage message) async {
    try {
      Random random = Random();
      int id = random.nextInt(1000);
      const NotificationDetails notificationDetails = NotificationDetails(
          android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ));
      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );
    } on Exception {
      // print('Error>>>>$e');
    }
  }

  static Future<void> sendNotification({
    required String userToken,
    required String notificationTitle,
    required String notificationBody,
  }) async {
    Random random = Random();
    int id = random.nextInt(1000);
    final data = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": id.toString(),
      "status": "done",
      'message': notificationBody
    };
    var body = {
      "to": userToken,
      "notification": {
        "body": notificationBody,
        "title": notificationTitle,
        "sound": "default"
      },
      "android": {
        'notification': {
          'channel_id': "high_importance_channel",
        },
        "ttl": "1s"
      },
      "webpush": {
        "headers": {"TTL": "1", "Urgency": "high"}
      },
      "priority": "high",
      'data': data,
    };

    try {
      http
          .post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Key=$serverKey'
        },
        encoding: Encoding.getByName('utf-8'),
        body: json.encode(body),
      )
          .then((value) {
        // value.statusCode == 200? print('done'): print(value.statusCode);
      });
    } catch (e) {
      // print("Exception Error>>>$e");
    }
  }

  // static storeToken() async {
  //   try {
  //     String? token = await FirebaseMessaging.instance.getToken();
  //     print(token);
  //     FirebaseFirestore.instance
  //         .collection('Users')
  //         .doc(email)
  //         .update({
  //       'token': token,
  //     });
  //   } catch (e) {
  //     print("error>>>> $e");
  //   }
  // }
}
