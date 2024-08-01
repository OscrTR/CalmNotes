import 'package:calm_notes/colors.dart';
import 'package:calm_notes/emotions.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:calm_notes/slider.dart';
import 'package:calm_notes/tags.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EntryDetailPage extends StatefulWidget {
  final int entryId;
  const EntryDetailPage({super.key, required this.entryId});

  @override
  State<EntryDetailPage> createState() => _EntryDetailPageState();
}

class _EntryDetailPageState extends State<EntryDetailPage> {
  final DatabaseService _databaseService = DatabaseService.instance;
  final DateFormat _dateFormatter = DateFormat('d MMMM yyyy');
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _selectedMood = 5;
  List<String> _selectedTags = [];

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

  void _updateSelectedTags(List<String> newSelectedTags) {
    setState(() {
      _selectedTags = newSelectedTags;
    });
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

// List of all possible emotions
  final List<String> _emotions = [
    'fear',
    'anger',
    'disgust',
    'sad',
    'happy',
    'surprise',
  ];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<Entry>(
        future: _databaseService.getEntry(widget.entryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the future is resolving, show a loading indicator
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Handle any errors that occur during the future execution
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            // Handle the case where there is no data returned
            return const Center(
              child: Text('Entry not found'),
            );
          } else {
            // Once the future resolves, extract the data and display it
            final entry = snapshot.data!;
            _selectedDate = getDateTime(entry.date)!;
            _selectedTime = parseTimeOfDay(entry.date);
            _selectedMood = entry.mood;
            _titleController.text = entry.title!;
            _descriptionController.text = entry.description!;

            print(_parseEmotionString(entry.tags!));
            context
                .read<EmotionProvider>()
                .setEmotions(_parseEmotionString(entry.emotions!));

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
        },
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
            Text('Edit entry',
                style: Theme.of(context).textTheme.headlineMedium),
            IconButton(
              color: AppColors.primaryColor,
              onPressed: () => GoRouter.of(context).push('/'),
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
        Tags(onSelectedTagsChanged: _updateSelectedTags),
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

          _databaseService.addEntry(
            '${_selectedDate.toString().split(' ')[0]}|${MaterialLocalizations.of(context).formatTimeOfDay(_selectedTime, alwaysUse24HourFormat: true)}',
            _selectedMood,
            '$emotionCounts',
            _titleController.text,
            _descriptionController.text,
            _selectedTags.toString(),
          );
          GoRouter.of(context).push('/');
          context.read<EmotionProvider>().resetEmotions();
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
