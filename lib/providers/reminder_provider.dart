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
    _reminders = await _databaseService.getReminders();
    notifyListeners();
  }

  Future<void> addReminder(String time) async {
    _databaseService.addReminder(time);
    await _fetchReminders();
  }

  Future<void> deleteReminder(int id) async {
    _databaseService.deleteReminder(id);
    await _fetchReminders();
  }
}
