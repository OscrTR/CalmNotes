import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/models/entry.dart';
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
    final tables = ['entries', 'reminders', 'emotions', 'emotions'];

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

  test('fetchEmotions updates emotions list', () async {
    await emotionProvider.fetchEmotions();

    expect(emotionProvider.emotions[0].nameEn, 'Cheerful');
    expect(emotionProvider.emotions[0].selectedCount, 1);
    expect(emotionProvider.emotions[3].nameEn, 'Happy');
    expect(emotionProvider.emotions[3].selectedCount, 0);
    expect(emotionProvider.emotionsToDisplay.first.nameEn, 'Sad');
    expect(emotionProvider.emotionsInDialog[0].nameEn, 'Happy');
  });

  test(
      'fetchDisplayedemotions updates _emotionsToDisplay and _emotionsInDialog correctly',
      () async {
    final emotions = await dbService.fetchEmotions();

    List<Emotion> shouldBeDisplayedemotions = emotions.sublist(0, 3);
    List<Emotion> shouldBeDialogemotions = emotions.sublist(3);
    await emotionProvider.fetchDisplayedEmotions();
    expect(emotionProvider.emotionsToDisplay.map((emotion) => emotion.nameEn),
        shouldBeDisplayedemotions.map((emotion) => emotion.nameEn));
    expect(emotionProvider.emotionsInDialog.map((emotion) => emotion.nameEn),
        shouldBeDialogemotions.map((emotion) => emotion.nameEn));
  });

  test('Increment emotion then reset', () async {
    expect(emotionProvider.emotions[0].selectedCount, 0);
    expect(emotionProvider.emotions[1].selectedCount, 0);

    await emotionProvider.incrementEmotion(emotionProvider.emotions[0]);
    expect(emotionProvider.emotions[0].selectedCount, 1);
    expect(emotionProvider.emotions[1].selectedCount, 0);

    await emotionProvider.resetSelectedEmotion(emotionProvider.emotions[0]);
    expect(emotionProvider.emotions[0].selectedCount, 0);
    expect(emotionProvider.emotions[1].selectedCount, 0);

    await emotionProvider.incrementEmotion(emotionProvider.emotions[0]);
    expect(emotionProvider.emotions[0].selectedCount, 1);
    expect(emotionProvider.emotions[1].selectedCount, 0);

    await emotionProvider.incrementEmotion(emotionProvider.emotions[1]);
    expect(emotionProvider.emotions[0].selectedCount, 1);
    expect(emotionProvider.emotions[1].selectedCount, 1);

    await emotionProvider.resetEmotions();
    expect(emotionProvider.emotions[0].selectedCount, 0);
    expect(emotionProvider.emotions[1].selectedCount, 0);
  });

  test('Set emotions', () async {
    final entryToAdd = Entry(
      date: '2024-08-19|18:00',
      mood: 10,
      emotions: 'sad:1,happy:2',
      title: 'Cool title',
      description: 'My description.',
      tags: 'work:1,friends:2',
    );

    final entryId = await dbService.addEntry(entryToAdd);

    expect(emotionProvider.emotions[0].nameEn, 'happy');
    expect(emotionProvider.emotions[0].selectedCount, 0);
    expect(emotionProvider.emotions[1].selectedCount, 0);
    expect(emotionProvider.emotions[1].nameEn, 'sad');

    await emotionProvider.setEmotions(entryId);
    expect(emotionProvider.emotions[0].nameEn, 'happy');
    expect(emotionProvider.emotions[0].selectedCount, 2);
    expect(emotionProvider.emotions[1].selectedCount, 1);
    expect(emotionProvider.emotions[1].nameEn, 'sad');
  });
}
