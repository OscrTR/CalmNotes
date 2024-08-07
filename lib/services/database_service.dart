import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/models/reminder.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _entriesTableName = 'entries';
  final String _entriesIdColumnName = 'id';
  final String _entriesTitleColumnName = 'title';
  final String _entriesDescriptionColumnName = 'description';
  final String _entriesDateColumnName = 'date';
  final String _entriesMoodColumnName = 'mood';
  final String _entriesEmotionsColumnName = 'emotions';
  final String _entriesTagsColumnName = 'tags';

  final String _remindersTableName = 'reminders';
  final String _remindersIdColumnName = 'id';
  final String _remindersTimeColumnName = 'time';

  final String _emotionsTableName = 'emotions';
  final String _emotionsIdColumnName = 'id';
  final String _emotionsNameColumnName = 'name';
  final String _emotionsLastUseColumnName = 'lastUse';
  final String _emotionsSelectedEmotionCountColumnName = 'selectedEmotionCount';

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }

  Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "calmNotes_db.db");
    return openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_entriesTableName (
          $_entriesIdColumnName INTEGER PRIMARY KEY,
          $_entriesDateColumnName TEXT NOT NULL,
          $_entriesMoodColumnName INTEGER NOT NULL,
          $_entriesEmotionsColumnName TEXT,
          $_entriesTitleColumnName TEXT,
          $_entriesDescriptionColumnName TEXT,
          $_entriesTagsColumnName TEXT
        )
        ''');
        db.execute('''
        CREATE TABLE $_remindersTableName (
          $_remindersIdColumnName INTEGER PRIMARY KEY,
          $_remindersTimeColumnName TEXT NOT NULL
        )
        ''');

        db.execute('''
        CREATE TABLE $_emotionsTableName (
          $_emotionsIdColumnName INTEGER PRIMARY KEY,
          $_emotionsNameColumnName TEXT NOT NULL,
          $_emotionsLastUseColumnName INTEGER NOT NULL,
          $_emotionsSelectedEmotionCountColumnName INTEGER NOT NULL
        )
        ''');
      },
    );
  }

  void addEntry(
    String date,
    int mood,
    String emotions,
    String title,
    String description,
    String tags,
  ) async {
    final db = await database;
    await db.insert(_entriesTableName, {
      _entriesDateColumnName: date,
      _entriesMoodColumnName: mood,
      _entriesEmotionsColumnName: emotions,
      _entriesTitleColumnName: title,
      _entriesDescriptionColumnName: description,
      _entriesTagsColumnName: tags
    });
  }

  Future<List<Entry>> getEntries() async {
    final db = await database;
    final data = await db.query(
      _entriesTableName,
      orderBy: 'date DESC',
    );
    List<Entry> entries = data
        .map(
          (e) => Entry(
            id: e['id'] as int,
            mood: e['mood'] as int,
            date: e['date'] as String,
            emotions: e['emotions'] as String,
            title: e['title'] as String,
            description: e['description'] as String,
            tags: e['tags'] as String,
          ),
        )
        .toList();
    return entries;
  }

  Future<Entry> getEntry(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      _entriesTableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      final entry = Entry(
        id: result.first['id'] as int,
        mood: result.first['mood'] as int,
        date: result.first['date'] as String,
        emotions: result.first['emotions'] as String,
        title: result.first['title'] as String,
        description: result.first['description'] as String,
        tags: result.first['tags'] as String,
      );
      return entry;
    } else {
      throw Exception('Entry with id $id not found');
    }
  }

  Future<int> getEntryMood(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      _entriesTableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return result.first['mood'] as int;
    } else {
      throw Exception('Entry with id $id not found');
    }
  }

  void updateEntry(int id, String date, int mood, String emotions, String title,
      String description, String tags) async {
    final db = await database;
    db.update(
      _entriesTableName,
      {
        _entriesDateColumnName: date,
        _entriesMoodColumnName: mood,
        _entriesEmotionsColumnName: emotions,
        _entriesTitleColumnName: title,
        _entriesDescriptionColumnName: description,
        _entriesTagsColumnName: tags,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  void deleteEntry(int id) async {
    final db = await database;
    await db.delete(
      _entriesTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  void addReminder(String time) async {
    final db = await database;
    await db.insert(_remindersTableName, {
      _remindersTimeColumnName: time,
    });
  }

  void deleteReminder(int id) async {
    final db = await database;
    await db.delete(
      _remindersTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Reminder>> getReminders() async {
    final db = await database;
    final data = await db.query(
      _remindersTableName,
      orderBy: 'time ASC',
    );

    List<Reminder> reminders = data
        .map(
          (e) => Reminder(
            id: e['id'] as int,
            time: e['time'] as String,
          ),
        )
        .toList();

    return reminders;
  }

  Future<int> addEmotion(String name) async {
    final db = await database;
    final lastUse = DateTime.now().toUtc().millisecondsSinceEpoch;
    int id = await db.insert(_emotionsTableName, {
      _emotionsNameColumnName: name,
      _emotionsLastUseColumnName: lastUse,
      _emotionsSelectedEmotionCountColumnName: 0,
    });
    return id;
  }

  void deleteEmotion(int id) async {
    final db = await database;
    await db.delete(
      _emotionsTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Emotion>> getEmotions() async {
    final db = await database;
    final data = await db.query(
      _emotionsTableName,
      orderBy: 'lastUse DESC',
    );

    List<Emotion> emotions = data
        .map(
          (e) => Emotion(
            id: e['id'] as int,
            name: e['name'] as String,
            lastUse: e['lastUse'] as int,
            selectedEmotionCount: e['selectedEmotionCount'] as int,
          ),
        )
        .toList();

    return emotions;
  }

  Future<Emotion> getEmotion(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      _entriesTableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Emotion.fromMap(result.first);
    } else {
      throw Exception('Entry with id $id not found');
    }
  }

  Future<int?> getSelectedEmotionCount(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      _emotionsTableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (result.isNotEmpty) {
      return Emotion.fromMap(result.first).selectedEmotionCount;
    } else {
      throw Exception('Emotion with id $id not found');
    }
  }

  Future<void> incrementSelectedEmotionCount(int id) async {
    final db = await database;
    final lastUse = DateTime.now().toUtc().millisecondsSinceEpoch;
    final currentCount = await getSelectedEmotionCount(id) ?? 0;
    int newCount = currentCount;
    if (newCount < 10) {
      newCount += 1;
    }
    await db.update(
      _emotionsTableName,
      {
        _emotionsSelectedEmotionCountColumnName: newCount,
        _emotionsLastUseColumnName: lastUse,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> decrementSelectedEmotionCount(int id) async {
    final db = await database;
    final currentCount = await getSelectedEmotionCount(id) ?? 0;
    int newCount = currentCount;
    if (newCount > 0) {
      newCount -= 1;
    }
    await db.update(
      _emotionsTableName,
      {
        _emotionsSelectedEmotionCountColumnName: newCount,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Emotion>> fetchEmotionsToDisplay() async {
    final db = await database;
    final data = await db.query(
      _emotionsTableName,
      orderBy: 'lastUse DESC',
    );

    List<Emotion> emotions = data
        .map(
          (e) => Emotion(
            id: e['id'] as int,
            name: e['name'] as String,
            lastUse: e['lastUse'] as int,
            selectedEmotionCount: e['selectedEmotionCount'] as int,
          ),
        )
        .toList();

    // Filter the list to include only emotions with selectedEmotionCount > 0
    List<Emotion> selectedEmotions =
        emotions.where((emotion) => emotion.selectedEmotionCount > 0).toList();

    // Initialize the emotionsToDisplay list with selected emotions
    final List<Emotion> emotionsToDisplay = List.from(selectedEmotions);

    // If emotionsToDisplay has less than 3 emotions, add unselected emotions
    if (emotionsToDisplay.length < 3) {
      // Filter out the emotions that are not selected
      List<Emotion> unselectedEmotions = emotions
          .where((emotion) => emotion.selectedEmotionCount == 0)
          .toList();

      // Add unselected emotions until the list has at least 3 emotions
      int remainingSlots = 3 - emotionsToDisplay.length;
      emotionsToDisplay.addAll(unselectedEmotions.take(remainingSlots));
    }

    return emotionsToDisplay;
  }

  Future<void> resetSelectedEmotionsCount() async {
    final db = await database;
    await db.update(
      _emotionsTableName,
      {
        _emotionsSelectedEmotionCountColumnName: 0,
      },
    );
  }

  Map<String, int> convertStringToMap(String emotionsString) {
    // Initialize the map to store emotion names and counts
    final Map<String, int> emotionMap = {};

    // Split the string into individual emotion parts
    final emotionParts = emotionsString.split(', ');

    // Process each part to extract name and count
    for (var part in emotionParts) {
      final parts = part.split(' : ');
      if (parts.length == 2) {
        final name = parts[0].trim();
        final count = int.tryParse(parts[1].trim()) ?? 0;
        emotionMap[name] = count;
      }
    }

    return emotionMap;
  }

  Future<void> setSelectedEmotionsCount(int id) async {
    final db = await database;

    Entry entry = await getEntry(id);

    Map<String, int> emotionMap = convertStringToMap(entry.emotions!);

    // Fetch emotions from the database
    List<Emotion> emotions = await getEmotions();

    // Create a map for quick lookup
    final Map<String, Emotion> emotionMapFromDb = {
      for (var emotion in emotions) emotion.name: emotion
    };

    // Update the emotions in the database
    for (var entry in emotionMap.entries) {
      final name = entry.key;
      final count = entry.value;

      if (emotionMapFromDb.containsKey(name)) {
        // Emotion exists in the database, update it
        final emotion = emotionMapFromDb[name];
        await db.update(
          _emotionsTableName,
          {
            _emotionsSelectedEmotionCountColumnName: count,
          },
          where: 'id = ?',
          whereArgs: [emotion!.id],
        );
      }
    }
  }
}
