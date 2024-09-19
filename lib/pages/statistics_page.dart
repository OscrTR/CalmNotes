import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/models/tag.dart';
import 'package:calm_notes/providers/animation_provider.dart';
import 'package:calm_notes/widgets/anim_btn.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (mounted) {
        await context.read<AnimationStateNotifier>().setAnimate(true);
      }
    });
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
    String currentLocale = context.locale.toString();
    final bool isFactorSelected = entryProvider.selectedFactor != null;
    final String btnText = isFactorSelected
        ? currentLocale == 'en_US'
            ? entryProvider.selectedFactor!.nameEn
            : entryProvider.selectedFactor!.nameFr
        : '';

    return entryProvider.selectedFactorString.isEmpty
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
              Flexible(
                child: FilledButton(
                  onPressed: () {
                    entryProvider.removeFactor();
                  },
                  child: Text(
                    btnText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          );
  }

  Widget _buildFactorSelectionContent(
      EntryProvider entryProvider, BuildContext context) {
    final entries = entryProvider.filteredEntries;
    final emotionFactors = entryProvider.emotionFactors;
    final tagFactors = entryProvider.tagFactors;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.tr(emotionFactors.isEmpty && tagFactors.isEmpty
            ? 'statistics_no_factor'
            : 'statistics_factor_dialog_subtitle')),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: _buildFactorButtonList(
              entries, context, emotionFactors, tagFactors),
        ),
      ],
    );
  }

  List<Widget> _buildFactorButtonList(List<Entry> entries, BuildContext context,
      List<Emotion> emotionFactors, List<Tag> tagFactors) {
    List<Widget> factorButtons = [];
    String currentLocale = context.locale.toString();
    List<Widget> emotionButtons = emotionFactors.map((emotion) {
      final String btnText =
          currentLocale == 'en_US' ? emotion.nameEn : emotion.nameFr;
      return OutlinedButton(
        onPressed: () {
          context.read<EntryProvider>().selectFactor(emotion.nameEn);
          Navigator.pop(context, 'Add emotion');
        },
        child: Text(btnText),
      );
    }).toList();

    List<Widget> tagButtons = tagFactors.map((tag) {
      return OutlinedButton(
        onPressed: () {
          context.read<EntryProvider>().selectFactor(tag.name);
          Navigator.pop(context, 'Add tag');
        },
        child: Text(tag.name),
      );
    }).toList();

    factorButtons.addAll(emotionButtons);
    factorButtons.addAll(tagButtons);

    return factorButtons;
  }

  Widget _buildRangeTypeButtons(BuildContext context, EntryProvider provider) {
    bool isWeekSelected = provider.isWeekSelected;

    bool isMonthSelected = !provider.isWeekSelected;

    final double maxButtonWidth = MediaQuery.of(context).size.width / 2;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AnimBtn(
              btnText: context.tr('statistics_week'),
              isSelected: isWeekSelected,
              borderWidth: 1,
              borderRadius: 5,
              width: maxButtonWidth,
              borderColor: Colors.transparent,
              onPress: () {
                provider.changeRangeTypeSelection();
                provider.setDefaultWeekDate();
                _scrollToSelectedDate(provider);
              }),
        ),
        Expanded(
          child: AnimBtn(
              btnText: context.tr('statistics_month'),
              isSelected: isMonthSelected,
              borderWidth: 1,
              borderRadius: 5,
              width: maxButtonWidth,
              borderColor: Colors.transparent,
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
          final label = _formatDateLabel(context, date, provider);
          final isSelected = _isDateSelected(date, provider);

          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: AnimBtn(
                btnText: label,
                isSelected: isSelected,
                borderWidth: 1,
                borderRadius: 5,
                borderColor: isSelected
                    ? CustomColors.primaryColor
                    : CustomColors.secondaryColor,
                width: 90,
                onPress: () {
                  setState(() {
                    _selectedStartDate = date;
                    provider.setStartEndDate(date, _getEndDate(date, provider));
                  });
                },
              ));
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
