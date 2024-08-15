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
  bool _showMood = false;
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

    List<PieChartSectionData> showingSections() {
      return moodSumMap.entries.map((entry) {
        return PieChartSectionData(
          color: moodColors[entry.key],
          value: entry.value.toDouble(),
          title: _showMood ? '${entry.key}' : '',
          titleStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: CustomColors.primaryColor.withOpacity(0.7)),
        );
      }).toList();
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _showMood = !_showMood;
        });
      },
      child: Container(
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
            sections: showingSections(),
          ),
        ),
      ),
    );
  }
}
