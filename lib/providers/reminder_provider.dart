import 'package:calm_notes/models/reminder.dart';
import 'package:flutter/material.dart';
import 'package:calm_notes/services/database_service.dart';

class ReminderProvider with ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Reminder> _reminders = [];

  List<Reminder> get reminders => _reminders;

  ReminderProvider() {
    _fetchReminders();
  }

  Future<void> _fetchReminders() async {
    _reminders = await _databaseService.fetchReminders();
    notifyListeners();
  }

  Future<void> addReminder(String time) async {
    final reminder = Reminder(
      time: time,
    );
    await _databaseService.addReminder(reminder);
    await _fetchReminders();
  }

  Future<void> deleteReminder(Reminder reminder) async {
    await _databaseService.deleteReminder(reminder.id!);
    await _fetchReminders();
  }
}
