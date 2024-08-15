import 'package:calm_notes/colors.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class CustomPieChart extends StatefulWidget {
  const CustomPieChart({super.key});

  @override
  State<CustomPieChart> createState() => _CustomPieChartState();
}

class _CustomPieChartState extends State<CustomPieChart> {
  bool _showMood = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EntryProvider>();
    final moodData =
        provider.getMoodDistribution(); // Get the mood data from the provider

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
            sections: _buildSections(moodData),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(Map<int, int> moodSumMap) {
    return moodSumMap.entries.map((entry) {
      return PieChartSectionData(
        color: moodColors[entry.key],
        value: entry.value.toDouble(),
        title: _showMood ? '${entry.key}' : '',
        titleStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: CustomColors.primaryColor.withOpacity(0.7),
        ),
      );
    }).toList();
  }
}
