import 'package:calm_notes/colors.dart';
import 'package:calm_notes/components/calendar.dart';
import 'package:calm_notes/components/chart.dart';
import 'package:calm_notes/components/pie_chart.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:calm_notes/providers/factor_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  String rangeType = 'week';
  List<DateTime> _weeks = [];
  List<DateTime> _months = [];
  DateTime? _selectedStartDate;
  final ScrollController _scrollControllerWeeks = ScrollController();
  final ScrollController _scrollControllerMonths = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeDateRanges();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedDate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final entryProvider = context.watch<EntryProvider>();
    final factorProvider = context.watch<FactorProvider>();
    final entries = entryProvider.filteredEntries;
    _selectedStartDate = entryProvider.startDate;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
        child: ListView(
          children: [
            Text('Statistics',
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            _buildRangeTypeButtons(context, entryProvider),
            const SizedBox(height: 10),
            _buildDateSelector(context, entryProvider),
            const SizedBox(height: 20),
            _buildFactorSelection(factorProvider, entries, context),
            const SizedBox(height: 10),
            const Chart(),
            const SizedBox(height: 30),
            Text(context.tr('statistics_mood_calendar'),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            const Calendar(),
            const SizedBox(height: 30),
            Text(context.tr('statistics_mood_distribution'),
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 20),
            const CustomPieChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildFactorSelection(FactorProvider factorProvider,
      List<Entry> entries, BuildContext context) {
    return factorProvider.selectedFactor.isEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.tr('statistics_mood_graph'),
                  style: Theme.of(context).textTheme.titleMedium),
              OutlinedButton(
                onPressed: () => _showFactorSelectionDialog(entries),
                child: Text(context.tr('statistics_mood_graph_add_factor')),
              ),
            ],
          )
        : Row(
            children: [
              Text(context.tr('statistics_mood_graph_vs'),
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(width: 10),
              FilledButton(
                onPressed: () {
                  factorProvider.removeFactor();
                },
                child: Text(factorProvider.selectedFactor),
              ),
            ],
          );
  }

  Widget _buildFactorSelectionContent(
      List<Entry> entries, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.tr('statistics_factor_dialog_subtitle')),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: _buildFactorButtonList(entries, context),
        ),
      ],
    );
  }

  List<Widget> _buildFactorButtonList(
      List<Entry> entries, BuildContext context) {
    final factorsList = _extractFactors(entries);
    return factorsList.map((factor) {
      return OutlinedButton(
        onPressed: () {
          context.read<FactorProvider>().selectFactor(factor);
          Navigator.pop(context, 'Add factor');
        },
        child: Text(factor),
      );
    }).toList();
  }

  Widget _buildRangeTypeButtons(BuildContext context, EntryProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildRangeTypeButton(
          context,
          provider,
          type: 'week',
          isSelected: rangeType == 'week',
          label: context.tr('statistics_week'),
          onSelect: () {
            setState(() {
              rangeType = 'week';
            });
            provider.setDefaultWeekDate();
            _scrollToSelectedDate();
          },
        ),
        _buildRangeTypeButton(
          context,
          provider,
          type: 'month',
          isSelected: rangeType == 'month',
          label: context.tr('statistics_month'),
          onSelect: () {
            setState(() {
              rangeType = 'month';
            });
            provider.setDefaultMonthDate();
            _scrollToSelectedDate();
          },
        ),
      ],
    );
  }

  Widget _buildRangeTypeButton(BuildContext context, EntryProvider provider,
      {required String type,
      required bool isSelected,
      required String label,
      required VoidCallback onSelect}) {
    return Expanded(
      child: isSelected
          ? FilledButton(onPressed: () {}, child: Text(label))
          : TextButton(onPressed: onSelect, child: Text(label)),
    );
  }

  Widget _buildDateSelector(BuildContext context, EntryProvider provider) {
    final List<DateTime> dateList = rangeType == 'week' ? _weeks : _months;
    final ScrollController scrollController =
        rangeType == 'week' ? _scrollControllerWeeks : _scrollControllerMonths;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      controller: scrollController,
      child: Row(
        children: dateList.map((date) {
          final isSelected = _isDateSelected(date);
          final label = _formatDateLabel(context, date);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: isSelected
                ? FilledButton(
                    onPressed: () {},
                    style: _dateButtonStyle(),
                    child: Text(label),
                  )
                : OutlinedButton(
                    style: _dateButtonStyle(),
                    onPressed: () {
                      setState(() {
                        _selectedStartDate = date;
                      });
                      provider.setStartEndDate(
                        date,
                        _getEndDate(date),
                      );
                    },
                    child: Text(label),
                  ),
          );
        }).toList(),
      ),
    );
  }

  ButtonStyle _dateButtonStyle() {
    return ButtonStyle(
      minimumSize: WidgetStateProperty.all(const Size(85.0, 40.0)),
      maximumSize: WidgetStateProperty.all(const Size(85.0, 40.0)),
    );
  }

  bool _isDateSelected(DateTime date) {
    return rangeType == 'week'
        ? date.year == _selectedStartDate?.year &&
            date.month == _selectedStartDate?.month &&
            date.day == _selectedStartDate?.day
        : date.year == _selectedStartDate?.year &&
            date.month == _selectedStartDate?.month;
  }

  String _formatDateLabel(BuildContext context, DateTime date) {
    final currentLocale = context.locale;
    final label = DateFormat(
            rangeType == 'week' ? 'MMM d' : 'MMM', currentLocale.toString())
        .format(date);
    return capitalizeFirstLetter(label);
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  DateTime _getEndDate(DateTime startDate) {
    return rangeType == 'week'
        ? startDate
            .add(const Duration(days: 7))
            .subtract(const Duration(seconds: 1))
        : DateTime(startDate.year, startDate.month + 1, 1)
            .subtract(const Duration(seconds: 1));
  }

  List<String> _extractFactors(List<Entry> entries) {
    Set<String> factorsSet = {};

    for (var entry in entries) {
      _processEntry(entry.emotions, factorsSet);
      _processEntry(entry.tags, factorsSet);
    }

    return factorsSet.toList();
  }

  void _processEntry(String? entryString, Set<String> factorsSet) {
    if (entryString != null && entryString.isNotEmpty) {
      for (var item in entryString.split(',')) {
        var trimmedItem = item.trim().split(" : ")[0];
        if (trimmedItem.isNotEmpty) {
          factorsSet.add(trimmedItem);
        }
      }
    }
  }

  List<DateTime> _generateDateRanges(Duration duration,
      [bool byMonth = false]) {
    List<DateTime> ranges = [];
    DateTime currentDate = DateTime(DateTime.now().year, 1, 1);
    DateTime endDate = DateTime(DateTime.now().year, 12, 31);

    while (currentDate.isBefore(endDate)) {
      ranges.add(currentDate);
      currentDate = byMonth
          ? DateTime(currentDate.year, currentDate.month + 1, 1)
          : currentDate.add(duration);
    }

    return ranges;
  }

  void _scrollToSelectedDate() {
    if (_selectedStartDate == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final List<DateTime> dateList = rangeType == 'week' ? _weeks : _months;
      final ScrollController scrollController = rangeType == 'week'
          ? _scrollControllerWeeks
          : _scrollControllerMonths;
      int index;
      if (rangeType == 'week') {
        index = dateList.indexWhere((date) =>
            date.year == _selectedStartDate!.year &&
            date.month == _selectedStartDate!.month &&
            date.day == _selectedStartDate!.day);
      } else {
        index = dateList.indexWhere((date) =>
            date.year == _selectedStartDate!.year &&
            date.month == _selectedStartDate!.month);
      }

      if (index == -1) return;

      const buttonWidth = 93.0;
      final offset = (index * buttonWidth) -
          (MediaQuery.of(context).size.width / 2 - buttonWidth / 2) +
          20;

      scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void _initializeDateRanges() {
    _weeks = _generateDateRanges(const Duration(days: 7));
    _months = _generateDateRanges(const Duration(days: 30), true);
  }

  void _showFactorSelectionDialog(List<Entry> entries) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text(context.tr('statistics_factor_dialog_title')),
          content: _buildFactorSelectionContent(entries, context),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: Text(context.tr('global_dialog_cancel')),
            ),
          ],
        );
      },
    );
  }
}
