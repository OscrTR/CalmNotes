import 'package:calm_notes/colors.dart';
import 'package:calm_notes/providers/reminder_provider.dart';
import 'package:calm_notes/services/notification_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:path/path.dart';
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
            context.tr('settings_title'),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            context.tr('settings_reminders'),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Consumer<ReminderProvider>(
            builder: (context, provider, child) {
              final reminders = provider.reminders;
              if (reminders.isEmpty) {
                return Column(children: [
                  const SizedBox(height: 10),
                  Text(context.tr('settings_reminders_not_found')),
                  const SizedBox(height: 10),
                ]);
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
          FilledButton(
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
            child: Text(context.tr('settings_reminders_add')),
          ),
          const SizedBox(
            height: 24,
          ),
          Text(
            context.tr('settings_language'),
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
      title: Text(context.tr('settings_language_dialog_title')),
      content: _buildLanguageDialogContent(context),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: Text(context.tr('global_dialog_cancel')),
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
            Navigator.pop(context, 'Language selection');
            context.setLocale(const Locale('en', 'US'));
          },
          child: Text(context.tr('settings_language_dialog_english'))),
      OutlinedButton(
          onPressed: () {
            Navigator.pop(context, 'Language selection');
            context.setLocale(const Locale('fr', 'FR'));
          },
          child: Text(context.tr('settings_language_dialog_french'))),
    ],
  );
}
