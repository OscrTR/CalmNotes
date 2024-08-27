import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:calm_notes/colors.dart';
import 'package:calm_notes/widgets/animated_button/animated_button.dart';
import 'package:calm_notes/widgets/animated_button/transition_type.dart';
import 'package:calm_notes/widgets/calendar.dart';
import 'package:calm_notes/widgets/chart.dart';
import 'package:calm_notes/widgets/pie_chart.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  DateTime? _selectedStartDate;
  ScrollController? _scrollControllerWeeks;
  ScrollController? _scrollControllerMonths;
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    GoRouter.of(context).go('/home');
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
    final entryProvider = context.read<EntryProvider>();
    _scrollControllerWeeks = ScrollController(
        initialScrollOffset: entryProvider.initialWeeksListOffset);
    _scrollControllerMonths = ScrollController(
        initialScrollOffset: entryProvider.initialMonthsListOffset);
  }

  @override
  Widget build(BuildContext context) {
    final entryProvider = context.watch<EntryProvider>();
    final entries = entryProvider.filteredEntries;
    _selectedStartDate = entryProvider.startDate;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
        child: ListView(
          children: [
            Text(context.tr('statistics_page_title'),
                style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            _buildRangeTypeButtons(context, entryProvider),
            const SizedBox(height: 10),
            _buildDateSelector(context, entryProvider),
            const SizedBox(height: 20),
            _buildFactorSelection(entryProvider, entries, context),
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

  Widget _buildFactorSelection(
      EntryProvider entryProvider, List<Entry> entries, BuildContext context) {
    return entryProvider.selectedFactor.isEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.tr('statistics_mood_graph'),
                  style: Theme.of(context).textTheme.titleMedium),
              OutlinedButton(
                onPressed: () => _showFactorSelectionDialog(entryProvider),
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
                  entryProvider.removeFactor();
                },
                child: Text(entryProvider.selectedFactor),
              ),
            ],
          );
  }

  Widget _buildFactorSelectionContent(
      EntryProvider entryProvider, BuildContext context) {
    final factorsList = entryProvider.factorsList;
    final entries = entryProvider.filteredEntries;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.tr(factorsList.isEmpty
            ? 'statistics_no_factor'
            : 'statistics_factor_dialog_subtitle')),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: _buildFactorButtonList(entries, context, factorsList),
        ),
      ],
    );
  }

  List<Widget> _buildFactorButtonList(
      List<Entry> entries, BuildContext context, List<String> factorsList) {
    return factorsList.map((factor) {
      return OutlinedButton(
        onPressed: () {
          context.read<EntryProvider>().selectFactor(factor);
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
        Expanded(
          child: AnimatedButton(
              text: context.tr('statistics_week'),
              isSelected: provider.isWeekSelected,
              height: 40,
              selectedTextColor: CustomColors.backgroundColor,
              selectedBackgroundColor: CustomColors.primaryColor,
              backgroundColor: CustomColors.backgroundColor,
              borderRadius: 5,
              textStyle: const TextStyle(color: CustomColors.primaryColor),
              transitionType: TransitionType.leftToRight,
              onPress: () {
                provider.changeRangeTypeSelection();
                provider.setDefaultWeekDate();
                _scrollToSelectedDate(provider);
              }),
        ),
        Expanded(
          child: AnimatedButton(
              text: context.tr('statistics_month'),
              isSelected: !provider.isWeekSelected,
              height: 40,
              selectedTextColor: CustomColors.backgroundColor,
              selectedBackgroundColor: CustomColors.primaryColor,
              backgroundColor: CustomColors.backgroundColor,
              borderRadius: 5,
              textStyle: const TextStyle(color: CustomColors.primaryColor),
              transitionType: TransitionType.leftToRight,
              onPress: () {
                provider.changeRangeTypeSelection();
                provider.setDefaultMonthDate();
                _scrollToSelectedDate(provider);
              }),
        ),
      ],
    );
  }

  Widget _buildDateSelector(BuildContext context, EntryProvider provider) {
    final weeks = provider.weeks;
    final months = provider.months;
    final List<DateTime> dateList = provider.isWeekSelected ? weeks : months;
    final ScrollController? scrollController = provider.isWeekSelected
        ? _scrollControllerWeeks
        : _scrollControllerMonths;

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: scrollController,
        itemCount: dateList.length,
        itemBuilder: (context, index) {
          final date = dateList[index];
          final isSelected = _isDateSelected(date, provider);
          final label = _formatDateLabel(context, date, provider);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: AnimatedButton(
              text: label,
              height: 40,
              width: 90,
              isSelected: isSelected,
              selectedTextColor: CustomColors.backgroundColor,
              selectedBackgroundColor: CustomColors.primaryColor,
              backgroundColor: CustomColors.backgroundColor,
              borderColor: isSelected
                  ? CustomColors.primaryColor
                  : CustomColors.secondaryColor,
              borderRadius: 5,
              borderWidth: 1,
              textStyle: const TextStyle(color: CustomColors.primaryColor),
              transitionType: TransitionType.leftToRight,
              onPress: () {
                setState(() {
                  _selectedStartDate = date;
                  provider.setStartEndDate(date, _getEndDate(date, provider));
                });
              },
            ),
          );
        },
      ),
    );
  }

  bool _isDateSelected(DateTime date, EntryProvider entryProvider) {
    return entryProvider.isWeekSelected
        ? date.year == _selectedStartDate?.year &&
            date.month == _selectedStartDate?.month &&
            date.day == _selectedStartDate?.day
        : date.year == _selectedStartDate?.year &&
            date.month == _selectedStartDate?.month;
  }

  String _formatDateLabel(
      BuildContext context, DateTime date, EntryProvider entryProvider) {
    final currentLocale = context.locale;
    final label = DateFormat(entryProvider.isWeekSelected ? 'MMM d' : 'MMM',
            currentLocale.toString())
        .format(date);
    return capitalizeFirstLetter(label);
  }

  String capitalizeFirstLetter(String input) {
    if (input.isEmpty) return input;
    return input[0].toUpperCase() + input.substring(1);
  }

  DateTime _getEndDate(DateTime startDate, EntryProvider entryProvider) {
    return entryProvider.isWeekSelected
        ? startDate
            .add(const Duration(days: 7))
            .subtract(const Duration(seconds: 1))
        : DateTime(startDate.year, startDate.month + 1, 1)
            .subtract(const Duration(seconds: 1));
  }

  void _scrollToSelectedDate(EntryProvider entryProvider) {
    if (_selectedStartDate == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ScrollController? scrollController = entryProvider.isWeekSelected
          ? _scrollControllerWeeks
          : _scrollControllerMonths;
      scrollController!.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  void _showFactorSelectionDialog(EntryProvider entryProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: CustomColors.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Text(context.tr('statistics_factor_dialog_title')),
          content: _buildFactorSelectionContent(entryProvider, context),
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
