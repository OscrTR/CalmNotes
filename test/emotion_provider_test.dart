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

  test(
      'fetchDisplayedemotions updates _emotionsToDisplay and _emotionsInDialog correctly',
      () async {
    await emotionProvider.addEmotion('work');
    await emotionProvider.addEmotion('friends');
    await emotionProvider.addEmotion('sleep');
    await emotionProvider.addEmotion('sport');

    final emotions = await dbService.fetchEmotions();

    List<Emotion> shouldBeDisplayedemotions = emotions.sublist(0, 3);
    List<Emotion> shouldBeDialogemotions = emotions.sublist(3);
    await emotionProvider.fetchDisplayedEmotions();
    expect(emotionProvider.emotionsToDisplay.map((emotion) => emotion.name),
        shouldBeDisplayedemotions.map((emotion) => emotion.name));
    expect(emotionProvider.emotionsInDialog.map((emotion) => emotion.name),
        shouldBeDialogemotions.map((emotion) => emotion.name));
  });

  test('Increment emotion then reset', () async {
    await emotionProvider.addEmotion('work');
    await emotionProvider.addEmotion('friends');
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
    await emotionProvider.addEmotion('sad');
    await emotionProvider.addEmotion('happy');

    final entryToAdd = Entry(
      date: '2024-08-19|18:00',
      mood: 10,
      emotions: 'sad:1,happy:2',
      title: 'Cool title',
      description: 'My description.',
      tags: 'work:1,friends:2',
    );

    final entryId = await dbService.addEntry(entryToAdd);

    expect(emotionProvider.emotions[0].name, 'happy');
    expect(emotionProvider.emotions[0].selectedCount, 0);
    expect(emotionProvider.emotions[1].selectedCount, 0);
    expect(emotionProvider.emotions[1].name, 'sad');

    await emotionProvider.setEmotions(entryId);
    expect(emotionProvider.emotions[0].name, 'happy');
    expect(emotionProvider.emotions[0].selectedCount, 2);
    expect(emotionProvider.emotions[1].selectedCount, 1);
    expect(emotionProvider.emotions[1].name, 'sad');
  });
}
