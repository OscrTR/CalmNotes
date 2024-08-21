import 'package:calm_notes/colors.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:calm_notes/router.dart';
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

    // Request permission to send notifications if not already allowed
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

  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationCreatedMethod');
  }

  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    debugPrint('onNotificationDisplayedMethod');
  }

  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onDismissActionReceivedMethod');
  }

  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    debugPrint('onActionReceivedMethod');
    final payload = receivedAction.payload ?? {};
    if (payload["navigate"] == "true") {
      router.go('/home');
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
