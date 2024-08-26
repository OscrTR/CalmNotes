import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/providers/tag_provider.dart';
import 'package:calm_notes/widgets/entry_details_widget.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final Locale currentLocale = context.locale;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
        child: Consumer<EntryProvider>(
          builder: (context, entryProvider, child) {
            final entries = entryProvider.entries;

            if (entries.isEmpty) {
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 24),
                    Text(context.tr('home_no_entry'))
                  ]);
            }

            final groupedEntries =
                groupEntriesByMonthYear(entries, currentLocale);
            List<String> monthKeys = groupedEntries.keys.toList();

            return ListView.builder(
              itemCount: monthKeys.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _buildHeader(context);
                }
                String monthKey = monthKeys[index - 1];
                List<Entry> monthEntries = groupedEntries[monthKey]!;

                return _buildMonthEntries(context, monthKey, monthEntries);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.tr('home_title'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            GestureDetector(
              onTap: () => GoRouter.of(context).push('/settings'),
              child: Container(
                height: 48,
                width: 48,
                alignment: Alignment.centerRight,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.centerRight,
                    widthFactor: 0.85,
                    child: SvgPicture.asset(
                      height: 30.0,
                      'assets/icons/settings_icon.svg',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Text(
          context.tr('home_subtitle'),
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildMonthEntries(
      BuildContext context, String monthKey, List<Entry> monthEntries) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
          child: Text(
            monthKey,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: CustomColors.ternaryColor,
                ),
          ),
        ),
        ...monthEntries.map((entry) => _buildEntryCard(context, entry)),
      ],
    );
  }

  Widget _buildEntryCard(BuildContext context, Entry entry) {
    return Card(
      color: moodColors[entry.mood],
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: () async {
          await showModalBottomSheet(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) {
              return DraggableScrollableSheet(
                  initialChildSize: 0.9,
                  maxChildSize: 0.9,
                  minChildSize: 0.5,
                  snap: true,
                  snapSizes: const [0.9],
                  builder: (context, scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                          color: CustomColors.backgroundColor,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20))),
                      child: SingleChildScrollView(
                          clipBehavior: Clip.none,
                          controller: scrollController,
                          child: EntryDetails(
                            entry: entry,
                            scrollController: scrollController,
                          )),
                    );
                  });
            },
          );
          Future.microtask(() => onModalSheetClosed(context));
        },
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildEntryDate(entry.date),
              Container(
                margin: const EdgeInsets.only(right: 17),
                height: 48,
                width: 1,
                color: CustomColors.ternaryColor,
              ),
              _buildEntryDetails(entry),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEntryDate(String date) {
    final dateTime = getDateTime(date);
    final Locale currentLocale = context.locale;
    String dateString =
        DateFormat('MMM', currentLocale.toString()).format(dateTime);
    String capitalizedDateString =
        dateString[0].toUpperCase() + dateString.substring(1);

    return SizedBox(
      width: 48,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            dateTime.day.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          Text(
            capitalizedDateString,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEntryDetails(Entry entry) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    entry.title ?? '',
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: CustomColors.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/images/mood${entry.mood}.svg',
                height: 18,
                width: 18,
              ),
            ],
          ),
          Text(
            entry.description ?? '',
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: CustomColors.ternaryColor,
            ),
          ),
        ],
      ),
    );
  }

  DateTime getDateTime(String date) {
    final parts = date.split('|');
    final dateTime = DateFormat('yyyy-MM-dd').parse(parts[0]);
    final time = DateFormat('HH:mm').parse(parts[1]);
    return DateTime(
        dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);
  }

  Map<String, List<Entry>> groupEntriesByMonthYear(
      List<Entry> entries, Locale currentLocale) {
    // Sort entries by date in descending order
    entries.sort((a, b) => getDateTime(b.date).compareTo(getDateTime(a.date)));
    final Map<String, List<Entry>> groupedEntries = {};

    for (var entry in entries) {
      final DateTime date = getDateTime(entry.date);

      final String monthYear =
          DateFormat('MMMM yyyy', currentLocale.toString()).format(date);
      final String capitalizedMonthYear =
          monthYear[0].toUpperCase() + monthYear.substring(1);

      groupedEntries.putIfAbsent(capitalizedMonthYear, () => []).add(entry);
    }

    return groupedEntries;
  }

  void onModalSheetClosed(BuildContext context) {
    Provider.of<EmotionProvider>(context, listen: false).resetEmotions();
    Provider.of<TagProvider>(context, listen: false).resetTags();
  }
}
