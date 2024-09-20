import 'package:calm_notes/emotions_list.dart';
import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/models/tag.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/models/reminder.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  late EmotionProvider emotionProvider;
  late DatabaseService dbService;

  setUp(() async {
    dbService = DatabaseService.instance;
    emotionProvider = EmotionProvider();
    final db = await dbService.database;

    for (var emotion in emotions) {
      // emotions come from emontions_list.dart
      await db.insert('emotions', emotion);
    }
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

  group('Database Tests', () {
    test('Database is created with correct tables', () async {
      // Initialize the database
      final db = await dbService.database;

      // Verify tables are created
      final tables = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");

      final tableNames = tables.map((table) => table['name']).toList();
      final expectedTableNames = ['entries', 'reminders', 'emotions', 'tags'];

      expect(tables.length, 4);
      expect(tableNames, expectedTableNames);

      // Verify the structure of the 'entries' table
      final entriesColumns = await db.rawQuery('PRAGMA table_info(entries)');
      final expectedEntriesColumns = [
        {
          'cid': 0,
          'name': 'id',
          'type': 'INTEGER',
          'notnull': 0,
          'dflt_value': null,
          'pk': 1
        },
        {
          'cid': 1,
          'name': 'date',
          'type': 'TEXT',
          'notnull': 1,
          'dflt_value': null,
          'pk': 0
        },
        {
          'cid': 2,
          'name': 'mood',
          'type': 'INTEGER',
          'notnull': 1,
          'dflt_value': null,
          'pk': 0
        },
        {
          'cid': 3,
          'name': 'emotions',
          'type': 'TEXT',
          'notnull': 0,
          'dflt_value': null,
          'pk': 0
        },
        {
          'cid': 4,
          'name': 'title',
          'type': 'TEXT',
          'notnull': 0,
          'dflt_value': null,
          'pk': 0
        },
        {
          'cid': 5,
          'name': 'description',
          'type': 'TEXT',
          'notnull': 0,
          'dflt_value': null,
          'pk': 0
        },
        {
          'cid': 6,
          'name': 'tags',
          'type': 'TEXT',
          'notnull': 0,
          'dflt_value': null,
          'pk': 0
        },
      ];

      // Compare the actual columns with expected columns
      for (int i = 0; i < entriesColumns.length; i++) {
        expect(entriesColumns[i]['cid'], expectedEntriesColumns[i]['cid']);
        expect(entriesColumns[i]['name'], expectedEntriesColumns[i]['name']);
        expect(entriesColumns[i]['type'], expectedEntriesColumns[i]['type']);
        expect(
            entriesColumns[i]['notnull'], expectedEntriesColumns[i]['notnull']);
        expect(entriesColumns[i]['dflt_value'],
            expectedEntriesColumns[i]['dflt_value']);
        expect(entriesColumns[i]['pk'], expectedEntriesColumns[i]['pk']);
      }
    });
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
      expect(
          entries.first.mood, await dbService.getEntryMood(entries.first.id!));
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
    test('Increment selected count and fetch Emotion', () async {
      await emotionProvider.fetchEmotions();
      await dbService.incrementSelectedEmotionCount(1);
      final emotion = await dbService.getEmotion(1);
      expect(emotion.selectedCount, 1);
    });

    test('Reset selected counts', () async {
      await emotionProvider.fetchEmotions();
      await dbService.incrementSelectedEmotionCount(1);

      await dbService.fetchEmotions();

      Emotion updatedEmotion = await dbService.getEmotion(1);
      expect(updatedEmotion.selectedCount, 1);

      await dbService.resetSelectedEmotionsCount();

      final updatedEmotions = await dbService.fetchEmotions();
      expect(updatedEmotions.every((e) => e.selectedCount == 0), isTrue);

      await dbService.incrementSelectedEmotionCount(1);
      updatedEmotion = await dbService.getEmotion(1);
      expect(updatedEmotion.selectedCount, 1);

      await dbService.resetSelectedEmotionCount(1);
      updatedEmotion = await dbService.getEmotion(1);
      expect(updatedEmotion.selectedCount, 0);
    });

    test('Set selected count for emotions', () async {
      final entry = Entry(
        date: '2024-08-20',
        mood: 5,
        emotions: '1:1,2:2',
        title: 'Great Day',
        description: 'Had a wonderful day!',
        tags: '1:1,2:3',
      );

      final entryId = await dbService.addEntry(entry);

      final initialEmotions = await dbService.fetchEmotions();

      expect(initialEmotions[0].selectedCount, 0);
      expect(initialEmotions[1].selectedCount, 0);

      await dbService.setSelectedEmotionsCount(entryId);
      final happy = await dbService.getEmotion(1);
      final playful = await dbService.getEmotion(2);
      final updatedEmotions = [happy, playful];

      expect(updatedEmotions[1].selectedCount, 2);
      expect(updatedEmotions[0].selectedCount, 1);
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
      final workId = await dbService.addTag('work');
      await dbService.addTag('personal');

      Tag updatedTag = await dbService.getTag(workId);
      expect(updatedTag.selectedCount, 0);

      await dbService.incrementSelectedTagCount(workId);
      await dbService.fetchTags();

      updatedTag = await dbService.getTag(workId);
      expect(updatedTag.selectedCount, 1);

      await dbService.resetSelectedTagsCount();

      final updatedTags = await dbService.fetchTags();
      expect(updatedTags.every((t) => t.selectedCount == 0), isTrue);

      await dbService.incrementSelectedTagCount(workId);

      updatedTag = await dbService.getTag(workId);
      expect(updatedTag.selectedCount, 1);

      await dbService.resetSelectedTagCount(workId);
      updatedTag = await dbService.getTag(workId);
      expect(updatedTag.selectedCount, 0);
    });

    test('Set selected count for tags', () async {
      final entry = Entry(
        date: '2024-08-20',
        mood: 5,
        emotions: 'Happy:1,Excited:2',
        title: 'Great Day',
        description: 'Had a wonderful day!',
        tags: '1:1,2:3',
      );

      final entryId = await dbService.addEntry(entry);

      await dbService.addTag('personal');
      await dbService.addTag('work');

      final initialTags = await dbService.fetchTags();

      expect(initialTags[0].selectedCount, 0);
      expect(initialTags[1].selectedCount, 0);

      await dbService.setSelectedTagsCount(entryId);
      Future.delayed(const Duration(seconds: 1));
      final updatedTags = await dbService.fetchTags();
      updatedTags.sort((a, b) => a.name.compareTo(b.name));

      expect(updatedTags[0].name, 'personal');
      expect(updatedTags[0].selectedCount, 1);
      expect(updatedTags[1].name, 'work');
      expect(updatedTags[1].selectedCount, 3);
    });
  });
}
