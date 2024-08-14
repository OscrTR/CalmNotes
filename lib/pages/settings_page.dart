import 'package:calm_notes/colors.dart';
import 'package:calm_notes/providers/reminder_provider.dart';
import 'package:calm_notes/services/notification_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> selectTime(BuildContext context, VoidCallback onSuccess) async {
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
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        onSuccess.call();
      });
    }
  }

  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return locale.languageCode;
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
          Consumer<ReminderProvider>(
            builder: (context, provider, child) {
              final reminders = provider.reminders;
              if (reminders.isEmpty) {
                return const Center(child: Text('No reminders found.'));
              }
              final double height = reminders.length * 40.0;
              return SizedBox(
                height: height,
                child: ListView.builder(
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = reminders[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          reminder.time,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        IconButton(
                          onPressed: () {
                            provider.deleteReminder(reminder.id!);
                          },
                          style: const ButtonStyle(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: const Icon(
                            Symbols.delete,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            },
          ),
          Center(
            child: FilledButton(
              onPressed: () {
                selectTime(context, () {
                  if (!mounted) return;
                  final reminderProvider =
                      Provider.of<ReminderProvider>(context, listen: false);
                  reminderProvider.addReminder(
                    MaterialLocalizations.of(context).formatTimeOfDay(
                        selectedTime,
                        alwaysUse24HourFormat: true),
                  );
                  NotificationService.showNotification(selectedTime);
                });
              },
              child: const Text('Add a reminder'),
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            'Language',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          TextButton(
            onPressed: () {
              _showLanguageDialog(context);
            },
            child: Text(
              getLanguageName(context.locale),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        ],
      ),
    );
  }
}

void _showLanguageDialog(BuildContext context) {
  showDialog<String>(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      backgroundColor: AppColors.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      title: const Text('Select the app language'),
      content: _buildLanguageDialogContent(context),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text('Cancel'),
        ),
      ],
    ),
  );
}

Widget _buildLanguageDialogContent(BuildContext context) {
  return Wrap(
    spacing: 10,
    children: [
      OutlinedButton(
          onPressed: () {
            context.setLocale(const Locale('en', 'US'));
            Navigator.pop(context, 'Language selection');
          },
          child: const Text('English')),
      OutlinedButton(
          onPressed: () {
            context.setLocale(const Locale('fr', 'FR'));
            Navigator.pop(context, 'Language selection');
          },
          child: const Text('French')),
    ],
  );
}
