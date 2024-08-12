import 'package:calm_notes/components/chart.dart';
import 'package:calm_notes/providers/entry_provider.dart';
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
  final DateTime _currentWeekStartDate = _getCurrentWeekStartDate();
  List<DateTime> _weekStartDates = [];
  DateTime? _selectedWeekDate;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _weekStartDates = _generateWeekStartDates();
    _selectedWeekDate = _currentWeekStartDate;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedWeek();
    });
  }

  static DateTime _getCurrentWeekStartDate() {
    DateTime now = DateTime.now();
    int weekday = now.weekday;
    // Get the start of the week (Monday), adjust if needed
    DateTime startOfWeek = now.subtract(Duration(days: weekday - 1));
    // Normalize to midnight to avoid time component issues
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  }

  List<DateTime> _generateWeekStartDates() {
    List<DateTime> weekStartDates = [];
    DateTime currentDate = DateTime(DateTime.now().year, 1, 1);
    DateTime endDate = DateTime(DateTime.now().year, 12, 31);

    while (currentDate.isBefore(endDate)) {
      weekStartDates.add(currentDate);
      currentDate = currentDate.add(const Duration(days: 7));
    }

    return weekStartDates;
  }

  void _scrollToSelectedWeek() {
    if (_selectedWeekDate == null) return;

    final index = _weekStartDates.indexWhere((date) =>
        date.year == _selectedWeekDate!.year &&
        date.month == _selectedWeekDate!.month &&
        date.day == _selectedWeekDate!.day);

    if (index == -1) return;

    // Assuming each week button has a fixed width of 100 pixels plus padding
    const double weekButtonWidth = 85;
    final offset = (index * (weekButtonWidth)) -
        (MediaQuery.of(context).size.width / 2 - weekButtonWidth / 2) +
        30;

    _scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EntryProvider>();
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Statistics',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {
                    rangeType = 'week';
                  },
                  child: const Text('Week')),
              TextButton(
                  onPressed: () {
                    rangeType = 'month';
                  },
                  child: const Text('Month'))
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: Row(
              children: _weekStartDates.map((date) {
                String weekLabel = DateFormat('MMM d').format(date);
                bool isSelectedWeek = date.year == _selectedWeekDate?.year &&
                    date.month == _selectedWeekDate?.month &&
                    date.day == _selectedWeekDate?.day;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: isSelectedWeek
                      ? FilledButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            minimumSize:
                                WidgetStateProperty.all(const Size(77.0, 40.0)),
                            maximumSize:
                                WidgetStateProperty.all(const Size(77.0, 40.0)),
                          ),
                          child: Text(weekLabel),
                        )
                      : OutlinedButton(
                          style: ButtonStyle(
                            minimumSize:
                                WidgetStateProperty.all(const Size(77.0, 40.0)),
                            maximumSize:
                                WidgetStateProperty.all(const Size(77.0, 40.0)),
                          ),
                          onPressed: () {
                            setState(() {
                              _selectedWeekDate = date;
                            });
                            provider.setStartEndDate(
                                date,
                                date
                                    .add(const Duration(days: 7))
                                    .subtract(const Duration(seconds: 1)));
                          },
                          child: Text(weekLabel),
                        ),
                );
              }).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Mood graph',
                  style: Theme.of(context).textTheme.titleMedium),
              OutlinedButton(onPressed: () {}, child: const Text('Add factor'))
            ],
          ),
          const SizedBox(height: 10),
          const Chart(),
        ],
      ),
    );
  }
}
