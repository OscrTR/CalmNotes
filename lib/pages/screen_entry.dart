import 'package:calm_notes/colors.dart';
import 'package:calm_notes/slider.dart';
import 'package:flutter/material.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:intl/intl.dart';

class ScreenEntry extends StatefulWidget {
  const ScreenEntry({super.key});

  @override
  State<ScreenEntry> createState() => _ScreenEntryState();
}

class _ScreenEntryState extends State<ScreenEntry> {
  final DatabaseService _databaseService = DatabaseService.instance;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateFormat dateFormatter = DateFormat('d MMMM yyyy');
    String formattedDate = dateFormatter.format(now);
    DateFormat timeFormatter = DateFormat('HH:mm');
    String formattedTime = timeFormatter.format(now);

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'How do you feel?',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          TextButton(
              onPressed: () {},
              style: ButtonStyle(
                padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              ),
              child: Row(
                children: [
                  Text(
                    formattedDate,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(' - $formattedTime')
                ],
              )),
          const CustomSlider(),
          OutlinedButton(onPressed: () {}, child: Text('anxiety')),
          FilledButton(
            onPressed: () {
              _databaseService.addEntry(formattedDate + formattedTime, 5,
                  'emotions', 'description', 'tags');
            },
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.all<Color>(AppColors.primaryColor),
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
              ),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
            ),
            child: const Text('Save'),
          )
        ],
      ),
    );
  }
}
