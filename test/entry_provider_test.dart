import 'package:calm_notes/models/entry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calm_notes/providers/entry_provider.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

void main() {
  late EntryProvider entryProvider;

  sqfliteTestInit();
  late DatabaseService dbService;

  setUp(() async {
    dbService = DatabaseService.instance;
    entryProvider = EntryProvider();
  });

  tearDown(() async {
    final db = await dbService.database;
    final tables = ['entries', 'reminders', 'emotions', 'tags'];

    for (var table in tables) {
      await db.delete(table);
    }
  });

  tearDownAll(() async {
    final db = await dbService.database;
    await db.close();
  });

  final entryToAdd = Entry(
    date: '2024-08-19|18:00',
    mood: 10,
    emotions: 'sad:1,happy:2',
    title: 'Cool title',
    description: 'My description.',
    tags: 'work:1,friends:2',
  );

  test('Initial state is correct', () {
    expect(entryProvider.entries, []);
    expect(entryProvider.filteredEntries, []);
    expect(
        entryProvider.startDate.day,
        DateTime.now()
            .subtract(Duration(days: DateTime.now().weekday - 1))
            .day);
    expect(
        entryProvider.endDate.day,
        DateTime.now()
            .subtract(Duration(days: DateTime.now().weekday - 1))
            .add(const Duration(days: 6))
            .day);
    expect(entryProvider.error, null);
  });

  test('addentry adds a new entry', () async {
    await entryProvider.addEntry(entryToAdd);

    expect(entryProvider.entries.first.id, 1);
    expect(entryProvider.entries.first.mood, 10);
    expect(entryProvider.entries.first.date, '2024-08-19|18:00');
    expect(entryProvider.entries.first.emotions, 'sad:1,happy:2');
    expect(entryProvider.entries.first.title, 'Cool title');
    expect(entryProvider.entries.first.description, 'My description.');
    expect(entryProvider.entries.first.tags, 'work:1,friends:2');
    expect(entryProvider.filteredEntries, isNotEmpty);
  });

  test('Add entry updates the entries list', () async {
    final newEntry = Entry(id: 3, mood: 8, date: '2024-08-22|00:00:00');

    await entryProvider.addEntry(newEntry);

    expect(
        entryProvider.entries.any((entry) =>
            entry.id == newEntry.id &&
            entry.mood == newEntry.mood &&
            entry.date == newEntry.date),
        isTrue);

    expect(
        entryProvider.filteredEntries.any((entry) =>
            entry.id == newEntry.id &&
            entry.mood == newEntry.mood &&
            entry.date == newEntry.date),
        isTrue);
  });

  test('Delete entry updates the entries list', () async {
    final entryToDelete = Entry(id: 1, mood: 5, date: '2024-08-20|00:00:00');
    await entryProvider.addEntry(entryToDelete);

    await entryProvider.deleteEntry(entryToDelete.id!);

    expect(entryProvider.entries, isNot(contains(entryToDelete)));
    expect(entryProvider.filteredEntries, isNot(contains(entryToDelete)));
  });

  test('Update entry updates the entries list', () async {
    final entryToUpdate = Entry(id: 1, mood: 5, date: '2024-08-20|00:00:00');
    final updatedEntry = Entry(id: 1, mood: 9, date: '2024-08-20|00:00:00');
    await entryProvider.addEntry(entryToUpdate);

    await entryProvider.updateEntry(updatedEntry);

    expect(entryProvider.entries, contains(updatedEntry));
    expect(entryProvider.entries, isNot(contains(entryToUpdate)));
    expect(entryProvider.filteredEntries, contains(updatedEntry));
  });

  test('Set start and end date filters entries', () async {
    final entry1 = Entry(id: 1, mood: 5, date: '2024-08-19|00:00:00');
    final entry2 = Entry(id: 2, mood: 7, date: '2024-08-21|00:00:00');
    await entryProvider.addEntry(entry1);
    await entryProvider.addEntry(entry2);

    entryProvider.setStartEndDate(DateTime(2024, 8, 20), DateTime(2024, 8, 21));

    expect(
        entryProvider.filteredEntries.any((entry) =>
            entry.id == entry2.id &&
            entry.mood == entry2.mood &&
            entry.date == entry2.date),
        isTrue);

    expect(
        entryProvider.filteredEntries.any((entry) =>
            entry.id == entry1.id &&
            entry.mood == entry1.mood &&
            entry.date == entry1.date),
        isFalse);
  });

  test('Setting default week and month date', () {
    entryProvider.setStartEndDate(DateTime(2024, 8, 10), DateTime(2024, 8, 11));
    expect(entryProvider.startDate, DateTime(2024, 8, 10));
    expect(entryProvider.endDate, DateTime(2024, 8, 11));

    entryProvider.setDefaultWeekDate();
    expect(
        entryProvider.startDate.day,
        DateTime.now()
            .subtract(Duration(days: DateTime.now().weekday - 1))
            .day);
    expect(
        entryProvider.endDate.day,
        DateTime.now()
            .subtract(Duration(days: DateTime.now().weekday - 1))
            .add(const Duration(days: 6))
            .day);

    entryProvider.setDefaultMonthDate();
    DateTime now = DateTime.now();
    expect(entryProvider.startDate.day, DateTime(now.year, now.month, 1).day);
    expect(entryProvider.endDate.day, DateTime(now.year, now.month + 1, 0).day);
  });

  test('Getting mood distribution', () async {
    final entry1 = Entry(mood: 2, date: '2024-08-19|00:00:00');
    final entry2 = Entry(mood: 4, date: '2024-08-19|00:00:00');
    final entry3 = Entry(mood: 5, date: '2024-08-20|00:00:00');
    final entry4 = Entry(mood: 5, date: '2024-08-20|00:00:00');
    final entry5 = Entry(mood: 8, date: '2024-08-21|00:00:00');
    final entry6 = Entry(mood: 9, date: '2024-08-22|00:00:00');
    await entryProvider.addEntry(entry1);
    await entryProvider.addEntry(entry2);
    await entryProvider.addEntry(entry3);
    await entryProvider.addEntry(entry4);
    await entryProvider.addEntry(entry5);
    await entryProvider.addEntry(entry6);

    final moodMap = entryProvider.getMoodDistribution();
    expect(moodMap, {2: 1, 4: 1, 5: 2, 8: 1, 9: 1});
  });
}
