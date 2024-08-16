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
    final entryProvider = context.watch<EntryProvider>();
    final factorProvider = context.watch<FactorProvider>();

    final List<Entry> entries = entryProvider.filteredEntries;
    final List<Entry> orderedEntries = entries.reversed.toList();
    final DateTime startDate = entryProvider.startDate;
    final DateTime endDate = entryProvider.endDate;

    final List<String> spotsDate = _generateFullDateRange(startDate, endDate);

    final List<FlSpot> entrySpots =
        _convertEntriesToSpots(orderedEntries, spotsDate);

    final Map<double, Color> gradientColorsStopsMap =
        _createGradientColorStopsMap(entrySpots);

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
                    gradient: _createGradientColors(entrySpots).length > 1
                        ? LinearGradient(
                            colors: gradientColorsStopsMap.values.toList(),
                            stops: gradientColorsStopsMap.keys.toList())
                        : null,
                    color: _createGradientColors(entrySpots).length == 1
                        ? CustomColors.primaryColor
                        : null,
                    barWidth: 3,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                if (factorProvider.selectedFactor.isNotEmpty &&
                    !isOnlyNaN(_convertFactorsListToSpots(
                        createFactorsList(entries),
                        factorProvider.selectedFactor,
                        spotsDate)))
                  LineChartBarData(
                    color: CustomColors.primaryColor.withOpacity(0.5),
                    spots: _convertFactorsListToSpots(
                        createFactorsList(entries),
                        factorProvider.selectedFactor,
                        spotsDate),
                    barWidth: 3,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(show: false),
                  ),
                LineChartBarData(
                  color: Colors.transparent,
                  spots: List.generate(
                      spotsDate.length, (index) => FlSpot(index.toDouble(), 0)),
                  barWidth: 0,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: false),
                ),
              ],
              lineTouchData: const LineTouchData(enabled: false),
              titlesData: _buildTitlesData(spotsDate),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                drawHorizontalLine: true,
                horizontalInterval: 1,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: CustomColors.secondaryColor.withOpacity(0.3),
                  strokeWidth: 1,
                ),
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

  FlTitlesData _buildTitlesData(List<String> spotsDate) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            int index = value.toInt();
            int modulo = spotsDate.length > 15 ? 2 : 1;
            if (index >= 0 && index < spotsDate.length && value % modulo == 0) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    spotsDate[index].substring(8, 10),
                    style: TextStyle(
                        fontSize: 10,
                        color: CustomColors.primaryColor.withOpacity(0.3)),
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
            Color color = moodColors[value.toInt()];

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
    );
  }

  // Generate the full date range between startDate and endDate
  List<String> _generateFullDateRange(DateTime startDate, DateTime endDate) {
    return List.generate(
      endDate.difference(startDate).inDays + 1,
      (i) => DateFormat('yyyy-MM-dd').format(startDate.add(Duration(days: i))),
    );
  }

  // Function to convert entries to FlSpots with gaps for missing dates
  List<FlSpot> _convertEntriesToSpots(
      List<Entry> entries, List<String> spotsDate) {
    final Map<String, double> moodTotalMap = {};
    final Map<String, int> moodCountMap = {};

    // Populate the moodMap with entries
    for (var entry in entries) {
      final String date = entry.date.substring(0, 10);
      // Accumulate the mood values for each date
      moodTotalMap.update(date, (val) => val + entry.mood.toDouble(),
          ifAbsent: () => entry.mood.toDouble());
      moodCountMap.update(date, (val) => val + 1, ifAbsent: () => 1);
    }

    final List<FlSpot> spots = [];
    for (var i = 0; i < spotsDate.length; i++) {
      final date = spotsDate[i];
      spots.add(moodTotalMap.containsKey(date)
          ? FlSpot(i.toDouble(), moodTotalMap[date]! / moodCountMap[date]!)
          : FlSpot.nullSpot);
    }

    return spots;
  }

// Check if all spots contain NaN values
  bool isOnlyNaN(List<FlSpot> spots) {
    return spots.every((spot) => spot.y.isNaN);
  }

  List<Factor> createFactorsList(List<Entry> entries) {
    final List<Factor> tempFactorsList = [];

    for (var entry in entries) {
      final DateTime date = DateTime.parse(entry.date.split('|')[0]);
      final List<String> factorsList = [
        ...entry.emotions
                ?.split(',')
                .map((emotion) => emotion.trim())
                .where((emotion) => emotion.isNotEmpty)
                .toList() ??
            [],
        ...entry.tags
                ?.split(',')
                .map((tag) => tag.trim())
                .where((tag) => tag.isNotEmpty)
                .toList() ??
            [],
      ];

      for (var factor in factorsList.where((f) => f.isNotEmpty)) {
        final parts = factor.split(':').map((e) => e.trim()).toList();
        tempFactorsList.add(
            Factor(date: date, name: parts[0], value: double.parse(parts[1])));
      }
    }

    final Map<String, FactorSummary> summaryMap = {};
    for (var factor in tempFactorsList) {
      final key = '${factor.date},${factor.name}';
      summaryMap.update(
          key,
          (summary) => summary
            ..sum += factor.value.toInt()
            ..count += 1,
          ifAbsent: () => FactorSummary(sum: factor.value, count: 1));
    }

    return summaryMap.entries.map((entry) {
      final keyParts = entry.key.split(',');
      return Factor(
          date: DateTime.parse(keyParts[0]),
          name: keyParts[1],
          value: entry.value.sum / entry.value.count);
    }).toList();
  }

  List<FlSpot> _convertFactorsListToSpots(
      List<Factor> factorsList, String factorName, List<String> spotsDate) {
    final List<FlSpot> spots = [];

    double? findFactorValue(
        List<Factor> factors, DateTime date, String factorName) {
      for (var factor in factors) {
        if (factor.date == date && factor.name == factorName) {
          return factor.value;
        }
      }
      return null;
    }

    FlSpot createSpot(int index, double? factorValue) {
      return factorValue != null
          ? FlSpot(index.toDouble(), factorValue.toDouble())
          : FlSpot.nullSpot;
    }

    for (int i = 0; i < spotsDate.length; i++) {
      DateTime factorDate = DateTime.parse(spotsDate[i]);
      double? factorValue =
          findFactorValue(factorsList, factorDate, factorName);
      spots.add(createSpot(i, factorValue));
    }

    return spots;
  }

  List<Color> _createGradientColors(List<FlSpot> spotsList) {
    return spotsList
        .where((spot) => !spot.y.isNaN)
        .map((spot) => moodColors[spot.y.round()])
        .toList();
  }

  Map<double, Color> _createGradientColorStopsMap(List<FlSpot> spotsList) {
    final nonNullSpots =
        spotsList.where((spot) => !(spot.x.isNaN || spot.y.isNaN)).toList();
    if (nonNullSpots.isEmpty) return {};

    final minX = nonNullSpots.first.x;
    final maxX = nonNullSpots.last.x;
    final rangeX = maxX - minX;

    return {
      for (var spot in nonNullSpots)
        (spot.x - minX) / rangeX: moodColors[spot.y.round()]
    };
  }
}
