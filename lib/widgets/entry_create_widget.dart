import 'package:calm_notes/colors.dart';
import 'package:calm_notes/widgets/emotions.dart';
import 'package:calm_notes/widgets/slider.dart';
import 'package:calm_notes/widgets/tags.dart';
import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/models/tag.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:calm_notes/providers/tag_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EntryCreate extends StatefulWidget {
  const EntryCreate({super.key});

  @override
  State<EntryCreate> createState() => _EntryCreateState();
}

class _EntryCreateState extends State<EntryCreate> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: CustomColors.backgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Stack(
          children: [
            Positioned(
                top: 10,
                right: 0,
                left: 0,
                child: Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: CustomColors.secondaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 24),
                  _buildMoodSlider(),
                  const SizedBox(height: 14),
                  const Emotions(),
                  const SizedBox(height: 24),
                  _buildTitleField(context),
                  const SizedBox(height: 10),
                  _buildDescriptionField(context),
                  const SizedBox(height: 24),
                  _buildTagsSection(context),
                  const SizedBox(height: 24),
                  _buildSaveButton(context)
                ],
              ),
            ),
          ],
        ));
  }

  Widget _buildMoodSlider() {
    return CustomSlider(
      onChanged: (double newValue) {
        setState(() {
          _selectedMood = newValue.toInt();
        });
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTitleRow(context),
        const SizedBox(height: 10),
        _buildDateTimePickerRow(context),
      ],
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            context.tr('create_page_title'),
            style:
                Theme.of(context).textTheme.headlineMedium?.copyWith(height: 1),
          ),
        ),
        GestureDetector(
          onTap: () => _cancelEntryCreation(context),
          child: Container(
            height: 48,
            width: 48,
            alignment: Alignment.centerRight,
            child: const ClipRect(
              child: Align(
                alignment: Alignment.centerRight,
                widthFactor: 0.85,
                child: Icon(
                  Icons.close,
                  color: CustomColors.primaryColor,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePickerRow(BuildContext context) {
    final Locale currentLocale = context.locale;
    return Row(
      children: [
        TextButton(
          onPressed: () => _selectDate(context),
          child: Text(
            DateFormat('d MMMM yyyy', currentLocale.toString())
                .format(_selectedDate),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const Text(' - '),
        TextButton(
          onPressed: () => _selectTime(context),
          child: Text(
            MaterialLocalizations.of(context).formatTimeOfDay(
              _selectedTime,
              alwaysUse24HourFormat: true,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return TextField(
      controller: _titleController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(borderSide: BorderSide.none),
        hintText: context.tr('create_title'),
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
        hintText: context.tr('create_description'),
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
        Text(context.tr('create_tags'),
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        const Tags(),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: FilledButton(
        onPressed: () => _saveEntry(context),
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
          ),
        ),
        child: Text(context.tr('create_save')),
      ),
    );
  }

  void _cancelEntryCreation(BuildContext context) {
    Provider.of<EmotionProvider>(context, listen: false).resetEmotions();
    Provider.of<TagProvider>(context, listen: false).resetTags();
    Navigator.pop(context, 'Cancel');
  }

  void _saveEntry(BuildContext context) {
    final emotionProvider =
        Provider.of<EmotionProvider>(context, listen: false);
    final tagProvider = Provider.of<TagProvider>(context, listen: false);

    final entry = Entry(
      date: _formatDateTime(context),
      mood: _selectedMood,
      emotions: _convertEmotionsToString(emotionProvider.emotionsToDisplay),
      title: _titleController.text,
      description: _descriptionController.text,
      tags: _convertTagsToString(tagProvider.tagsToDisplay),
    );

    Provider.of<EntryProvider>(context, listen: false).addEntry(entry);
    Navigator.pop(context, 'Create entry');
    emotionProvider.resetEmotions();
    tagProvider.resetTags();
  }

  String _formatDateTime(BuildContext context) {
    return '${_selectedDate.toString().split(' ')[0]}|'
        '${MaterialLocalizations.of(context).formatTimeOfDay(_selectedTime, alwaysUse24HourFormat: true)}';
  }

  String _convertEmotionsToString(List<Emotion> emotions) {
    return emotions
        .where((emotion) => emotion.selectedCount > 0)
        .map((emotion) => '${emotion.name} : ${emotion.selectedCount}')
        .join(', ');
  }

  String _convertTagsToString(List<Tag> tags) {
    return tags
        .where((tag) => tag.selectedCount > 0)
        .map((tag) => '${tag.name} : ${tag.selectedCount}')
        .join(', ');
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
}