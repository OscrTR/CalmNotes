import 'package:calm_notes/colors.dart';
import 'package:calm_notes/components/emotions.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/providers/tag_provider.dart';
import 'package:calm_notes/components/slider.dart';
import 'package:calm_notes/components/tags.dart';
import 'package:flutter/material.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
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
  Entry? _savedEntry;

  final DateFormat _dateFormatter = DateFormat('d MMMM yyyy');
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int? _selectedMood;
  late Future<int?> _futureMood;

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
    _futureMood = _databaseService.getEntryMood(widget.entryId);
    // Initialize controllers or other variables if needed
    _fetchData();
  }

  Future<void> _fetchData() async {
    final data = await _databaseService.getEntry(widget.entryId);
    setState(() {
      _savedEntry = data;
    });
    _selectedMood = _savedEntry!.mood;
    _selectedDate = getDateTime(_savedEntry!.date)!;
    _selectedTime = parseTimeOfDay(_savedEntry!.date);
    _titleController.text = _savedEntry!.title!;
    _descriptionController.text = _savedEntry!.description!;
    Future.microtask(() {
      Provider.of<EmotionProvider>(context, listen: false)
          .setEmotions(_parseEmotionString(_savedEntry!.emotions!));
      Provider.of<TagProvider>(context, listen: false)
          .settags(_parseEmotionString(_savedEntry!.tags!));
    });
  }

  // Parse the input string into a Map<String, int>
  Map<String, int> _parseEmotionString(String emotionString) {
    // Remove curly braces and split the string by comma to get each emotion entry
    String cleanedString = emotionString.replaceAll(RegExp(r'[{} ]'), '');
    List<String> entries = cleanedString.split(',');

    // Convert the list of entries into a map
    Map<String, int> emotionMap = {};
    for (String entry in entries) {
      List<String> parts = entry.split(':');
      if (parts.length == 2) {
        String emotion = parts[0];
        int count = int.tryParse(parts[1]) ?? 0;
        emotionMap[emotion] = count;
      }
    }

    return emotionMap;
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
            FutureBuilder(
                future: _futureMood,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData) {
                    return const Text('No data found');
                  } else {
                    final initialValue =
                        _selectedMood ?? snapshot.data!.toDouble();
                    return CustomSlider(
                        initialValue: initialValue.toDouble(),
                        onChanged: (double newValue) {
                          setState(() {
                            _selectedMood = newValue.toInt();
                          });
                        });
                  }
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
            GestureDetector(
              onTap: () {
                GoRouter.of(context).push('/');
                Provider.of<EmotionProvider>(context, listen: false)
                    .resetEmotions();
                Provider.of<TagProvider>(context, listen: false).resettags();
              },
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
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ),
            ),
            Text('Edit entry',
                style: Theme.of(context).textTheme.headlineMedium),
            GestureDetector(
              onTap: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  backgroundColor: AppColors.backgroundColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  title: const Text('Entry deletion'),
                  content:
                      const Text('Are you sure you want to delete this entry?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        _databaseService.deleteEntry(widget.entryId);
                        Navigator.pop(context, 'Delete');
                        GoRouter.of(context).push('/');
                        Provider.of<EmotionProvider>(context, listen: false)
                            .resetEmotions();
                        Provider.of<TagProvider>(context, listen: false)
                            .resettags();
                      },
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ),
              child: Container(
                height: 48,
                width: 48,
                alignment: Alignment.centerRight,
                child: const SizedBox(
                  width: 20,
                  child: Icon(
                    Symbols.delete,
                    color: AppColors.primaryColor,
                  ),
                ),
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

          _databaseService.updateEntry(
            widget.entryId,
            '${_selectedDate.toString().split(' ')[0]}|${MaterialLocalizations.of(context).formatTimeOfDay(_selectedTime, alwaysUse24HourFormat: true)}',
            _selectedMood!,
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
