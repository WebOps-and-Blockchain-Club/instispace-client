import 'dart:math';
import 'package:client/services/auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../database/academic.dart';
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
      icon: '@mipmap/ic_launcher_bg',
      visibility: NotificationVisibility.public,
      fullScreenIntent: true,
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
    await initialise();
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
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
            priority: Priority.max,
            icon: '@mipmap/ic_launcher_bg',
            visibility: NotificationVisibility.public,
            fullScreenIntent: true,
            styleInformation: bigPictureStyleInformation ??
                BigTextStyleInformation(description)),
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
    AuthService authService = AuthService();
    String? token = await authService.getToken();
    if (token == null || token == "") {
      FirebaseMessaging.instance.deleteToken();
      return;
    }
    showNotification(
        id: message.data["id"] ?? Random().nextInt(1000),
        title: message.data["title"],
        description: message.data["body"],
        payload: message.data["route"],
        image: message.data["image"]);
  }

  Future<void> scheduleNotification(
      {required String title,
      required String description,
      required String time}) async {
    tz.initializeTimeZones();

    await _localNotificationService.zonedSchedule(
        Random().nextInt(1000),
        title,
        description,
        tz.TZDateTime.parse(tz.local, time),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'reminder_notification_channel1',
            'Reminder Notifications',
            channelDescription:
                'This channel is used for reminder notifications.',
            color: Color(0xFF2F247B),
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
            priority: Priority.max,
            icon: '@mipmap/ic_launcher_bg',
            visibility: NotificationVisibility.public,
            fullScreenIntent: true,
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

  Future<void> scheduleWeeklyNotification({
    required String title,
    required String description,
    required int courseId,
  }) async {
    print('schedule notification called=========================');
    tz.initializeTimeZones();
    AcademicDatabaseService acadDb = AcademicDatabaseService.instance;
    DateTime? nextNotificationTime = await acadDb.getNextClassTime(courseId);
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print("=========================================nextNotificationTime");
    print(nextNotificationTime);
    if (nextNotificationTime == null) {
      return;
    }
    final nextNotificationTimeTZ =
        tz.TZDateTime.from(nextNotificationTime, now.location);
    print("=========================================nextNotificationTimeTZ");
    print(nextNotificationTimeTZ);
    await _localNotificationService.zonedSchedule(
        courseId,
        title,
        description,
        nextNotificationTimeTZ,
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'reminder_notification_channel', 'Reminder Notifications',
              channelDescription:
                  'This channel is used for reminder notifications.',
              color: Color(0xFF2F247B),
              importance: Importance.max,
              playSound: true,
              enableVibration: true,
              priority: Priority.max,
              icon: '@mipmap/ic_launcher_bg',
              visibility: NotificationVisibility.public,
              fullScreenIntent: true),
          iOS: IOSNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: "$nextNotificationTimeTZ",
        androidAllowWhileIdle: true,
        matchDateTimeComponents: DateTimeComponents.dateAndTime,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);

    var a = await _localNotificationService.pendingNotificationRequests();
    print(a);
  }

  Future<List<PendingNotificationRequest>> getScheduledNotification() async {
    return await _localNotificationService.pendingNotificationRequests();
  }

  Future<void> deleteNotification(int id) async {
    return await _localNotificationService.cancel(id);
  }

  tz.TZDateTime getNextInstanceOfTime(String day, int hours, int minutes) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    now.add(const Duration(minutes: 330));
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hours, minutes);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    day = day.toLowerCase();
    int dayInFormat = 0;
    if (day == "monday") dayInFormat = DateTime.monday;
    if (day == "tuesday") dayInFormat = DateTime.tuesday;
    if (day == "wednesday") dayInFormat = DateTime.wednesday;
    if (day == "thursday") dayInFormat = DateTime.thursday;
    if (day == "friday") dayInFormat = DateTime.friday;
    while (scheduledDate.weekday != dayInFormat) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    scheduledDate = scheduledDate.subtract(const Duration(minutes: 330));
    print(scheduledDate);
    return scheduledDate;
  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) {}

  void onSelectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }
}
