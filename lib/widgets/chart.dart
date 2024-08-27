import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:easy_localization/easy_localization.dart';
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
    final entryProvider = context.watch<EntryProvider>();
    final List<Entry> entries = entryProvider.filteredEntries;
    final List<String> spotsDate = entryProvider.spotsDate;
    final List<FlSpot> entrySpots = entryProvider.entrySpots;
    final List<FlSpot> factorSpots = entryProvider.factorSpots;
    final Map<double, Color> gradientColorsStopsMap =
        entryProvider.gradientColorsStopsMap;

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
                      entryProvider,
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
      preventCurveOverShooting: true,
      gradient: gradientColors.length > 1
          ? LinearGradient(colors: gradientColors)
          : null,
      color: gradientColors.isEmpty ? dotColor : null,
      barWidth: 3,
      dotData: FlDotData(
        show: true,
        getDotPainter:
            (FlSpot spot, double xPercentage, LineChartBarData bar, int index) {
          final bool shouldShowDot = (index == 0 &&
                  !bar.spots[index].y.isNaN &&
                  bar.spots[index + 1].y.isNaN) ||
              (index == bar.spots.length - 1 &&
                  !bar.spots[index].y.isNaN &&
                  bar.spots[index - 1].y.isNaN) ||
              index > 0 &&
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

// Check if all spots contain NaN values
  bool isOnlyNaN(List<FlSpot> spots) {
    return spots.every((spot) => spot.y.isNaN);
  }

  List<Color> _createGradientColors(List<FlSpot> spotsList) {
    List<Color> result = spotsList
        .where((spot) => !spot.y.isNaN)
        .map((spot) => moodColors[spot.y.round()])
        .toList();

    if (result.length <= 1) {
      result = [Colors.transparent, Colors.transparent];
    }

    return result;
  }
}
