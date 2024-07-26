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
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  DateFormat dateFormatter = DateFormat('d MMMM yyyy');

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2023),
        lastDate: DateTime(2043));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  TextButton(
                    onPressed: () => selectDate(context),
                    child: Text(
                      dateFormatter.format(selectedDate),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Text(' - '),
                  TextButton(
                    onPressed: () => selectTime(context),
                    child: Text(
                      MaterialLocalizations.of(context).formatTimeOfDay(
                          selectedTime,
                          alwaysUse24HourFormat: true),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              )),
          const CustomSlider(),
          OutlinedButton(onPressed: () {}, child: const Text('anxiety')),
          FilledButton(
            onPressed: () {
              _databaseService.addEntry(
                  '${selectedDate.toString().split(' ')[0]}|${MaterialLocalizations.of(context).formatTimeOfDay(selectedTime, alwaysUse24HourFormat: true)}',
                  5,
                  'emotions',
                  'description',
                  'tags');
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
