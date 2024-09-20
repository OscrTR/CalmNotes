import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  bool _showSmileys = false;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EntryProvider>(context);
    final entries = provider.filteredEntries;

    Map<DateTime, int> entryMap = _convertEntriesToMap(entries);

    final firstDayOfWeek = _mostRecentMonday(provider.startDate);
    final totalDays = provider.calendarDays;

    final numberOfRows = (totalDays / 7).ceil();

    final localizedDays = _getLocalizedDays(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _showSmileys = !_showSmileys;
        });
      },
      child: Stack(children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            children: [
              _buildDayOfWeekHeader(localizedDays),
              const SizedBox(height: 14),
              _buildCalendarGrid(entryMap, totalDays, firstDayOfWeek,
                  provider.startDate, provider.endDate, numberOfRows),
            ],
          ),
        ),
        if (entries.isEmpty)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CustomColors.primaryColor.withOpacity(0.3),
              ),
              child: Center(
                child: Text(
                  tr('statistics_no_data'),
                ),
              ),
            ),
          ),
      ]),
    );
  }

  Map<DateTime, int> _convertEntriesToMap(List<Entry> entries) {
    Map<DateTime, double> moodTotalMap = {};
    Map<DateTime, int> moodCountMap = {};

    for (var entry in entries) {
      DateTime date = DateTime.parse(entry.date.split('|')[0]);
      if (moodTotalMap.containsKey(date)) {
        moodTotalMap[date] = moodTotalMap[date]! + entry.mood.toDouble();
        moodCountMap[date] = moodCountMap[date]! + 1;
      } else {
        moodTotalMap[date] = entry.mood.toDouble();
        moodCountMap[date] = 1;
      }
    }

    return moodTotalMap.map((date, totalMood) =>
        MapEntry(date, (totalMood / moodCountMap[date]!).round()));
  }

  DateTime _mostRecentMonday(DateTime date) =>
      DateTime(date.year, date.month, date.day - (date.weekday - 1));

  List<String> _getLocalizedDays(BuildContext context) {
    final Locale currentLocale = Localizations.localeOf(context);
    DateFormat dayFormat = DateFormat.E(currentLocale.toString());

    DateTime baseMonday = DateTime(2023, 8, 14);

    return List.generate(7, (i) {
      DateTime date = baseMonday.add(Duration(days: i));
      String dayAbbreviation = dayFormat.format(date).replaceAll('.', '');
      return dayAbbreviation.substring(0, 1).toUpperCase() +
          dayAbbreviation.substring(1).toLowerCase();
    });
  }

  Widget _buildDayOfWeekHeader(List<String> localizedDays) {
    return LayoutGrid(
      columnSizes: List.filled(7, 1.fr),
      rowSizes: const [auto],
      children: localizedDays
          .map(
            (day) => Center(
              child: Container(
                width: 44.68,
                alignment: Alignment.center,
                child: Text(
                  day,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: CustomColors.ternaryColor,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildCalendarGrid(
      Map<DateTime, int> entryMap,
      int totalDays,
      DateTime firstDayOfWeek,
      DateTime startDate,
      DateTime endDate,
      int numberOfRows) {
    return LayoutGrid(
      columnSizes: List.filled(7, 1.fr),
      rowSizes: List.generate(numberOfRows, (index) => auto),
      children: List.generate(totalDays, (i) {
        DateTime currentDate = firstDayOfWeek.add(Duration(days: i));
        bool isInRange =
            currentDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
                currentDate.isBefore(endDate.add(const Duration(days: 1)));

        Color currentDateColor = entryMap.containsKey(currentDate)
            ? moodColors[entryMap[currentDate]!]
            : CustomColors.primaryColor.withOpacity(0.1);

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: isInRange ? currentDateColor : Colors.transparent,
              shape: BoxShape.circle),
          child: Center(
            child: Stack(
              children: [
                const SizedBox(height: 24.7, width: 24.7),
                if (isInRange &&
                    entryMap.containsKey(currentDate) &&
                    _showSmileys)
                  SvgPicture.asset(
                    'assets/images/mood${entryMap[currentDate]}.svg',
                    height: 24.7,
                    width: 24.7,
                  )
              ],
            ),
          ),
        );
      }),
    );
  }
}
