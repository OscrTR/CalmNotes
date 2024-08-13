import 'package:calm_notes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  final int daysInMonth = DateTime.now().month == 2
      ? (DateTime.now().year % 4 == 0 ? 29 : 28)
      : [4, 6, 9, 11].contains(DateTime.now().month)
          ? 30
          : 31;

  List<Widget> _buildCalendarDays() {
    final firstDayOfMonth =
        DateTime(DateTime.now().year, DateTime.now().month, 1);
    final startingWeekday = firstDayOfMonth.weekday %
        7; // Weekday returns 1 (Monday) to 7 (Sunday), adjust to 0 (Sunday) to 6 (Saturday)

    List<Widget> dayWidgets = [];

    // Empty cells for the days before the first day of the month
    for (int i = 0; i < startingWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Add the days of the month
    for (int day = 1; day <= daysInMonth; day++) {
      dayWidgets.add(
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(90),
          ),
          child: Center(
            child: Text(
              day.toString(),
              style: const TextStyle(fontSize: 16, color: Colors.transparent),
            ),
          ),
        ),
      );
    }

    return dayWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: 352.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(top: 24, bottom: 14, left: 20, right: 20),
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
            rowSizes: List.generate((daysInMonth / 7).ceil(), (index) => auto),
            children: _buildCalendarDays(),
          ),
        ],
      ),
    );
  }
}
