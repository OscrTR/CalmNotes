import 'package:calm_notes/colors.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:easy_localization/easy_localization.dart';
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
    final moodData = provider.getMoodDistribution();

    print(moodData);

    return GestureDetector(
      onTap: () {
        setState(() {
          _showMood = !_showMood;
        });
      },
      child: Stack(children: [
        Container(
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding:
              const EdgeInsets.only(top: 24, bottom: 24, left: 0, right: 20),
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 70,
              sections: _buildSections(moodData),
            ),
          ),
        ),
        if (moodData.isEmpty)
          Positioned(
            child: Container(
              height: 250,
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
