import 'package:back_button_interceptor/back_button_interceptor.dart';
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
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class EntryCreate extends StatefulWidget {
  final Entry? entry;
  const EntryCreate({super.key, this.entry});

  @override
  State<EntryCreate> createState() => _EntryCreateState();
}

class _EntryCreateState extends State<EntryCreate> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int? _selectedMood;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    GoRouter.of(context).go('/home');
    Provider.of<EmotionProvider>(context, listen: false).resetEmotions();
    Provider.of<TagProvider>(context, listen: false).resetTags();
    return true;
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    BackButtonInterceptor.add(myInterceptor);
    if (widget.entry != null) {
      _selectedMood = widget.entry!.mood;
      _selectedDate = getDateTime(widget.entry!.date)!;
      _selectedTime = parseTimeOfDay(widget.entry!.date);
      _titleController.text = widget.entry!.title!;
      _descriptionController.text = widget.entry!.description!;
      Future.microtask(() {
        Provider.of<EmotionProvider>(context, listen: false)
            .setEmotions(widget.entry!.id!);
        Provider.of<TagProvider>(context, listen: false)
            .setTags(widget.entry!.id!);
      });
    } else {
      _selectedMood = 5;
    }
    super.initState();
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

  TimeOfDay parseTimeOfDay(String dateTimeString) {
    // Split the string to separate date and time
    List<String> parts = dateTimeString.split('|');

    // Extract the time part (assuming the format is correct)
    if (parts.length != 2) {
      throw const FormatException('Invalid date-time format');
    }

    String timePart = parts[1];

    // Split the time part into hours and minutes
    List<String> timeParts = timePart.split(':');
    if (timeParts.length != 2) {
      throw const FormatException('Invalid time format');
    }

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);

    // Create and return a TimeOfDay object
    return TimeOfDay(hour: hour, minute: minute);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: CustomColors.backgroundColor),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildMoodSlider(),
                const SizedBox(height: 14),
                _buildEmotionsSection(context),
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
        ));
  }

  Widget _buildMoodSlider() {
    return CustomSlider(
      initialValue: widget.entry?.mood.toDouble(),
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

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _navigateBack(context),
      child: Container(
        height: 48,
        width: 48,
        alignment: Alignment.centerLeft,
        child: const ClipRect(
          child: Align(
            alignment: Alignment.centerRight,
            widthFactor: 0.85,
            child: Icon(
              Icons.arrow_back,
              color: CustomColors.primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _showDeleteDialog(context),
      child: Container(
        height: 48,
        width: 48,
        alignment: Alignment.centerRight,
        child: const SizedBox(
          width: 20,
          child: Icon(
            Symbols.delete,
            color: CustomColors.primaryColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBackButton(context),
        Container(
          padding: const EdgeInsets.only(bottom: 6),
          child: Text(
            context.tr(
                widget.entry != null ? 'edit_page_title' : 'create_page_title'),
            style:
                Theme.of(context).textTheme.headlineMedium?.copyWith(height: 1),
          ),
        ),
        widget.entry != null
            ? _buildDeleteButton(context)
            : const SizedBox(width: 48),
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

  Widget _buildEmotionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tr('create_emotions'),
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        const Emotions(),
      ],
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

  void _saveEntry(BuildContext context) {
    final emotionProvider =
        Provider.of<EmotionProvider>(context, listen: false);
    final tagProvider = Provider.of<TagProvider>(context, listen: false);
    final entryProvider = Provider.of<EntryProvider>(context, listen: false);

    final entry = Entry(
      id: widget.entry?.id,
      date: _formatDateTime(context),
      mood: _selectedMood!,
      emotions: _convertEmotionsToString(emotionProvider.emotionsToDisplay),
      title: _titleController.text,
      description: _descriptionController.text,
      tags: _convertTagsToString(tagProvider.tagsToDisplay),
    );

    if (widget.entry != null) {
      entryProvider.updateEntry(entry);
    } else {
      entryProvider.addEntry(entry);
    }

    GoRouter.of(context).go('/home');
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

  void _navigateBack(BuildContext context) {
    GoRouter.of(context).go('/home');
    Provider.of<EmotionProvider>(context, listen: false).resetEmotions();
    Provider.of<TagProvider>(context, listen: false).resetTags();
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: CustomColors.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text(context.tr('edit_delete_dialog_title')),
        content: Text(context.tr('edit_delete_dialog_subtitle')),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(context.tr('global_dialog_cancel')),
          ),
          TextButton(
            onPressed: () => _deleteEntry(context),
            child: Text(context.tr('edit_delete_dialog_delete')),
          ),
        ],
      ),
    );
  }

  void _deleteEntry(BuildContext context) {
    Provider.of<EntryProvider>(context, listen: false)
        .deleteEntry(widget.entry!.id!);
    Navigator.pop(context, 'Delete');
    _navigateBack(context);
  }
}
