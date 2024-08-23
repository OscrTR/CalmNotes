import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/models/factor.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:calm_notes/providers/factor_provider.dart';
import 'package:easy_localization/easy_localization.dart';
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

    final List<FlSpot> factorSpots = factorProvider.selectedFactor.isNotEmpty
        ? _convertFactorsToSpots(
            entries, factorProvider.selectedFactor, spotsDate)
        : [];

    final Map<double, Color> gradientColorsStopsMap =
        _createGradientColorStopsMap(entrySpots);

    print(isOnlyNaN(entrySpots));

    return Column(
      children: [
        Stack(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: const EdgeInsets.only(
                  top: 24, bottom: 14, left: 0, right: 20),
              child: LineChart(
                LineChartData(
                  minY: 0,
                  maxY: 10,
                  lineBarsData: _buildLineBarsData(
                      entrySpots,
                      gradientColorsStopsMap,
                      factorProvider,
                      entries,
                      spotsDate,
                      factorSpots),
                  lineTouchData: const LineTouchData(enabled: false),
                  titlesData: _buildTitlesData(spotsDate),
                  gridData: _buildGridData(),
                  borderData: _buildBorderData(),
                ),
              ),
            ),
            if (isOnlyNaN(entrySpots))
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
          ],
        ),
      ],
    );
  }

  List<LineChartBarData> _buildLineBarsData(
      List<FlSpot> entrySpots,
      Map<double, Color> gradientColorsStopsMap,
      factorProvider,
      entries,
      spotsDate,
      factorSpots) {
    return [
      if (!isOnlyNaN(entrySpots))
        _createLineChartBarData(
          spots: entrySpots,
          gradientColors: _createGradientColors(entrySpots),
          dotColor: CustomColors.primaryColor,
          opacity: 1.0,
          isFactor: false,
        ),
      if (factorSpots.isNotEmpty && !isOnlyNaN(factorSpots))
        _createLineChartBarData(
          spots: factorSpots,
          gradientColors: [],
          dotColor: CustomColors.primaryColor.withOpacity(0.3),
          opacity: 0.5,
          isFactor: true,
        ),
      _createLineChartBarData(
        spots: List.generate(
            spotsDate.length, (index) => FlSpot(index.toDouble(), 0)),
        gradientColors: [],
        dotColor: Colors.transparent,
        opacity: 0.0,
        isFactor: false,
      ),
    ];
  }

  LineChartBarData _createLineChartBarData({
    required List<FlSpot> spots,
    required List<Color> gradientColors,
    required Color dotColor,
    required double opacity,
    required bool isFactor,
  }) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      gradient: gradientColors.length > 1
          ? LinearGradient(colors: gradientColors)
          : null,
      color: gradientColors.isEmpty ? dotColor : null,
      barWidth: 3,
      dotData: FlDotData(
        show: true,
        getDotPainter:
            (FlSpot spot, double xPercentage, LineChartBarData bar, int index) {
          final bool shouldShowDot = index > 0 &&
              bar.spots[index - 1].y.isNaN &&
              index < bar.spots.length - 1 &&
              bar.spots[index + 1].y.isNaN;

          return FlDotCirclePainter(
            radius: shouldShowDot ? 4 : 0,
            color: shouldShowDot
                ? !isFactor
                    ? moodColors[spot.y.round()]
                    : dotColor
                : Colors.transparent,
          );
        },
      ),
      belowBarData: BarAreaData(show: false),
    );
  }

  FlTitlesData _buildTitlesData(List<String> spotsDate) {
    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) => _buildBottomTitle(value, spotsDate),
          interval: 1,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) => _buildLeftTitle(value),
          interval: 1,
        ),
      ),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  Widget _buildBottomTitle(double value, List<String> spotsDate) {
    final int index = value.toInt();
    final int modulo = spotsDate.length > 15 ? 2 : 1;
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
          ),
        ],
      );
    }
    return const Text('');
  }

  Widget _buildLeftTitle(double value) {
    final Color color = moodColors[value.toInt()];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(width: 8),
        Center(
          child: Text(
            value.toInt().toString(),
            style:
                Theme.of(context).textTheme.titleMedium?.copyWith(color: color),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      drawHorizontalLine: true,
      horizontalInterval: 1,
      getDrawingHorizontalLine: (value) => FlLine(
        color: CustomColors.secondaryColor.withOpacity(0.3),
        strokeWidth: 1,
      ),
    );
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: Border(
        top: BorderSide(
            color: CustomColors.secondaryColor.withOpacity(0.3), width: 1),
        bottom: BorderSide(
            color: CustomColors.secondaryColor.withOpacity(0.3), width: 1),
        left: BorderSide.none,
        right: BorderSide.none,
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

  List<Factor> _createFactorsList(List<Entry> entries) {
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

  List<FlSpot> _convertFactorsToSpots(
      List<Entry> entries, String factorName, List<String> spotsDate) {
    final factorsList = _createFactorsList(entries);
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
