import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:flutter/material.dart';

class EntryProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Entry> _entries = [];
  List<Entry> _filteredEntries = [];
  bool _isLoading = false;
  String? _error;

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
  bool get isLoading => _isLoading;
  String? get error => _error;

  EntryProvider() {
    _fetchEntries();
  }

  Future<void> _fetchEntries() async {
    _isLoading = true;
    notifyListeners();

    try {
      _entries = await _databaseService.fetchEntries();
    } catch (e) {
      _error = e.toString();
    } finally {
      _filteredEntries = _filterEntriesBetweenDates(_startDate, _endDate);
      _isLoading = false;
      notifyListeners();
    }
  }

  void setStartEndDate(DateTime startDate, DateTime endDate) {
    _startDate = startDate;
    _endDate = endDate;
    _filteredEntries = _filterEntriesBetweenDates(_startDate, _endDate);
    notifyListeners();
  }

  void setDefaultWeekDate() {
    _startDate =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    _endDate = DateTime.now()
        .subtract(Duration(days: DateTime.now().weekday - 1))
        .add(const Duration(days: 6));
    _filteredEntries = _filterEntriesBetweenDates(_startDate, _endDate);
    notifyListeners();
  }

  void setDefaultMonthDate() {
    DateTime now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0);
    _filteredEntries = _filterEntriesBetweenDates(_startDate, _endDate);
    notifyListeners();
  }

  Future<void> addEntry(Entry entry) async {
    await _databaseService.addEntry(entry);
    _entries.add(entry);
    _filteredEntries = _filterEntriesBetweenDates(_startDate, _endDate);
    notifyListeners();
  }

  void updateEntryInList(List<Entry> entries, Entry entry) {
    int entryIndex = entries.indexWhere((e) => e.id == entry.id);
    if (entryIndex != -1) {
      entries[entryIndex] = entry;
    }
  }

  Future<void> updateEntry(Entry entry) async {
    await _databaseService.updateEntry(entry);
    updateEntryInList(_entries, entry);
    _filteredEntries = _filterEntriesBetweenDates(_startDate, _endDate);
    notifyListeners();
  }

  // Method to update the date range and refresh the filtered entries
  void updateDateRange(DateTime startDate, DateTime endDate) {
    _startDate = startDate;
    _endDate = endDate;
    _filteredEntries = _filterEntriesBetweenDates(_startDate, _endDate);
    notifyListeners();
  }

  // Method to filter entries between specified dates
  List<Entry> _filterEntriesBetweenDates(DateTime startDate, DateTime endDate) {
    DateTime startOfDay =
        DateTime(startDate.year, startDate.month, startDate.day);
    DateTime endOfDay = DateTime(
        endDate.year, endDate.month, endDate.day, 23, 59, 59, 999, 999);

    return _entries.where((entry) {
      DateTime entryDate =
          _convertStringToDateTime(entry.date); // Convert string to DateTime
      return entryDate
              .isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
          entryDate.isBefore(endOfDay.add(const Duration(seconds: 1)));
    }).toList();
  }

  Map<int, int> getMoodDistribution() {
    Map<int, int> moodSumMap = {};

    for (var i = 0; i < 11; i++) {
      int count = _entries.where((entry) => entry.mood == i).length;
      if (count > 0) {
        moodSumMap[i] = count;
      }
    }

    return moodSumMap;
  }

  // Helper method to convert a date string to DateTime
  DateTime _convertStringToDateTime(String dateString) {
    return DateTime.parse(dateString.replaceFirst('|', 'T'));
  }
}
