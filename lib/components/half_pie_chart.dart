import 'package:calm_notes/colors.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class HalfPieChart extends StatefulWidget {
  const HalfPieChart({super.key});

  @override
  State<HalfPieChart> createState() => _HalfPieChartState();
}

class _HalfPieChartState extends State<HalfPieChart> {
  int? touchedIndex;
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EntryProvider>();
    final entries = provider.filteredEntries;

    List moodSumList = [];
    Map<int, int> moodSumMap = {};

    void getMoodSumList() {
      for (var i = 0; i < 11; i++) {
        int result = entries.where((element) => element.mood == i).length;
        if (result > 0) {
          moodSumList.add(result);
          moodSumMap.putIfAbsent(i, () => result);
        }
      }
    }

    getMoodSumList();

    Color getColor(int mood) {
      // List of colors corresponding to mood
      final colors = [
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
        AppColors.color10
      ];
      return mood >= 0 && mood < colors.length ? colors[mood] : Colors.red;
    }

    List<PieChartSectionData> showingSections() {
      int index = -1;
      return moodSumMap.entries.map((entry) {
        index++;
        final isTouched = index == touchedIndex;
        return PieChartSectionData(
          color: getColor(entry.key),
          value: entry.value.toDouble(),
          title: isTouched ? '${entry.key}' : '',
          titleStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor.withOpacity(0.7)),
        );
      }).toList();
    }

    return Container(
      height: 250,
      width: 352.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(top: 24, bottom: 24, left: 0, right: 20),
      child: PieChart(
        PieChartData(
          sectionsSpace: 2,
          centerSpaceRadius: 70,
          pieTouchData: PieTouchData(
            enabled: true,
            touchCallback: (FlTouchEvent event, pieTouchResponse) {
              setState(() {
                if (!event.isInterestedForInteractions ||
                    pieTouchResponse == null ||
                    pieTouchResponse.touchedSection == null) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex =
                    pieTouchResponse.touchedSection!.touchedSectionIndex;
              });
            },
          ),
          sections: showingSections(),
        ),
      ),
    );
  }
}
