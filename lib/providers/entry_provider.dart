import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/models/factor.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EntryProvider extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService.instance;
  List<Entry> _entries = [];
  List<Entry> _filteredEntries = [];
  String? _error;
  List<String> _spotsDate = [];
  List<FlSpot> _entrySpots = [];
  Map<double, Color> _gradientColorsStopsMap = {};
  String _selectedFactor = '';
  List<String> _factorsList = [];
  List<FlSpot> _factorSpots = [];
  double _initialWeeksListOffset = 0;
  double _initialMonthsListOffset = 0;
  List<DateTime> _weeks = [];
  List<DateTime> _months = [];
  bool _isWeekSelected = true;
  Map<int, int> _moodDistribution = {};

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
  String? get error => _error;
  List<String> get spotsDate => _spotsDate;
  List<FlSpot> get entrySpots => _entrySpots;
  Map<double, Color> get gradientColorsStopsMap => _gradientColorsStopsMap;
  String get selectedFactor => _selectedFactor;
  List<String> get factorsList => _factorsList;
  List<FlSpot> get factorSpots => _factorSpots;
  double get initialWeeksListOffset => _initialWeeksListOffset;
  double get initialMonthsListOffset => _initialMonthsListOffset;
  List<DateTime> get weeks => _weeks;
  List<DateTime> get months => _months;
  bool get isWeekSelected => _isWeekSelected;
  Map<int, int> get moodDistribution => _moodDistribution;

  EntryProvider() {
    fetchEntries();
    _weeks = _generateDateRanges(const Duration(days: 7));
    _months = _generateDateRanges(const Duration(days: 30), true);
    _initialWeeksListOffset = 98.0 * _weeks.length;
    _initialMonthsListOffset = 98.0 * _months.length;
  }

  Future<void> fetchEntries() async {
    try {
      _entries = await _databaseService.fetchEntries();
    } catch (e) {
      _error = e.toString();
    } finally {
      _spotsDate = await _generateFullDateRange(_startDate, _endDate);
      await updateStatistics();
      notifyListeners();
    }
  }

  Future<void> setStartEndDate(DateTime startDate, DateTime endDate) async {
    _startDate = startDate;
    _endDate = endDate;
    _spotsDate = await _generateFullDateRange(_startDate, _endDate);
    await updateStatistics();
    notifyListeners();
  }

  Future<void> setDefaultWeekDate() async {
    _startDate =
        DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
    _endDate = DateTime.now()
        .subtract(Duration(days: DateTime.now().weekday - 1))
        .add(const Duration(days: 6));
    _spotsDate = await _generateFullDateRange(_startDate, _endDate);
    await updateStatistics();
    notifyListeners();
  }

  Future<void> setDefaultMonthDate() async {
    DateTime now = DateTime.now();
    _startDate = DateTime(now.year, now.month, 1);
    _endDate = DateTime(now.year, now.month + 1, 0);
    _spotsDate = await _generateFullDateRange(_startDate, _endDate);
    await updateStatistics();
    notifyListeners();
  }

  Future<void> addEntry(Entry entry) async {
    final entryId = await _databaseService.addEntry(entry);
    _entries.add(entry.copyWith(id: entryId));
    await updateStatistics();
    notifyListeners();
  }

  Future<void> deleteEntry(int id) async {
    await _databaseService.deleteEntry(id);
    _entries.removeWhere((e) => e.id == id);
    await updateStatistics();
    notifyListeners();
  }

  Future<void> updateEntryInList(List<Entry> entries, Entry entry) async {
    int entryIndex = entries.indexWhere((e) => e.id == entry.id);
    if (entryIndex != -1) {
      entries[entryIndex] = entry;
    }
  }

  Future<void> updateEntry(Entry entry) async {
    await _databaseService.updateEntry(entry);
    await updateEntryInList(_entries, entry);
    await updateStatistics();
    notifyListeners();
  }

  Future<void> updateStatistics() async {
    _filteredEntries = await _filterEntriesBetweenDates(_startDate, _endDate);
    _factorsList = await _extractFactors(_filteredEntries);
    _entrySpots = await _convertEntriesToSpots(_entries, spotsDate);
    _gradientColorsStopsMap = await _createGradientColorStopsMap(_entrySpots);
    _moodDistribution = await _getMoodDistribution();
  }

  void changeRangeTypeSelection() {
    _isWeekSelected = !_isWeekSelected;
  }

  void selectFactor(String factor) {
    _selectedFactor = factor;
    _factorSpots =
        _convertFactorsToSpots(_entries, _selectedFactor, _spotsDate);
    notifyListeners();
  }

  void removeFactor() {
    _selectedFactor = '';
    _factorSpots = [];
    notifyListeners();
  }

  List<FlSpot> _convertFactorsToSpots(
      List<Entry> entries, String factorName, List<String> spotsDate) {
    final factorsList = _createFactorsList(entries);
    final List<FlSpot> spots = [];

    double? findFactorValue(
        List<Factor> factors, DateTime date, String factorName) {
      for (var factor in factors) {
        if (factor.date == date && factor.name == factorName) {
          return factor.value;
        }
      }
      return null;
    }

    FlSpot createSpot(int index, double? factorValue) {
      return factorValue != null
          ? FlSpot(index.toDouble(), factorValue.toDouble())
          : FlSpot.nullSpot;
    }

    for (int i = 0; i < spotsDate.length; i++) {
      DateTime factorDate = DateTime.parse(spotsDate[i]);
      double? factorValue =
          findFactorValue(factorsList, factorDate, factorName);
      spots.add(createSpot(i, factorValue));
    }

    return spots;
  }

  List<Factor> _createFactorsList(List<Entry> entries) {
    final List<Factor> tempFactorsList = [];

    for (var entry in entries) {
      final DateTime date = DateTime.parse(entry.date.split('|')[0]);
      final List<String> factorsList = [
        ...entry.emotions
                ?.split(',')
                .map((emotion) => emotion.trim())
                .where((emotion) => emotion.isNotEmpty)
                .toList() ??
            [],
        ...entry.tags
                ?.split(',')
                .map((tag) => tag.trim())
                .where((tag) => tag.isNotEmpty)
                .toList() ??
            [],
      ];

      for (var factor in factorsList.where((f) => f.isNotEmpty)) {
        final parts = factor.split(':').map((e) => e.trim()).toList();
        tempFactorsList.add(
            Factor(date: date, name: parts[0], value: double.parse(parts[1])));
      }
    }

    final Map<String, FactorSummary> summaryMap = {};
    for (var factor in tempFactorsList) {
      final key = '${factor.date},${factor.name}';
      summaryMap.update(
          key,
          (summary) => summary
            ..sum += factor.value.toInt()
            ..count += 1,
          ifAbsent: () => FactorSummary(sum: factor.value, count: 1));
    }

    return summaryMap.entries.map((entry) {
      final keyParts = entry.key.split(',');
      return Factor(
          date: DateTime.parse(keyParts[0]),
          name: keyParts[1],
          value: entry.value.sum / entry.value.count);
    }).toList();
  }

  // Method to filter entries between specified dates
  Future<List<Entry>> _filterEntriesBetweenDates(
      DateTime startDate, DateTime endDate) async {
    DateTime startOfDay =
        DateTime(startDate.year, startDate.month, startDate.day);
    DateTime endOfDay =
        DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59, 999, 999)
            .subtract(const Duration(days: 1));

    return _entries.where((entry) {
      DateTime entryDate =
          _convertStringToDateTime(entry.date); // Convert string to DateTime
      return entryDate
              .isAfter(startOfDay.subtract(const Duration(seconds: 1))) &&
          entryDate.isBefore(endOfDay.add(const Duration(seconds: 1)));
    }).toList();
  }

  Future<Map<int, int>> _getMoodDistribution() async {
    Map<int, int> moodSumMap = {};

    for (var i = 0; i <= 10; i++) {
      int count = _filteredEntries.where((entry) => entry.mood == i).length;
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

  // Generate the full date range between startDate and endDate
  Future<List<String>> _generateFullDateRange(
      DateTime startDate, DateTime endDate) async {
    return List.generate(
      endDate.difference(startDate).inDays + 1,
      (i) => DateFormat('yyyy-MM-dd').format(startDate.add(Duration(days: i))),
    );
  }

  // Function to convert entries to FlSpots with gaps for missing dates
  Future<List<FlSpot>> _convertEntriesToSpots(
      List<Entry> entries, List<String> spotsDate) async {
    final Map<String, double> moodTotalMap = {};
    final Map<String, int> moodCountMap = {};

    // Populate the moodMap with entries
    for (var entry in entries) {
      final String date = entry.date.substring(0, 10);
      // Accumulate the mood values for each date
      moodTotalMap.update(date, (val) => val + entry.mood.toDouble(),
          ifAbsent: () => entry.mood.toDouble());
      moodCountMap.update(date, (val) => val + 1, ifAbsent: () => 1);
    }

    final List<FlSpot> spots = [];
    for (var i = 0; i < spotsDate.length; i++) {
      final date = spotsDate[i];
      spots.add(moodTotalMap.containsKey(date)
          ? FlSpot(i.toDouble(), moodTotalMap[date]! / moodCountMap[date]!)
          : FlSpot.nullSpot);
    }

    return spots;
  }

  Future<Map<double, Color>> _createGradientColorStopsMap(
      List<FlSpot> spotsList) async {
    final nonNullSpots =
        spotsList.where((spot) => !(spot.x.isNaN || spot.y.isNaN)).toList();
    if (nonNullSpots.isEmpty) return {};

    final minX = nonNullSpots.first.x;
    final maxX = nonNullSpots.last.x;
    final rangeX = maxX - minX;

    return {
      for (var spot in nonNullSpots)
        (spot.x - minX) / rangeX: moodColors[spot.y.round()]
    };
  }

  List<DateTime> _generateDateRanges(Duration duration,
      [bool byMonth = false]) {
    List<DateTime> ranges = [];
    DateTime currentDate = DateTime(DateTime.now().year, 1, 1);

    // Calculate the last day of the current week (Sunday)
    DateTime now = DateTime.now();
    int daysUntilEndOfWeek = DateTime.sunday - now.weekday;
    DateTime endDate = now.add(Duration(days: daysUntilEndOfWeek));

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      ranges.add(currentDate);
      currentDate = byMonth
          ? DateTime(currentDate.year, currentDate.month + 1, 1)
          : currentDate.add(duration);
    }

    return ranges;
  }

  Future<List<String>> _extractFactors(List<Entry> entries) async {
    Set<String> factorsSet = {};

    for (var entry in entries) {
      _processEntry(entry.emotions, factorsSet);
      _processEntry(entry.tags, factorsSet);
    }

    return factorsSet.toList();
  }

  void _processEntry(String? entryString, Set<String> factorsSet) {
    if (entryString != null && entryString.isNotEmpty) {
      for (var item in entryString.split(',')) {
        var trimmedItem = item.trim().split(" : ")[0];
        if (trimmedItem.isNotEmpty) {
          factorsSet.add(trimmedItem);
        }
      }
    }
  }
}
