import 'package:calm_notes/emotions_list.dart';
import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calm_notes/providers/emotion_provider.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  late EmotionProvider emotionProvider;
  late DatabaseService dbService;

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

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
      await db.delete(table);
    }
  });

  tearDownAll(() async {
    final db = await dbService.database;
    await db.close();
  });

  test('Initial state is correct', () async {
    await emotionProvider.fetchEmotions();
    expect(emotionProvider.emotions.length, 130);
    expect(emotionProvider.emotionsToDisplay.length, 3);
  });

  test('fetchEmotions updates emotions list', () async {
    await emotionProvider.fetchEmotions();

    expect(emotionProvider.emotions[0].nameEn, 'happy');
    expect(emotionProvider.emotions[0].selectedCount, 0);
    expect(emotionProvider.emotions[3].nameEn, 'cheeky');
    expect(emotionProvider.emotions[3].selectedCount, 0);
    expect(emotionProvider.emotionsToDisplay.first.nameEn, 'happy');
  });

  test(
      'fetchDisplayedemotions updates _emotionsToDisplay and _emotionsInDialog correctly',
      () async {
    final emotions = await dbService.fetchEmotions();

    List<Emotion> shouldBeDisplayedemotions = emotions.sublist(0, 3);
    await emotionProvider.fetchDisplayedEmotions();
    expect(emotionProvider.emotionsToDisplay.map((emotion) => emotion.nameEn),
        shouldBeDisplayedemotions.map((emotion) => emotion.nameEn));
  });

  test('Increment emotion then reset', () async {
    await emotionProvider.fetchEmotions();
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
      emotions: '1:1,2:2',
      title: 'Cool title',
      description: 'My description.',
      tags: '1:1,2:2',
    );

    await emotionProvider.fetchEmotions();

    final entryId = await dbService.addEntry(entryToAdd);

    expect(emotionProvider.emotions[0].nameEn, 'happy');
    expect(emotionProvider.emotions[0].selectedCount, 0);
    expect(emotionProvider.emotions[1].selectedCount, 0);
    expect(emotionProvider.emotions[1].nameEn, 'playful');

    await emotionProvider.setEmotions(entryId);
    expect(emotionProvider.emotions[0].nameEn, 'happy');
    expect(emotionProvider.emotions[0].selectedCount, 1);
    expect(emotionProvider.emotions[1].selectedCount, 2);
    expect(emotionProvider.emotions[1].nameEn, 'playful');
  });
}
