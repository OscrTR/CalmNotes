import 'package:calm_notes/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static Future<void> initializeNotifications() async {
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_notif');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await FlutterLocalNotificationsPlugin().initialize(initializationSettings);
    askNotificationPermission();
  }

  static Future<void> askNotificationPermission() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> deleteNotification(id) async {
    await FlutterLocalNotificationsPlugin().cancel(id);
  }

  static Future<void> scheduleDailyNotification(
      TimeOfDay scheduledTime, int id) async {
    final now = tz.TZDateTime.now(tz.local);
    final time = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        scheduledTime.hour, scheduledTime.minute);
    await FlutterLocalNotificationsPlugin().zonedSchedule(
        id,
        tr('notification_title'),
        tr('notification_description'),
        time,
        const NotificationDetails(
            android: AndroidNotificationDetails(
          'daily_notifications',
          'Daily notifications',
          importance: Importance.max,
          priority: Priority.high,
          color: CustomColors.primaryColor,
          playSound: true,
          enableVibration: true,
          showWhen: false,
        )),
        payload: 'Daily notification payload',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }
}
