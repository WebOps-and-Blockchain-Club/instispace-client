import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../utils/image_data_from_url.dart';

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationService = FlutterLocalNotificationsPlugin();

  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<NotificationAppLaunchDetails?> details() async {
    return await _localNotificationService.getNotificationAppLaunchDetails();
  }

  Future<void> initialise() async {
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    await _localNotificationService.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future<NotificationDetails> notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'High_importance_channel',
      'High Importance Notifications',
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      priority: Priority.max,
    );

    const IOSNotificationDetails iosNotificationDetails =
        IOSNotificationDetails();

    return const NotificationDetails(
        android: androidNotificationDetails, iOS: iosNotificationDetails);
  }

  void showNotification(
      {required int id,
      required String title,
      required String description,
      required String payload,
      String? image}) async {
    initialise();
    BigPictureStyleInformation? bigPictureStyleInformation;
    if (image != null) {
      final ByteArrayAndroidBitmap bigPicture =
          ByteArrayAndroidBitmap(await getByteArrayFromUrl(image));
      bigPictureStyleInformation = BigPictureStyleInformation(bigPicture,
          contentTitle: title,
          summaryText: description,
          htmlFormatContentTitle: true,
          htmlFormatSummaryText: true);
    }
    _localNotificationService.show(
      id,
      title,
      description,
      NotificationDetails(
        android: AndroidNotificationDetails(
            'High_importance_channel', 'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            color: const Color(0xFF2F247B),
            playSound: true,
            icon: '@mipmap/ic_launcher',
            styleInformation: bigPictureStyleInformation),
        iOS: const IOSNotificationDetails(
          sound: 'default.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: payload,
    );
  }

  void showFirebaseNotification(RemoteMessage message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null || token == "") {
      FirebaseMessaging.instance.deleteToken();
      return;
    }
    showNotification(
        id: 0,
        title: message.data["title"],
        description: message.data["body"],
        payload: message.data["route"],
        image: message.data["image"]);
  }

  Future<void> scheduleNotification(
      {required int id,
      required String title,
      required String description,
      required String time}) async {
    tz.initializeTimeZones();

    await _localNotificationService.zonedSchedule(
        id,
        title,
        description,
        tz.TZDateTime.parse(tz.local, time),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'High_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            color: Color(0xFF2F247B),
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: IOSNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}

  void onSelectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }
}
