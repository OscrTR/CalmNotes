import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/providers/entry_provider.dart'; // Adjust import based on your file structure
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch the EntryProvider from the context
    final provider = Provider.of<EntryProvider>(context);
    final startDate = provider.startDate;
    final endDate = provider.endDate;
    final entries = provider.filteredEntries;

    Map<DateTime, int> entryMap = {};

    List<Color> moodColors = [
      AppColors.color0,
      AppColors.color1,
      AppColors.color2,
      AppColors.color3,
      AppColors.color4,
      AppColors.color5,
      AppColors.color6,
      AppColors.color7,
      AppColors.color8,
      AppColors.color9,
      AppColors.color10,
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
            : AppColors.primaryColor.withOpacity(0.1);

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
                Text(
                  currentDate.day.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.transparent,
                  ),
                ),
                isInRange && entryMap.containsKey(currentDate)
                    ? SvgPicture.asset(
                        'assets/images/mood${entryMap[currentDate]}.svg')
                    : const SizedBox()
              ],
            )),
          ),
        );
      }

      return dayWidgets;
    }

    return Container(
      width: 352.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(top: 24, bottom: 24, left: 20, right: 20),
      child: Column(
        children: [
          // Day of the week header
          LayoutGrid(
            columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
            rowSizes: const [auto],
            children: [
              for (var day in ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'])
                Center(
                    child: Text(day,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.ternaryColor))),
            ],
          ),
          const SizedBox(height: 14),
          // Calendar grid
          LayoutGrid(
            columnSizes: [1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr, 1.fr],
            rowSizes: List.generate(numberOfRows, (index) => auto),
            children: buildCalendarDays(),
          ),
        ],
      ),
    );
  }
}
