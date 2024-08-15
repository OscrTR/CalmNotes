import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/providers/entry_provider.dart'; // Adjust import based on your file structure
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
    // Fetch the EntryProvider from the context
    final provider = Provider.of<EntryProvider>(context);
    final startDate = provider.startDate;
    final endDate = provider.endDate;
    final entries = provider.filteredEntries;

    Map<DateTime, int> entryMap = {};

    List<Color> moodColors = [
      CustomColors.color0,
      CustomColors.color1,
      CustomColors.color2,
      CustomColors.color3,
      CustomColors.color4,
      CustomColors.color5,
      CustomColors.color6,
      CustomColors.color7,
      CustomColors.color8,
      CustomColors.color9,
      CustomColors.color10,
    ];

    Map<DateTime, int> convertEntriesToMap(List<Entry> entries) {
      Map<DateTime, double> moodTotalMap = {};
      Map<DateTime, int> moodCountMap = {};

      // Populate the moodMap with entries
      for (var entry in entries) {
        DateTime date = DateTime.parse(entry.date.split('|')[0]);
        // Accumulate the mood values for each date
        if (moodTotalMap.containsKey(date)) {
          moodTotalMap[date] = moodTotalMap[date]! + entry.mood.toDouble();
          moodCountMap[date] = moodCountMap[date]! + 1;
        } else {
          moodTotalMap[date] = entry.mood.toDouble();
          moodCountMap[date] = 1;
        }
      }
      Map<DateTime, int> moodAverageMap = {};

      for (var date in moodTotalMap.keys) {
        moodAverageMap[date] =
            (moodTotalMap[date]! / moodCountMap[date]!).round();
      }

      return moodAverageMap;
    }

    entryMap = convertEntriesToMap(entries);

    final firstDayOfRange =
        DateTime(startDate.year, startDate.month, startDate.day);
    final lastDayOfRange =
        endDate.isBefore(DateTime(startDate.year, startDate.month + 1, 0))
            ? endDate
            : DateTime(startDate.year, startDate.month + 1, 0);

    final firstDayOfWeek =
        firstDayOfRange.subtract(Duration(days: firstDayOfRange.weekday % 7));

    final totalDays = lastDayOfRange.difference(firstDayOfWeek).inDays + 1;

    final numberOfRows = ((totalDays + 6) / 7).ceil(); // Number of weeks

    List<Widget> buildCalendarDays() {
      List<Widget> dayWidgets = [];
      for (int i = 0; i < totalDays; i++) {
        DateTime currentDate = firstDayOfWeek.add(Duration(days: i));
        bool isInRange =
            currentDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
                currentDate.isBefore(endDate.add(const Duration(days: 1)));

        Color currentDateColor = entryMap.containsKey(currentDate)
            ? moodColors[entryMap[currentDate]!]
            : CustomColors.primaryColor.withOpacity(0.1);

        dayWidgets.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: isInRange ? currentDateColor : Colors.transparent,
              borderRadius: BorderRadius.circular(90),
            ),
            child: Center(
                child: Stack(
              children: [
                const SizedBox(
                  height: 24.7,
                  width: 24.7,
                ),
                if (isInRange &&
                    entryMap.containsKey(currentDate) &&
                    _showSmileys)
                  SvgPicture.asset(
                    'assets/images/mood${entryMap[currentDate]}.svg',
                    height: 24.7,
                    width: 24.7,
                  )
              ],
            )),
          ),
        );
      }

      return dayWidgets;
    }

    final Locale currentLocale = context.locale;
    List<String> localizedDays = [];
    DateFormat dayFormat = DateFormat.E(currentLocale.toString());
    for (int i = 0; i < 7; i++) {
      DateTime date = DateTime(2023, 8, 13 + i);
      String dayAbbreviation = dayFormat.format(date);

      // Remove trailing dot if present
      if (dayAbbreviation.endsWith('.')) {
        dayAbbreviation =
            dayAbbreviation.substring(0, dayAbbreviation.length - 1);
      }

      // Capitalize the first letter and make the rest lowercase
      String formattedDay = dayAbbreviation.substring(0, 1).toUpperCase() +
          dayAbbreviation.substring(1).toLowerCase();

      localizedDays.add(formattedDay);
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _showSmileys = !_showSmileys;
        });
      },
      child: Container(
        width: 352.7,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        padding:
            const EdgeInsets.only(top: 24, bottom: 24, left: 20, right: 20),
        child: Column(
          children: [
            // Day of the week header
            LayoutGrid(
                columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
                rowSizes: const [auto],
                children: localizedDays
                    .map(
                      (day) => Container(
                        width: 44.68,
                        alignment: Alignment.center,
                        child: Text(
                          day,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: CustomColors.ternaryColor),
                        ),
                      ),
                    )
                    .toList()),
            const SizedBox(height: 14),
            // Calendar grid
            LayoutGrid(
              columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
              rowSizes: List.generate(numberOfRows, (index) => auto),
              children: buildCalendarDays(),
            ),
          ],
        ),
      ),
    );
  }
}
