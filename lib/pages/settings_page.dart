import 'package:calm_notes/services/database_service.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final DatabaseService _databaseService = DatabaseService.instance;
  TimeOfDay _initialTime = TimeOfDay.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            'Reminders',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          FutureBuilder(
              future: _databaseService.getReminders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final reminders = snapshot.data;
                if (reminders == null || reminders.isEmpty) {
                  return const Text('No reminders found.');
                }

                return Expanded(
                    child: ListView.builder(
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = reminders[index];
                    return ListTile(
                      title: Text(reminder.time),
                    );
                  },
                ));
              }),
          Center(
              child: FilledButton(
                  onPressed: () {
                    _selectTime(context);
                    print(
                        '${MaterialLocalizations.of(context).formatTimeOfDay(_initialTime, alwaysUse24HourFormat: true)}');
                  },
                  child: const Text('Add a reminder'))),
        ],
      ),
    );
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _initialTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _databaseService.addReminder(MaterialLocalizations.of(context)
            .formatTimeOfDay(picked, alwaysUse24HourFormat: true));
      });
    }
  }
}
