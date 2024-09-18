import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/models/tag.dart';
import 'package:calm_notes/providers/tag_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

void main() {
  late TagProvider tagProvider;

  sqfliteTestInit();
  late DatabaseService dbService;

  setUp(() async {
    dbService = DatabaseService.instance;
    tagProvider = TagProvider();
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

  test('Initial state is correct', () {
    expect(tagProvider.tags, []);
    expect(tagProvider.tagsToDisplay, []);
  });

  test('addTag adds a new tag', () async {
    await tagProvider.addTag('work');

    expect(tagProvider.tags.first.id, 1);
    expect(tagProvider.tags.first.name, 'work');
    expect(tagProvider.tags.first.selectedCount, 0);
  });

  test('fetchtags updates tags list', () async {
    await tagProvider.addTag('work');
    await tagProvider.addAndIncrementTag('friends');
    await tagProvider.addAndIncrementTag('morning');
    await tagProvider.addAndIncrementTag('beach');

    await tagProvider.fetchTags();

    expect(tagProvider.tags[0].name, 'beach');
    expect(tagProvider.tags[0].selectedCount, 1);
    expect(tagProvider.tags[3].name, 'work');
    expect(tagProvider.tags[3].selectedCount, 0);
    expect(tagProvider.tagsToDisplay.first.name, 'friends');
  });

  test('deleteEmotion removes the emotion', () async {
    await tagProvider.addTag('work');
    await tagProvider.deleteTag(tagProvider.tags.first);

    expect(tagProvider.tags, []);
  });

  test('fetchDisplayedTags updates _tagsToDisplay and _tagsInDialog correctly',
      () async {
    await tagProvider.addTag('work');
    await tagProvider.addTag('friends');
    await tagProvider.addTag('sleep');
    await tagProvider.addTag('sport');

    final tags = await dbService.fetchTags();

    List<Tag> shouldBeDisplayedTags = tags.sublist(0, 3);
    await tagProvider.fetchDisplayedTags();
    expect(tagProvider.tagsToDisplay.map((tag) => tag.name),
        shouldBeDisplayedTags.map((tag) => tag.name));
  });

  test('Increment tag then reset', () async {
    await tagProvider.addTag('work');
    await tagProvider.addTag('friends');
    expect(tagProvider.tags[0].selectedCount, 0);
    expect(tagProvider.tags[1].selectedCount, 0);

    await tagProvider.incrementTag(tagProvider.tags[0]);
    expect(tagProvider.tags[0].selectedCount, 1);
    expect(tagProvider.tags[1].selectedCount, 0);

    await tagProvider.resetSelectedTag(tagProvider.tags[0]);
    expect(tagProvider.tags[0].selectedCount, 0);
    expect(tagProvider.tags[1].selectedCount, 0);

    await tagProvider.incrementTag(tagProvider.tags[0]);
    expect(tagProvider.tags[0].selectedCount, 1);
    expect(tagProvider.tags[1].selectedCount, 0);

    await tagProvider.incrementTag(tagProvider.tags[1]);
    expect(tagProvider.tags[0].selectedCount, 1);
    expect(tagProvider.tags[1].selectedCount, 1);

    await tagProvider.resetTags();
    expect(tagProvider.tags[0].selectedCount, 0);
    expect(tagProvider.tags[1].selectedCount, 0);
  });

  test('Set tags', () async {
    await tagProvider.addTag('work');
    await tagProvider.addTag('friends');

    final entryToAdd = Entry(
      date: '2024-08-19|18:00',
      mood: 10,
      emotions: 'sad:1,happy:2',
      title: 'Cool title',
      description: 'My description.',
      tags: 'work:1,friends:2',
    );

    final entryId = await dbService.addEntry(entryToAdd);

    expect(tagProvider.tags[0].name, 'friends');
    expect(tagProvider.tags[0].selectedCount, 0);
    expect(tagProvider.tags[1].selectedCount, 0);
    expect(tagProvider.tags[1].name, 'work');

    await tagProvider.setTags(entryId);
    expect(tagProvider.tags[0].name, 'friends');
    expect(tagProvider.tags[0].selectedCount, 2);
    expect(tagProvider.tags[1].selectedCount, 1);
    expect(tagProvider.tags[1].name, 'work');
  });
}
