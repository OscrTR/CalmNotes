import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/models/reminder.dart';
import 'package:calm_notes/models/tag.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

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
        CREATE TABLE entries (
          id INTEGER PRIMARY KEY,
          date TEXT NOT NULL,
          mood INTEGER NOT NULL,
          emotions TEXT,
          title TEXT,
          description TEXT,
          tags TEXT
        )
        ''');
        db.execute('''
        CREATE TABLE reminders (
          id INTEGER PRIMARY KEY,
          time TEXT NOT NULL
        )
        ''');

        db.execute('''
        CREATE TABLE emotions (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          lastUse INTEGER NOT NULL,
          selectedCount INTEGER NOT NULL
        )
        ''');

        db.execute('''
        CREATE TABLE tags (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          lastUse INTEGER NOT NULL,
          selectedCount INTEGER NOT NULL
        )
        ''');
      },
    );
  }

  Future<void> _insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    await db.insert(table, values);
  }

  Future<void> _update(
      String table, Map<String, dynamic> values, int id) async {
    final db = await database;
    await db.update(table, values, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> _delete(String table, int id) async {
    final db = await database;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> _query(String table,
      {String? orderBy}) async {
    final db = await database;
    return db.query(table, orderBy: orderBy);
  }

  Future<Map<String, dynamic>?> _queryById(String table, int id) async {
    final db = await database;
    final result = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return result.isNotEmpty ? result.first : null;
  }

  // Entry methods

  Future<void> addEntry(Entry entry) async {
    await _insert('entries', entry.toMap());
  }

  Future<List<Entry>> fetchEntries() async {
    final data = await _query('entries', orderBy: 'date DESC');
    return data.map((e) => Entry.fromMap(e)).toList();
  }

  Future<Entry> getEntry(int id) async {
    final data = await _queryById('entries', id);
    if (data == null) throw Exception('Entry with id $id not found');
    return Entry.fromMap(data);
  }

  Future<int> getEntryMood(int id) async {
    final data = await _queryById('entries', id);
    if (data == null) throw Exception('Entry with id $id not found');
    return Entry.fromMap(data).mood;
  }

  Future<void> updateEntry(Entry entry) async {
    await _update('entries', entry.toMap(), entry.id!);
  }

  Future<void> deleteEntry(int id) async {
    await _delete('entries', id);
  }

// Reminder methods

  Future<void> addReminder(Reminder reminder) async {
    await _insert('reminders', reminder.toMap());
  }

  Future<List<Reminder>> fetchReminders() async {
    final data = await _query('reminders', orderBy: 'time ASC');
    return data.map((e) => Reminder.fromMap(e)).toList();
  }

  Future<void> deleteReminder(int id) async {
    await _delete('reminders', id);
  }

  // Emotion methods

  Future<int> addEmotion(String name) async {
    final lastUse = DateTime.now().toUtc().millisecondsSinceEpoch;
    final emotion = Emotion(name: name, lastUse: lastUse, selectedCount: 0);
    final db = await database;
    return db.insert('emotions', emotion.toMap());
  }

  Future<void> deleteEmotion(int id) async {
    await _delete('emotions', id);
  }

  Future<List<Emotion>> fetchEmotions() async {
    final data = await _query('emotions', orderBy: 'lastUse DESC');
    return data.map((e) => Emotion.fromMap(e)).toList();
  }

  Future<Emotion> getEmotion(int id) async {
    final data = await _queryById('emotions', id);
    if (data == null) throw Exception('Emotion with id $id not found');
    return Emotion.fromMap(data);
  }

  Future<int> getSelectedEmotionCount(int id) async {
    final emotion = await getEmotion(id);
    return emotion.selectedCount;
  }

  Future<void> incrementSelectedEmotionCount(int id) async {
    final emotion = await getEmotion(id);
    final newCount = (emotion.selectedCount < 10)
        ? emotion.selectedCount + 1
        : emotion.selectedCount;
    final lastUse = DateTime.now().toUtc().millisecondsSinceEpoch;
    await _update(
        'emotions',
        {
          'selectedCount': newCount,
          'lastUse': lastUse,
        },
        id);
  }

  Future<List<Emotion>> fetchEmotionsToDisplay() async {
    final emotions = await fetchEmotions();
    final selectedEmotions =
        emotions.where((e) => e.selectedCount > 0).toList();
    if (selectedEmotions.length >= 3) {
      return selectedEmotions;
    }
    final unselectedEmotions =
        emotions.where((e) => e.selectedCount == 0).toList();
    final required = 3 - selectedEmotions.length;
    return selectedEmotions + unselectedEmotions.take(required).toList();
  }

  Future<void> resetSelectedEmotionsCount() async {
    final db = await database;
    await db.update('emotions', {'selectedCount': 0});
  }

  Future<void> resetSelectedEmotionCount(int id) async {
    await _update(
        'emotions',
        {
          'selectedCount': 0,
        },
        id);
  }

  Future<void> setSelectedEmotionsCount(int id) async {
    final entry = await getEntry(id);
    final emotionMap = convertStringToMap(entry.emotions!);
    final emotions = await fetchEmotions();
    final emotionMapFromDb = {for (var e in emotions) e.name: e};
    for (var entry in emotionMap.entries) {
      final name = entry.key;
      final count = entry.value;
      if (emotionMapFromDb.containsKey(name)) {
        final emotion = emotionMapFromDb[name]!;
        await _update(
            'emotions',
            {
              'selectedCount': count,
            },
            emotion.id!);
      }
    }
  }

  // Tag methods

  Future<int> addTag(String name) async {
    final lastUse = DateTime.now().toUtc().millisecondsSinceEpoch;
    final tag = Tag(name: name, lastUse: lastUse, selectedCount: 0);
    final db = await database;
    return db.insert('tags', tag.toMap());
  }

  Future<void> deleteTag(int id) async {
    await _delete('tags', id);
  }

  Future<List<Tag>> fetchTags() async {
    final data = await _query('tags', orderBy: 'lastUse DESC');
    return data.map((e) => Tag.fromMap(e)).toList();
  }

  Future<Tag> getTag(int id) async {
    final data = await _queryById('tags', id);
    if (data == null) throw Exception('Tag with id $id not found');
    return Tag.fromMap(data);
  }

  Future<int> getSelectedTagCount(int id) async {
    final tag = await getTag(id);
    return tag.selectedCount;
  }

  Future<void> incrementSelectedTagCount(int id) async {
    final tag = await getTag(id);
    final newCount =
        (tag.selectedCount < 10) ? tag.selectedCount + 1 : tag.selectedCount;
    final lastUse = DateTime.now().toUtc().millisecondsSinceEpoch;
    await _update(
        'tags',
        {
          'selectedCount': newCount,
          'lastUse': lastUse,
        },
        id);
  }

  Future<List<Tag>> fetchTagsToDisplay() async {
    final tags = await fetchTags();
    final selectedTags = tags.where((t) => t.selectedCount > 0).toList();
    if (selectedTags.length >= 3) {
      return selectedTags;
    }
    final unselectedTags = tags.where((t) => t.selectedCount == 0).toList();
    final required = 3 - selectedTags.length;
    return selectedTags + unselectedTags.take(required).toList();
  }

  Future<void> resetSelectedTagsCount() async {
    final db = await database;
    await db.update('tags', {'selectedCount': 0});
  }

  Future<void> resetSelectedTagCount(int id) async {
    final db = await database;
    await db.update(
      'tags',
      {
        'selectedCount': 0,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> setSelectedTagsCount(int id) async {
    final entry = await getEntry(id);
    final tagMap = convertStringToMap(entry.tags!);
    final tags = await fetchTags();
    final tagMapFromDb = {for (var t in tags) t.name: t};
    for (var entry in tagMap.entries) {
      final name = entry.key;
      final count = entry.value;
      if (tagMapFromDb.containsKey(name)) {
        final tag = tagMapFromDb[name]!;
        await _update(
            'tags',
            {
              'selectedCount': count,
            },
            tag.id!);
      }
    }
  }

  // Helper method for converting String to Map

  Map<String, int> convertStringToMap(String data) {
    final items = data.split(',');
    final Map<String, int> map = {};
    for (var item in items) {
      if (item.isEmpty) continue;
      final parts = item.split(':');
      final key = parts[0];
      final value = int.tryParse(parts[1]) ?? 0;
      map[key] = value;
    }
    return map;
  }
}
