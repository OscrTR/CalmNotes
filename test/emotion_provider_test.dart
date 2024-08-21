import 'package:flutter_test/flutter_test.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

void main() {
  late EmotionProvider emotionProvider;

  sqfliteTestInit();
  late DatabaseService dbService;

  setUp(() async {
    dbService = DatabaseService.instance;
    emotionProvider = EmotionProvider();
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

  test('Initial state is correct', () {
    expect(emotionProvider.emotions, []);
    expect(emotionProvider.emotionsToDisplay, []);
    expect(emotionProvider.emotionsInDialog, []);
  });

  test('addEmotion adds a new emotion', () async {
    await emotionProvider.addEmotion('Happy');

    expect(emotionProvider.emotions.first.id, 1);
    expect(emotionProvider.emotions.first.name, 'Happy');
    expect(emotionProvider.emotions.first.selectedCount, 0);
  });

  test('fetchEmotions updates emotions list', () async {
    await emotionProvider.addEmotion('Happy');
    await emotionProvider.addAndIncrementEmotion('Sad');
    await emotionProvider.addAndIncrementEmotion('Angry');
    await emotionProvider.addAndIncrementEmotion('Cheerful');

    await emotionProvider.fetchEmotions();

    expect(emotionProvider.emotions[0].name, 'Cheerful');
    expect(emotionProvider.emotions[0].selectedCount, 1);
    expect(emotionProvider.emotions[3].name, 'Happy');
    expect(emotionProvider.emotions[3].selectedCount, 0);
    expect(emotionProvider.emotionsToDisplay.first.name, 'Sad');
    expect(emotionProvider.emotionsInDialog[0].name, 'Happy');
  });

  test('deleteEmotion removes the emotion', () async {
    await emotionProvider.addEmotion('Happy');
    await emotionProvider.deleteEmotion(emotionProvider.emotions.first);

    expect(emotionProvider.emotions, []);
  });
}
