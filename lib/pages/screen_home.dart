import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/services/database_service.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome> {
  final DatabaseService _databaseService = DatabaseService.instance;

  Color getCardColor(int mood) {
    // List of colors corresponding to mood
    final colors = [
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
      AppColors.color10
    ];
    return mood >= 0 && mood < colors.length ? colors[mood] : Colors.red;
  }

  DateTime? getDateTime(String date) {
    try {
      final parts = date.split('|');
      final dateTime = DateFormat('yyyy-MM-dd').parse(parts[0]);
      final time = DateFormat('HH:mm').parse(parts[1]);
      return DateTime(
          dateTime.year, dateTime.month, dateTime.day, time.hour, time.minute);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Entry>>(
        future: _databaseService.getEntries(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final entries = snapshot.data;

          if (entries == null || entries.isEmpty) {
            return Center(child: Text('No entries found.'));
          }

          return ListView.builder(
            itemCount: entries.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildHeader(context);
              }

              final entry = entries[index - 1];
              return _buildEntryCard(entry);
            },
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                onPressed: () => GoRouter.of(context).push('/settings'),
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
        ],
      ),
    );
  }

  Widget _buildEntryCard(Entry entry) {
    final dateTime = getDateTime(entry.date)!;

    return Card(
      color: getCardColor(entry.mood),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDateSection(dateTime),
              Container(
                height: 48,
                width: 1,
                color: AppColors.ternaryColor,
              ),
              _buildEntryDetails(entry),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateSection(DateTime dateTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateTime.day.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: AppColors.primaryColor,
          ),
        ),
        Text(
          DateFormat('MMM').format(dateTime),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: AppColors.ternaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildEntryDetails(Entry entry) {
    return SizedBox(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
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
          Text(
            entry.description!,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.ternaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
