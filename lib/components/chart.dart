import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chart extends StatefulWidget {
  const Chart({super.key});

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<EntryProvider>();
    final entries = provider.entries;
    final orderedEntries = entries.reversed.toList();

    List<FlSpot> convertEntriesToSpots(List<Entry> entries) {
      return List.generate(entries.length, (index) {
        return FlSpot(index.toDouble(), entries[index].mood.toDouble());
      });
    }

    List<Color> moodColors = [
      AppColors.color0, // Mood 0
      AppColors.color1, // Mood 1
      AppColors.color2, // Mood 2
      AppColors.color3, // Mood 3
      AppColors.color4, // Mood 4
      AppColors.color5, // Mood 5
      AppColors.color6, // Mood 6
      AppColors.color7, // Mood 7
      AppColors.color8, // Mood 8
      AppColors.color9, // Mood 9
      AppColors.color10, // Mood 10
    ];

    List<Color> gradientColors = orderedEntries
        .map((entry) => moodColors[entry.mood.clamp(0, 10)])
        .toList();

    List<double> colorStops = List.generate(orderedEntries.length, (index) {
      return index / (orderedEntries.length - 1);
    });

    return Container(
      height: 250,
      width: 352.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(top: 24, bottom: 14, left: 0, right: 20),
      child: LineChart(
        LineChartData(
          minY: 0,
          maxY: 10,
          lineBarsData: [
            LineChartBarData(
              spots: convertEntriesToSpots(orderedEntries),
              isCurved: true,
              gradient: gradientColors.length > 1
                  ? LinearGradient(colors: gradientColors, stops: colorStops)
                  : null,
              color: gradientColors.length == 1 ? gradientColors.first : null,
              barWidth: 3,
              dotData: const FlDotData(
                show: false,
              ),
              belowBarData: BarAreaData(
                show: false,
              ),
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  int index = value.toInt();
                  if (index >= 0 && index < orderedEntries.length) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          orderedEntries[index].date.substring(8, 10),
                          style: TextStyle(
                              fontSize: 10,
                              color: AppColors.primaryColor.withOpacity(0.3)),
                        )
                      ],
                    );
                  }
                  return const Text('');
                },
                interval: 1,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  Color color;
                  switch (value.toInt()) {
                    case 0:
                      color = AppColors.color0;
                      break;
                    case 1:
                      color = AppColors.color1;
                      break;
                    case 2:
                      color = AppColors.color2;
                      break;
                    case 3:
                      color = AppColors.color3;
                      break;
                    case 4:
                      color = AppColors.color4;
                      break;
                    case 5:
                      color = AppColors.color5;
                      break;
                    case 6:
                      color = AppColors.color6;
                      break;
                    case 7:
                      color = AppColors.color7;
                      break;
                    case 8:
                      color = AppColors.color8;
                      break;
                    case 9:
                      color = AppColors.color9;
                      break;
                    case 10:
                      color = AppColors.color10;
                      break;
                    default:
                      color = AppColors.primaryColor;
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 8,
                      ),
                      Center(
                        child: Text(
                          value.toInt().toString(),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: color),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                    ],
                  );
                },
                interval: 1,
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(
                showTitles: false,
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            drawHorizontalLine: true,
            horizontalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: AppColors.secondaryColor.withOpacity(0.3),
                strokeWidth: 1,
              );
            },
          ),
          borderData: FlBorderData(
            show: true,
            border: Border(
              top: BorderSide(
                  color: AppColors.secondaryColor.withOpacity(0.3), width: 1),
              bottom: BorderSide(
                  color: AppColors.secondaryColor.withOpacity(0.3), width: 1),
              left: BorderSide.none,
              right: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}
