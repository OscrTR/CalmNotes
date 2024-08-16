import 'package:calm_notes/colors.dart';
import 'package:calm_notes/components/emotions.dart';
import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/models/tag.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/providers/tag_provider.dart';
import 'package:calm_notes/components/slider.dart';
import 'package:calm_notes/components/tags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:provider/provider.dart';

class EntryDetailPage extends StatefulWidget {
  final int entryId;
  const EntryDetailPage({super.key, required this.entryId});

  @override
  State<EntryDetailPage> createState() => _EntryDetailPageState();
}

class _EntryDetailPageState extends State<EntryDetailPage> {
  final DatabaseService _databaseService = DatabaseService.instance;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int? _selectedMood;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadEntryData();
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
            if (_selectedMood != null) ...[
              CustomSlider(
                initialValue: _selectedMood!.toDouble(),
                onChanged: (double newValue) {
                  setState(() {
                    _selectedMood = newValue.toInt();
                  });
                },
              ),
              const SizedBox(height: 14),
              const Emotions(),
            ],
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
        _buildTopBar(context),
        const SizedBox(height: 10),
        _buildDateTimePickerRow(context),
      ],
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBackButton(context),
        Text(
          context.tr('edit_page_title'),
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        _buildDeleteButton(context),
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
        hintText: context.tr('edit_title'),
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
        hintText: context.tr('edit_description'),
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
        Text(context.tr('edit_tags'),
            style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        const Tags(),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FilledButton(
        onPressed: () => _saveEntry(context),
        style: ButtonStyle(
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            const EdgeInsets.symmetric(horizontal: 60, vertical: 12),
          ),
        ),
        child: Text(context.tr('edit_save')),
      ),
    );
  }

  void _navigateBack(BuildContext context) {
    GoRouter.of(context).push('/');
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
    _databaseService.deleteEntry(widget.entryId);
    Navigator.pop(context, 'Delete');
    _navigateBack(context);
  }

  void _saveEntry(BuildContext context) {
    if (_selectedMood != null) {
      final entry = Entry(
        id: widget.entryId,
        date: _formatDateTime(context),
        mood: _selectedMood!,
        emotions: _convertEmotionsToString(
            Provider.of<EmotionProvider>(context, listen: false)
                .emotionsToDisplay),
        title: _titleController.text,
        description: _descriptionController.text,
        tags: _convertTagsToString(
            Provider.of<TagProvider>(context, listen: false).tagsToDisplay),
      );

      _databaseService.updateEntry(entry);
      _navigateBack(context);
    }
  }

  String _formatDateTime(BuildContext context) {
    return '${_selectedDate.toString().split(' ')[0]}|${MaterialLocalizations.of(context).formatTimeOfDay(_selectedTime, alwaysUse24HourFormat: true)}';
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

  String convertEmotionsToString(List<Emotion> emotions) {
    final filteredEmotions =
        emotions.where((emotion) => emotion.selectedCount > 0);

    final emotionStrings = filteredEmotions
        .map((emotion) => '${emotion.name} : ${emotion.selectedCount}');

    return emotionStrings.join(', ');
  }

  String convertTagsToString(List<Tag> tags) {
    final filteredEmotions = tags.where((tag) => tag.selectedCount > 0);

    final emotionStrings =
        filteredEmotions.map((tag) => '${tag.name} : ${tag.selectedCount}');

    return emotionStrings.join(', ');
  }

  Future<void> _loadEntryData() async {
    try {
      final entry = await _databaseService.getEntry(widget.entryId);
      setState(() {
        _selectedMood = entry.mood;
        _selectedDate = _parseDate(entry.date);
        _selectedTime = _parseTime(entry.date);
        _titleController.text = entry.title ?? '';
        _descriptionController.text = entry.description ?? '';
      });

      Future.microtask(() {
        Provider.of<EmotionProvider>(context, listen: false)
            .setEmotions(widget.entryId);
        Provider.of<TagProvider>(context, listen: false)
            .setTags(widget.entryId);
      });
    } catch (e) {
      // Handle error appropriately
      print("Error loading entry data: $e");
    }
  }

  DateTime _parseDate(String date) {
    final parts = date.split('|');
    final dateTime = DateFormat('yyyy-MM-dd').parse(parts[0]);
    return dateTime;
  }

  TimeOfDay _parseTime(String date) {
    final parts = date.split('|')[1].split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime(2043),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }
}
