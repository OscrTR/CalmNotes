import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final DatabaseService _databaseService = DatabaseService.instance;

  Color getCardColor(mood) {
    switch (mood) {
      case 0:
        return AppColors.color0;
      case 1:
        return AppColors.color1;
      case 2:
        return AppColors.color2;
      case 3:
        return AppColors.color3;
      case 4:
        return AppColors.color4;
      case 5:
        return AppColors.color5;
      case 6:
        return AppColors.color6;
      case 7:
        return AppColors.color7;
      case 8:
        return AppColors.color8;
      case 9:
        return AppColors.color9;
      case 10:
        return AppColors.color10;
      default:
        return Colors.red;
    }
  }

  DateTime? getDateTime(date) {
    List<String> parts = date.split('|');

    DateTime dateTime;
    try {
      dateTime = DateFormat('yyyy-MM-dd').parse(parts[0]);
      DateTime time = DateFormat('HH:mm').parse(parts[1]);

      // Combine date and time
      dateTime = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        time.hour,
        time.minute,
      );
      return dateTime;
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _databaseService.getEntries(),
        builder: (context, snapshot) {
          return ListView.builder(
              itemCount: snapshot.data == null ? 1 : snapshot.data!.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hello!',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            IconButton(
                              iconSize: 30,
                              color: AppColors.primaryColor,
                              onPressed: () =>
                                  GoRouter.of(context).push('/settings'),
                              icon: const Icon(
                                Symbols.settings,
                                weight: 300,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          "Don't make a bad day make you feel like you have a bad life.",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                      ]);
                }
                index -= 1;

                Entry entry = snapshot.data![index];
                return Card(
                  color: getCardColor(entry.mood),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Container(
                      height: 70,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                getDateTime(entry.date)!.day.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20,
                                  color: AppColors.primaryColor,
                                ),
                              ),
                              Text(
                                DateFormat('MMM')
                                    .format(getDateTime(entry.date)!),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: AppColors.ternaryColor,
                                ),
                              ),
                            ],
                          ),
                          const VerticalDivider(color: AppColors.ternaryColor),
                          SizedBox(
                            width: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    SizedBox(
                                      width: 230,
                                      child: Text(
                                        entry.title!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: AppColors.primaryColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
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
                                SizedBox(
                                  width: 250,
                                  child: Text(
                                    entry.description!,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.ternaryColor,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
