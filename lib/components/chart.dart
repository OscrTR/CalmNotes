import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/models/factor.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:calm_notes/providers/factor_provider.dart';
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
    final entries = provider.filteredEntries;
    final orderedEntries = entries.reversed.toList();
    List<String> spotsDate = [];
    final startDate = provider.startDate;
    final endDate = provider.endDate;
    final factorProvider = context.watch<FactorProvider>();

    List<Factor> createFactorsList() {
      List<Factor> tempFactorsList = [];

      for (var entry in entries) {
        DateTime date = DateTime.parse(entry.date.split('|')[0]);
        List<String> emotionsList = [];
        List<String> tagsList = [];
        List<String> factorsList = [];

        emotionsList = entry.emotions!.replaceAll(' ', '').split(',');
        tagsList = entry.tags!.replaceAll(' ', '').split(',');
        for (var emotion in emotionsList) {
          if (emotion != '') {
            factorsList.add(emotion);
          }
        }
        for (var tag in tagsList) {
          if (tag != '') {
            factorsList.add(tag);
          }
        }
        for (var factor in factorsList) {
          if (factor != '') {
            Factor newFactor = Factor(
                date: date,
                name: factor.split(':')[0],
                value: int.parse(factor.split(':')[1]));
            tempFactorsList.add(newFactor);
          }
        }
      }
      Map<String, FactorSummary> summaryMap = {};
      // Iterate over each factor to populate the summaryMap
      for (var factor in tempFactorsList) {
        // Create a unique key for each (date, name) combination
        String key = '${factor.date},${factor.name}';

        if (!summaryMap.containsKey(key)) {
          summaryMap[key] = FactorSummary(
            sum: 0,
            count: 0,
          );
        }

        var summary = summaryMap[key]!;
        summary.sum += factor.value;
        summary.count += 1;
      }
      // Create a new list of factors with the average values
      List<Factor> averageFactors = summaryMap.entries.map((entry) {
        var keyParts = entry.key.split(',');
        var date = DateTime.parse(keyParts[0]);
        var name = keyParts[1];
        var summary = entry.value;

        return Factor(
          date: date,
          name: name,
          value: summary.sum ~/ summary.count,
        );
      }).toList();

      return averageFactors;
    }

    List<FlSpot> convertFactorsListToSpots(
        List<Factor> factorsList, String factorName) {
      List<FlSpot> spots = [];
      int index = 0;

      int? getValueForDateAndFactor(
          List<Factor> factors, DateTime date, String factorName) {
        for (var factor in factors) {
          if (factor.date == date && factor.name == factorName) {
            return factor.value;
          }
        }
        return null;
      }

      for (var date in spotsDate) {
        DateTime factorDate = DateTime.parse(date);
        // Si date contien un facteur avec le nom, ajouter un spot avec la valeur
        int? factorValue =
            getValueForDateAndFactor(factorsList, factorDate, factorName);
        if (factorValue != null) {
          spots.add(FlSpot(index.toDouble(), factorValue.toDouble()));
        } else {
          spots.add(FlSpot.nullSpot);
        }
        index++;
      }

      return spots;
    }

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
      Map<String, double> moodTotalMap = {};
      Map<String, int> moodCountMap = {};

      // Populate the moodMap with entries
      for (var entry in entries) {
        String date = entry.date.substring(0, 10);
        // Accumulate the mood values for each date
        if (moodTotalMap.containsKey(date)) {
          moodTotalMap[date] = moodTotalMap[date]! + entry.mood.toDouble();
          moodCountMap[date] = moodCountMap[date]! + 1;
        } else {
          moodTotalMap[date] = entry.mood.toDouble();
          moodCountMap[date] = 1;
        }
      }
      Map<String, double> moodAverageMap = {};

      for (var date in moodTotalMap.keys) {
        moodAverageMap[date] = moodTotalMap[date]! / moodCountMap[date]!;
      }

      List<FlSpot> spots = [];
      int index = 0;

      for (var date in spotsDate) {
        if (moodAverageMap.containsKey(date)) {
          spots.add(FlSpot(index.toDouble(), moodAverageMap[date]!));
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

    List<Color> createGradientColors(List<FlSpot> spotsList) {
      List<Color> result = [];
      for (var spot in spotsList) {
        if (!spot.y.isNaN) {
          result.add(moodColors[spot.y.round()]);
        }
      }

      return result;
    }

    Map<double, Color> gradientColorsStopsMap = {};

    Map<double, Color> createGradientColorStopsMap(List<FlSpot> spotsList) {
      if (spotsList.isEmpty) return {};
      List<FlSpot> nonNullSpots =
          spotsList.where((spot) => !(spot.x.isNaN || spot.y.isNaN)).toList();

      if (nonNullSpots.isEmpty) return {};

      // Create a map to store the color stops
      Map<double, Color> result = {};

      // Get the minimum and maximum x values to normalize the x positions
      double minX = nonNullSpots.first.x;
      double maxX = nonNullSpots.last.x;
      double rangeX = maxX - minX;

      for (var spot in nonNullSpots) {
        // Normalize the x position to a value between 0 and 1
        double normalizedX = (spot.x - minX) / rangeX;
        // Get the corresponding color
        Color color = moodColors[spot.y.round()];
        // Add the normalized position and color to the map
        result[normalizedX] = color;
      }

      return result;
    }

    gradientColorsStopsMap = createGradientColorStopsMap(entrySpots);

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
                if (!isOnlyNaN(entrySpots))
                  LineChartBarData(
                    spots: entrySpots,
                    isCurved: true,
                    gradient: createGradientColors(entrySpots).length > 1
                        ? LinearGradient(
                            colors: gradientColorsStopsMap.values.toList(),
                            stops: gradientColorsStopsMap.keys.toList())
                        : null,
                    color: createGradientColors(entrySpots).length == 1
                        ? CustomColors.primaryColor
                        : null,
                    barWidth: 3,
                    dotData: const FlDotData(
                      show: false,
                    ),
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                  ),
                if (factorProvider.selectedFactor != '')
                  LineChartBarData(
                    color: CustomColors.primaryColor.withOpacity(0.5),
                    spots: convertFactorsListToSpots(
                        createFactorsList(), factorProvider.selectedFactor),
                    barWidth: 3,
                    dotData: const FlDotData(
                      show: true,
                    ),
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                  ),
                LineChartBarData(
                  color: Colors.transparent,
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
                                  color: CustomColors.primaryColor
                                      .withOpacity(0.3)),
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
                          color = CustomColors.color0;
                          break;
                        case 1:
                          color = CustomColors.color1;
                          break;
                        case 2:
                          color = CustomColors.color2;
                          break;
                        case 3:
                          color = CustomColors.color3;
                          break;
                        case 4:
                          color = CustomColors.color4;
                          break;
                        case 5:
                          color = CustomColors.color5;
                          break;
                        case 6:
                          color = CustomColors.color6;
                          break;
                        case 7:
                          color = CustomColors.color7;
                          break;
                        case 8:
                          color = CustomColors.color8;
                          break;
                        case 9:
                          color = CustomColors.color9;
                          break;
                        case 10:
                          color = CustomColors.color10;
                          break;
                        default:
                          color = CustomColors.primaryColor;
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
                    color: CustomColors.secondaryColor.withOpacity(0.3),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(
                show: true,
                border: Border(
                  top: BorderSide(
                      color: CustomColors.secondaryColor.withOpacity(0.3),
                      width: 1),
                  bottom: BorderSide(
                      color: CustomColors.secondaryColor.withOpacity(0.3),
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
