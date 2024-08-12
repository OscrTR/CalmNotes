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
  DateTime _currentWeekStartDate = _getCurrentWeekStartDate();
  List<DateTime> _weekStartDates = [];
  DateTime? _selectedWeekDate;

  @override
  void initState() {
    super.initState();
    _weekStartDates = _generateWeekStartDates();
    _selectedWeekDate = _currentWeekStartDate;
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

  bool _isCurrentWeek(DateTime date) {
    return date.year == _currentWeekStartDate.year &&
        date.month == _currentWeekStartDate.month &&
        date.day == _currentWeekStartDate.day;
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
            child: Row(
              children: _weekStartDates.map((date) {
                String weekLabel = DateFormat('MMM d').format(date);
                bool isSelectedWeek = date == _selectedWeekDate;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: isSelectedWeek
                      ? FilledButton(
                          onPressed: () {},
                          child: Text(weekLabel),
                        )
                      : OutlinedButton(
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
