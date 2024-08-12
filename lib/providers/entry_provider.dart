import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:flutter/material.dart';

class EntryProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Entry> _entries = [];
  List<Entry> _filteredEntries = [];

  // Properties to hold the start and end dates for filtering
  DateTime _startDate =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  DateTime _endDate = DateTime.now()
      .subtract(Duration(days: DateTime.now().weekday - 1))
      .add(const Duration(days: 6));

  List<Entry> get entries => _entries;
  List<Entry> get filteredEntries => _filteredEntries;
  DateTime get startDate => _startDate;
  DateTime get endDate => _endDate;

  EntryProvider() {
    _fetchEntries();
  }

  Future<void> _fetchEntries() async {
    _entries = await _databaseService.fetchEntries();
    _filteredEntries = filterEntriesBetweenDates(_startDate, _endDate);
    notifyListeners();
  }

  void setStartEndDate(DateTime startDate, DateTime endDate) {
    _startDate = startDate;
    _endDate = endDate;
    _fetchEntries();
  }

  void setDefaultWeekDate() {
    _startDate =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    _endDate = DateTime.now()
        .subtract(Duration(days: DateTime.now().weekday - 1))
        .add(const Duration(days: 6));
    _fetchEntries();
  }

  void setDefaultMonthDate() {
    DateTime now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0);
    _fetchEntries();
  }

  Future<void> addEntry(Entry entry) async {
    await _databaseService.addEntry(entry);
    await _fetchEntries();
  }

  // Method to update the date range and refresh the filtered entries
  void updateDateRange(DateTime startDate, DateTime endDate) {
    _startDate = startDate;
    _endDate = endDate;
    _filteredEntries = filterEntriesBetweenDates(_startDate, _endDate);
    notifyListeners();
  }

  // Method to filter entries between specified dates
  List<Entry> filterEntriesBetweenDates(DateTime startDate, DateTime endDate) {
    return _entries.where((entry) {
      DateTime entryDate =
          _convertStringToDateTime(entry.date); // Convert string to DateTime
      return entryDate
              .isAfter(startDate.subtract(const Duration(seconds: 1))) &&
          entryDate.isBefore(endDate.add(const Duration(seconds: 1)));
    }).toList();
  }

  // Helper method to convert a date string to DateTime
  DateTime _convertStringToDateTime(String dateString) {
    return DateTime.parse(dateString.replaceFirst('|', 'T'));
  }
}
