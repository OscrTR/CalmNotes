import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:calm_notes/colors.dart';
import 'package:calm_notes/models/reminder.dart';
import 'package:calm_notes/providers/reminder_provider.dart';
import 'package:calm_notes/services/notification_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  TimeOfDay selectedTime = TimeOfDay.now();

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    GoRouter.of(context).go('/home');
    return true;
  }

  @override
  void initState() {
    super.initState();
    BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 0, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              context.tr('settings_title'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            _buildRemindersSection(context),
            const SizedBox(height: 24),
            _buildLanguageSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildRemindersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('settings_reminders'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 10),
        Consumer<ReminderProvider>(
          builder: (context, provider, child) {
            final reminders = provider.reminders;
            if (reminders.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Text(context.tr('settings_reminders_not_found')),
              );
            }
            return _buildRemindersList(reminders, provider);
          },
        ),
        const SizedBox(height: 10),
        FilledButton(
          onPressed: () => _selectTime(context),
          child: Text(context.tr('settings_reminders_add')),
        ),
      ],
    );
  }

  Widget _buildRemindersList(
      List<Reminder> reminders, ReminderProvider provider) {
    return ListView.builder(
      shrinkWrap: true,
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
            GestureDetector(
              onTap: () => provider.deleteReminder(reminder),
              child: Container(
                height: 30,
                width: 30,
                alignment: Alignment.centerRight,
                child: const ClipRect(
                  child: Align(
                    alignment: Alignment.centerRight,
                    widthFactor: 0.85,
                    child: Icon(
                      Symbols.delete,
                      color: CustomColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.tr('settings_language'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        TextButton(
          onPressed: () => _showLanguageDialog(context),
          child: Text(
            _getLanguageName(context.locale),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget buildLanguageOption(BuildContext context,
      {required String languageCode,
      required String countryCode,
      required String label}) {
    return OutlinedButton(
      onPressed: () {
        Navigator.pop(context, 'Language selection');
        context.setLocale(Locale(languageCode, countryCode));
      },
      child: Text(label),
    );
  }

  Widget _buildLanguageDialogContent(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: [
        buildLanguageOption(
          context,
          languageCode: 'en',
          countryCode: 'US',
          label: context.tr('settings_language_dialog_english'),
        ),
        buildLanguageOption(
          context,
          languageCode: 'fr',
          countryCode: 'FR',
          label: context.tr('settings_language_dialog_french'),
        ),
      ],
    );
  }

  String _getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'fr':
        return 'Français';
      default:
        return locale.languageCode;
    }
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: CustomColors.backgroundColor,
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

  Future<void> _selectTime(BuildContext context) async {
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
      });
      if (context.mounted) {
        _addReminder(context);
      }
    }
  }

  void _addReminder(BuildContext context) {
    final reminderProvider =
        Provider.of<ReminderProvider>(context, listen: false);

    final formattedTime = MaterialLocalizations.of(context)
        .formatTimeOfDay(selectedTime, alwaysUse24HourFormat: true);

    int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);

    reminderProvider.addReminder(formattedTime, notificationId);
    NotificationService.showNotification(selectedTime, notificationId);
  }
}
