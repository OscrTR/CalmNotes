import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    List<String> spotsDate = [];
    final startDate = provider.startDate;
    final endDate = provider.endDate;

    List<String> generateFullDateRange() {
      List<String> dateRange = [];
      for (var date = startDate;
          date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
          date = date.add(const Duration(days: 1))) {
        dateRange.add(DateFormat('yyyy-MM-dd').format(date));
      }
      return dateRange;
    }

    spotsDate = generateFullDateRange();

    List<FlSpot> getInvisibleSpots() {
      return List.generate(
        spotsDate.length,
        (index) => FlSpot(index.toDouble(), 0),
      );
    }

    // Function to convert entries to FlSpots with gaps for missing dates
    List<FlSpot> convertEntriesToSpots(List<Entry> entries) {
      final Map<String, double> moodMap = {};

      // Populate the moodMap with entries
      for (var entry in entries) {
        String date = entry.date.substring(0, 10);
        moodMap[date] = entry.mood.toDouble();
      }

      List<FlSpot> spots = [];
      int index = 0;

      for (var date in spotsDate) {
        if (moodMap.containsKey(date)) {
          spots.add(FlSpot(index.toDouble(), moodMap[date]!));
        } else {
          spots.add(FlSpot.nullSpot);
        }
        index++;
      }

      return spots;
    }

    final entrySpots = convertEntriesToSpots(orderedEntries);

    bool isOnlyNaN(List<FlSpot> spots) {
      bool onlyNaN = true;
      for (var spot in spots) {
        if (!spot.y.isNaN) {
          onlyNaN = false;
        }
      }
      return onlyNaN;
    }

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

    List<Color> createGradientColors(List<FlSpot> spotsList) {
      List<Color> result = [];
      for (var spot in spotsList) {
        if (!spot.y.isNaN) {
          result.add(moodColors[spot.y.toInt()]);
        }
      }
      return result;
    }

    final gradientColors = createGradientColors(entrySpots);

    List<double> createColorStops(List<FlSpot> spotsList) {
      List<double> stops = [];

      double increment = 1 / (gradientColors.length - 1);

      int colorIndex = 0;
      for (var i = 0; i < spotsList.length; i++) {
        if (!spotsList[i].y.isNaN) {
          stops.add(colorIndex * increment);
          colorIndex += 1;
        }
      }

      return stops;
    }

    return Column(
      children: [
        Container(
          height: 250,
          width: 352.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          padding:
              const EdgeInsets.only(top: 24, bottom: 14, left: 0, right: 20),
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 10,
              lineBarsData: [
                !isOnlyNaN(entrySpots)
                    ? LineChartBarData(
                        spots: entrySpots,
                        isCurved: true,
                        gradient: createGradientColors(entrySpots).length > 1
                            ? LinearGradient(
                                colors: createGradientColors(entrySpots),
                                stops: createColorStops(entrySpots))
                            : null,
                        color: createGradientColors(entrySpots).length == 1
                            ? AppColors.primaryColor
                            : null,
                        barWidth: 3,
                        dotData: const FlDotData(
                          show: false,
                        ),
                        belowBarData: BarAreaData(
                          show: false,
                        ),
                      )
                    : LineChartBarData(),
                LineChartBarData(
                  spots: getInvisibleSpots(),
                  barWidth: 0,
                  dotData: const FlDotData(
                    show: false,
                  ),
                  belowBarData: BarAreaData(
                    show: false,
                  ),
                ),
              ],
              lineTouchData: const LineTouchData(enabled: false),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int index = value.toInt();
                      int modulo = spotsDate.length > 15 ? 2 : 1;
                      if (index >= 0 &&
                          index < spotsDate.length &&
                          value % modulo == 0) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              spotsDate[index].substring(8, 10),
                              style: TextStyle(
                                  fontSize: 10,
                                  color:
                                      AppColors.primaryColor.withOpacity(0.3)),
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
                      color: AppColors.secondaryColor.withOpacity(0.3),
                      width: 1),
                  bottom: BorderSide(
                      color: AppColors.secondaryColor.withOpacity(0.3),
                      width: 1),
                  left: BorderSide.none,
                  right: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
