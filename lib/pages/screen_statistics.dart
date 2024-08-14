import 'package:calm_notes/colors.dart';
import 'package:calm_notes/components/calendar.dart';
import 'package:calm_notes/components/chart.dart';
import 'package:calm_notes/components/half_pie_chart.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:calm_notes/providers/factor_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScreenStatistics extends StatefulWidget {
  const ScreenStatistics({super.key});

  @override
  State<ScreenStatistics> createState() => _ScreenStatisticsState();
}

class _ScreenStatisticsState extends State<ScreenStatistics> {
  String rangeType = 'week';
  final DateTime _currentWeek = _getCurrentWeek();
  final DateTime _currentMonth = _getCurrentMonth();
  List<DateTime> _weeks = [];
  List<DateTime> _months = [];
  DateTime? _selectedWeekDate;
  DateTime? _selectedMonthDate;
  final ScrollController _scrollControllerWeeks = ScrollController();
  final ScrollController _scrollControllerMonths = ScrollController();

  @override
  void initState() {
    super.initState();
    _weeks = _generateWeeks();
    _months = _generateMonths();
    _selectedWeekDate = _currentWeek;
    _selectedMonthDate = _currentMonth;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedWeek();
    });
  }

  List<String> _getFactorsList(List<Entry> entries) {
    Set<String> factorsSet = {};

    void processEntry(String? entryString) {
      if (entryString != null && entryString.isNotEmpty) {
        for (var item in entryString.split(',')) {
          var trimmedItem = item.trim().split(" : ")[0];
          if (trimmedItem.isNotEmpty) {
            factorsSet.add(trimmedItem);
          }
        }
      }
    }

    for (var entry in entries) {
      processEntry(entry.emotions);
      processEntry(entry.tags);
    }

    return factorsSet.toList();
  }

  List<Widget> _buildFactorButtonList(
      List<String> factorsList, BuildContext context) {
    return factorsList.map((factor) {
      return OutlinedButton(
          onPressed: () {
            context.read<FactorProvider>().selectFactor(factor);
            Navigator.pop(context, 'Add factor');
          },
          child: Text(factor));
    }).toList();
  }

  static DateTime _getCurrentWeek() {
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    DateTime startOfWeek = now.subtract(Duration(days: weekday - 1));
    // Normalize to midnight to avoid time component issues
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  }

  static DateTime _getCurrentMonth() {
    DateTime now = DateTime.now();
    // Get the first day of the current month
    DateTime startOfMonth = DateTime(now.year, now.month, 1);
    // Normalize to midnight to avoid time component issues
    return DateTime(startOfMonth.year, startOfMonth.month, startOfMonth.day);
  }

  List<DateTime> _generateWeeks() {
    List<DateTime> weeks = [];
    DateTime currentDate = DateTime(DateTime.now().year, 1, 1);
    DateTime endDate = DateTime(DateTime.now().year, 12, 31);

    while (currentDate.isBefore(endDate)) {
      weeks.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 7));
    }

    return weeks;
  }

  List<DateTime> _generateMonths() {
    List<DateTime> months = [];
    DateTime currentDate = DateTime(DateTime.now().year, 1, 1);
    DateTime endDate = DateTime(DateTime.now().year, 12, 31);

    while (currentDate.isBefore(endDate)) {
      months.add(currentDate);
      currentDate = DateTime(currentDate.year, currentDate.month + 1, 1);
    }

    return months;
  }

  void _scrollToSelectedWeek() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_weeks.isNotEmpty && rangeType == 'week') {
        if (_selectedWeekDate == null) return;

        final index = _weeks.indexWhere((date) =>
            date.year == _selectedWeekDate!.year &&
            date.month == _selectedWeekDate!.month &&
            date.day == _selectedWeekDate!.day);

        if (index == -1) return;

        // Assuming each week button has a fixed width of 100 pixels plus padding
        const double weekButtonWidth = 85;
        final offset = (index * (weekButtonWidth)) -
            (MediaQuery.of(context).size.width / 2 - weekButtonWidth / 2) +
            30;

        _scrollControllerWeeks.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _scrollToSelectedMonth() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_months.isNotEmpty && rangeType == 'month') {
        if (_selectedMonthDate == null) return;

        final index = _months.indexWhere((date) =>
            date.year == _selectedMonthDate!.year &&
            date.month == _selectedMonthDate!.month);

        if (index == -1) return;

        // Assuming each week button has a fixed width of 100 pixels plus padding
        const double monthButtonWidth = 85;
        final offset = (index * (monthButtonWidth)) -
            (MediaQuery.of(context).size.width / 2 - monthButtonWidth / 2) +
            30;

        _scrollControllerMonths.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void _showFactorSelectionDialog(List<Entry> entries, BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              backgroundColor: AppColors.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              title: const Text('Factor selection'),
              content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Select a factor to compare with your mood.'),
                    const SizedBox(
                      height: 10,
                    ),
                    Wrap(
                      spacing: 10,
                      children: [
                        ..._buildFactorButtonList(
                            _getFactorsList(entries), context)
                      ],
                    ),
                  ]),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'Add');
                  },
                  child: const Text('Add'),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EntryProvider>();
    final entries = provider.filteredEntries;

    final factorProvider = context.watch<FactorProvider>();

    final List<String> _factorsList = [];
    _getFactorsList(entries);
    return Scaffold(
      body: ListView(
        children: [
          Text(
            'Statistics',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              rangeType == 'week'
                  ? Expanded(
                      child: FilledButton(
                          onPressed: () {}, child: const Text('Week')))
                  : Expanded(
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              rangeType = 'week';
                            });
                            provider.setDefaultWeekDate();
                            _scrollToSelectedWeek();
                          },
                          child: const Text('Week')),
                    ),
              rangeType == 'month'
                  ? Expanded(
                      child: FilledButton(
                          onPressed: () {}, child: const Text('Month')))
                  : Expanded(
                      child: TextButton(
                          onPressed: () {
                            setState(() {
                              rangeType = 'month';
                            });
                            provider.setDefaultMonthDate();
                            _scrollToSelectedMonth();
                          },
                          child: const Text('Month')))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          rangeType == 'week'
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollControllerWeeks,
                  child: Row(
                    children: _weeks.map((date) {
                      String weekLabel = DateFormat('MMM d').format(date);
                      bool isSelectedWeek =
                          date.year == _selectedWeekDate?.year &&
                              date.month == _selectedWeekDate?.month &&
                              date.day == _selectedWeekDate?.day;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: isSelectedWeek
                            ? FilledButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  minimumSize: WidgetStateProperty.all(
                                      const Size(77.0, 40.0)),
                                  maximumSize: WidgetStateProperty.all(
                                      const Size(77.0, 40.0)),
                                ),
                                child: Text(weekLabel),
                              )
                            : OutlinedButton(
                                style: ButtonStyle(
                                  minimumSize: WidgetStateProperty.all(
                                      const Size(77.0, 40.0)),
                                  maximumSize: WidgetStateProperty.all(
                                      const Size(77.0, 40.0)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedWeekDate = date;
                                  });
                                  provider.setStartEndDate(
                                      date,
                                      date
                                          .add(const Duration(days: 7))
                                          .subtract(
                                              const Duration(seconds: 1)));
                                },
                                child: Text(weekLabel),
                              ),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox(),
          rangeType == 'month'
              ? SingleChildScrollView(
                  controller: _scrollControllerMonths,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _months.map((date) {
                      String monthLabel = DateFormat('MMM').format(date);
                      bool isSelectedMonth =
                          date.year == _selectedMonthDate?.year &&
                              date.month == _selectedMonthDate?.month;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: isSelectedMonth
                            ? FilledButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  minimumSize: WidgetStateProperty.all(
                                      const Size(77.0, 40.0)),
                                  maximumSize: WidgetStateProperty.all(
                                      const Size(77.0, 40.0)),
                                ),
                                child: Text(monthLabel),
                              )
                            : OutlinedButton(
                                style: ButtonStyle(
                                  minimumSize: WidgetStateProperty.all(
                                      const Size(77.0, 40.0)),
                                  maximumSize: WidgetStateProperty.all(
                                      const Size(77.0, 40.0)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _selectedWeekDate = date;
                                  });
                                  provider.setStartEndDate(
                                      date,
                                      date
                                          .add(const Duration(days: 7))
                                          .subtract(
                                              const Duration(seconds: 1)));
                                },
                                child: Text(monthLabel),
                              ),
                      );
                    }).toList(),
                  ),
                )
              : const SizedBox(),
          const SizedBox(
            height: 20,
          ),
          if (factorProvider.selectedFactor == '')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Mood graph',
                    style: Theme.of(context).textTheme.titleMedium),
                OutlinedButton(
                    onPressed: () {
                      _showFactorSelectionDialog(entries, context);
                    },
                    child: const Text('Add factor'))
              ],
            ),
          if (factorProvider.selectedFactor != '')
            Row(children: [
              Text('Mood graph vs',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(
                width: 10,
              ),
              FilledButton(
                  onPressed: () {
                    factorProvider.removeFactor();
                  },
                  child: Text(factorProvider.selectedFactor))
            ]),
          const SizedBox(height: 10),
          const Chart(),
          const SizedBox(height: 30),
          Text('Mood calendar', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 20),
          const Calendar(),
          const SizedBox(height: 30),
          Text('Mood distribution',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 20),
          const HalfPieChart(),
        ],
      ),
    );
  }
}
