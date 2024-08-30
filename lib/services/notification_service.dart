import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:calm_notes/colors.dart';
import 'package:calm_notes/router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static Future<void> initializeNotification() async {
    await AwesomeNotifications().initialize(
      'resource://drawable/res_notification_icon',
      [
        NotificationChannel(
          channelKey: 'scheduled_channel',
          channelName: 'Scheduled Notifications',
          channelDescription: 'Notification channel for reminders.',
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
        )
      ],
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

  static Future<void> showNotification(
      TimeOfDay time, int notificationId) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: notificationId,
          channelKey: 'scheduled_channel',
          title: tr('notification_title'),
          body: tr('notification_description'),
          color: CustomColors.primaryColor,
          wakeUpScreen: true,
          category: NotificationCategory.Reminder,
          autoDismissible: true,
        ),
        schedule: NotificationCalendar(
            hour: time.hour, minute: time.minute, second: 0, repeats: true));
  }
}
