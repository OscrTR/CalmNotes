import 'package:calm_notes/colors.dart';
import 'package:calm_notes/main.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:calm_notes/pages/home_page.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'reminders',
          channelKey: 'reminders',
          channelName: 'Reminders notifications',
          channelDescription: 'Notification channel for reminderts',
          defaultColor: CustomColors.color10,
          ledColor: CustomColors.color10,
          importance: NotificationImportance.Max,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        )
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'reminders_group',
          channelGroupName: 'Reminders',
        )
      ],
      debug: false,
    );

    await AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) async {
        if (!isAllowed) {
          await AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );
  }

  /// Use this method to detect when a new notification or a schedule is created
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  /// Use this method to detect every time that a new notification is displayed
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  /// Use this method to detect if the user dismissed a notification
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  /// Use this method to detect when the user taps on a notification or action button
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    }
  }

  static Future<void> showNotification(TimeOfDay time) async {
    DateTime date = DateTime.now();
    DateTime scheduleTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: -1,
          channelKey: 'reminders',
          title: 'How are you feeling?',
          body: 'Add an entry to your journal.',
          wakeUpScreen: true,
          category: NotificationCategory.Reminder,
          autoDismissible: false,
        ),
        schedule: NotificationCalendar.fromDate(
            date: scheduleTime, preciseAlarm: true, repeats: true));
  }
}
