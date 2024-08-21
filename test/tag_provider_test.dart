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
    expect(tagProvider.tagsInDialog, []);
  });

  test('addTag adds a new emotion', () async {
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
    expect(tagProvider.tagsInDialog[0].name, 'work');
  });

  test('deleteEmotion removes the emotion', () async {
    await tagProvider.addTag('work');
    await tagProvider.deleteTag(tagProvider.tags.first);

    expect(tagProvider.tags, []);
  });
}
