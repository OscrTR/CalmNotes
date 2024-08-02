import 'package:calm_notes/colors.dart';
import 'package:calm_notes/components/emotions.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/providers/tag_provider.dart';
import 'package:calm_notes/components/slider.dart';
import 'package:calm_notes/components/tags.dart';
import 'package:flutter/material.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ScreenEntry extends StatefulWidget {
  const ScreenEntry({super.key});

  @override
  State<ScreenEntry> createState() => _ScreenEntryState();
}

class _ScreenEntryState extends State<ScreenEntry> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final DateFormat _dateFormatter = DateFormat('d MMMM yyyy');
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _selectedMood = 5;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2043),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            CustomSlider(onChanged: (double newValue) {
              setState(() {
                _selectedMood = newValue.toInt();
              });
            }),
            const SizedBox(height: 14),
            Emotions(),
            const SizedBox(height: 24),
            _buildTitleField(context),
            const SizedBox(height: 10),
            _buildDescriptionField(context),
            const SizedBox(height: 24),
            _buildTagsSection(context),
            const SizedBox(height: 24),
            _buildSaveButton(context),
          ],
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('How do you feel?',
                style: Theme.of(context).textTheme.headlineMedium),
            IconButton(
              color: AppColors.primaryColor,
              onPressed: () {
                GoRouter.of(context).push('/');
                Provider.of<EmotionProvider>(context, listen: false)
                    .resetEmotions();
                Provider.of<TagProvider>(context, listen: false).resettags();
              },
              icon: const Icon(
                Icons.close,
              ),
            ),
          ],
        ),
        Row(
          children: [
            TextButton(
              onPressed: () => _selectDate(context),
              child: Text(
                _dateFormatter.format(_selectedDate),
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const Text(' - '),
            TextButton(
              onPressed: () => _selectTime(context),
              child: Text(
                MaterialLocalizations.of(context).formatTimeOfDay(_selectedTime,
                    alwaysUse24HourFormat: true),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        hintText: 'Title',
        hintStyle: Theme.of(context).textTheme.titleMedium,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  Widget _buildDescriptionField(BuildContext context) {
    return TextField(
      controller: _descriptionController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        hintText: 'Description',
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        contentPadding: EdgeInsets.zero,
        isDense: true,
      ),
      style: Theme.of(context).textTheme.bodyMedium,
      maxLines: null,
      keyboardType: TextInputType.multiline,
    );
  }

  Widget _buildTagsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('What was it about?',
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Tags(),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FilledButton(
        onPressed: () {
          final emotionProvider =
              Provider.of<EmotionProvider>(context, listen: false);
          final emotionCounts = emotionProvider.selectedEmotionCounts;

          final tagProvider = Provider.of<TagProvider>(context, listen: false);
          final tagCounts = tagProvider.selectedtagCounts;

          _databaseService.addEntry(
            '${_selectedDate.toString().split(' ')[0]}|${MaterialLocalizations.of(context).formatTimeOfDay(_selectedTime, alwaysUse24HourFormat: true)}',
            _selectedMood,
            '$emotionCounts',
            _titleController.text,
            _descriptionController.text,
            '$tagCounts',
          );
          GoRouter.of(context).push('/');
          emotionProvider.resetEmotions();
          tagProvider.resettags();
        },
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
          ),
        ),
        child: const Text('Save'),
      ),
    );
  }
}