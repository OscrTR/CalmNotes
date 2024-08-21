import 'package:flutter_test/flutter_test.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/models/reminder.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

void main() {
  sqfliteTestInit();
  late DatabaseService dbService;

  setUp(() async {
    dbService = DatabaseService.instance;
  });

  tearDown(() async {
    final db = await dbService.database;
    final tables = ['entries', 'reminders', 'emotions', 'tags'];

    for (var table in tables) {
      // Delete all rows from the table
      await db.delete(table);
    }
  });

  tearDownAll(() async {
    final db = await dbService.database;
    await db.close();
  });

  group('Entry Methods', () {
    test('Add and fetch Entry', () async {
      final entry = Entry(
        date: '2024-08-20',
        mood: 5,
        emotions: 'Happy,Excited:2',
        title: 'Great Day',
        description: 'Had a wonderful day!',
        tags: 'personal,work:3',
      );

      await dbService.addEntry(entry);
      final entries = await dbService.fetchEntries();

      expect(entries.length, 1);
      expect(entries.first.date, '2024-08-20');
      expect(entries.first.mood, 5);
      expect(entries.first.emotions, 'Happy,Excited:2');
    });

    test('Update and fetch Entry', () async {
      final entry = Entry(
        date: '2024-08-20',
        mood: 5,
        emotions: 'Happy,Excited:2',
        title: 'Great Day',
        description: 'Had a wonderful day!',
        tags: 'personal,work:3',
      );

      await dbService.addEntry(entry);
      final entries = await dbService.fetchEntries();
      final fetchedEntry = entries.first.copyWith(mood: 3);

      await dbService.updateEntry(fetchedEntry);
      final updatedEntry = await dbService.getEntry(fetchedEntry.id!);

      expect(updatedEntry.mood, 3);
    });

    test('Delete Entry', () async {
      final entry = Entry(
        date: '2024-08-20',
        mood: 5,
        emotions: 'Happy,Excited:2',
        title: 'Great Day',
        description: 'Had a wonderful day!',
        tags: 'personal,work:3',
      );

      await dbService.addEntry(entry);
      final entries = await dbService.fetchEntries();

      await dbService.deleteEntry(entries.first.id!);
      final updatedEntries = await dbService.fetchEntries();

      expect(updatedEntries.length, 0);
    });
  });

  group('Reminder Methods', () {
    test('Add and fetch Reminder', () async {
      final reminder = Reminder(time: '08:00 AM');

      await dbService.addReminder(reminder);
      final reminders = await dbService.fetchReminders();

      expect(reminders.length, 1);
      expect(reminders.first.time, '08:00 AM');
    });

    test('Delete Reminder', () async {
      final reminder = Reminder(time: '08:00 AM');

      await dbService.addReminder(reminder);
      final reminders = await dbService.fetchReminders();

      await dbService.deleteReminder(reminders.first.id!);
      final updatedReminders = await dbService.fetchReminders();

      expect(updatedReminders.length, 0);
    });
  });

  group('Emotion Methods', () {
    test('Add and fetch Emotion', () async {
      await dbService.addEmotion('Happy');
      final emotions = await dbService.fetchEmotions();

      expect(emotions.length, 1);
      expect(emotions.first.name, 'Happy');
    });

    test('Increment selected count and fetch Emotion', () async {
      final emotionId = await dbService.addEmotion('Happy');
      await dbService.incrementSelectedEmotionCount(emotionId);

      final emotion = await dbService.getEmotion(emotionId);
      expect(emotion.selectedCount, 1);
    });

    test('Reset selected counts', () async {
      await dbService.addEmotion('Happy');
      await dbService.addEmotion('Sad');

      await dbService.fetchEmotions();
      await dbService.resetSelectedEmotionsCount();

      final updatedEmotions = await dbService.fetchEmotions();
      expect(updatedEmotions.every((e) => e.selectedCount == 0), isTrue);
    });
  });

  group('Tag Methods', () {
    test('Add and fetch Tag', () async {
      await dbService.addTag('Work');
      final tags = await dbService.fetchTags();

      expect(tags.length, 1);
      expect(tags.first.name, 'Work');
    });

    test('Increment selected count and fetch Tag', () async {
      final tagId = await dbService.addTag('Work');
      await dbService.incrementSelectedTagCount(tagId);

      final tag = await dbService.getTag(tagId);
      expect(tag.selectedCount, 1);
    });

    test('Reset selected counts', () async {
      await dbService.addTag('Work');
      await dbService.addTag('Personal');

      await dbService.fetchTags();
      await dbService.resetSelectedTagsCount();

      final updatedTags = await dbService.fetchTags();
      expect(updatedTags.every((t) => t.selectedCount == 0), isTrue);
    });
  });
}
