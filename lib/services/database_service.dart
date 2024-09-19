import 'package:calm_notes/models/emotion.dart';
import 'package:calm_notes/models/entry.dart';
import 'package:calm_notes/models/reminder.dart';
import 'package:calm_notes/models/tag.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../emotions_list.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "calmNotes_db.db");
    return openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
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
          nameEn TEXT NOT NULL,
          nameFr TEXT NOT NULL,
          level INTEGER NOT NULL,
          basicEmotion TEXT,
          intermediateEmotion TEXT,
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

        await _insertInitialEmotions(db);
      },
    );
  }

  Future<int> _insert(String table, Map<String, dynamic> values) async {
    final db = await database;
    return await db.insert(table, values);
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

  // convert old emotion name to ids
  Future<void> _convertEmotions(Entry entry) async {
    final db = await database;
    String emotionsString = '';

    if (entry.emotions != null) {
      for (var emotion in entry.emotions!.split(',')) {
        final intId = int.tryParse(emotion.trim().split(' : ')[0]);
        final emotionName = emotion.trim().split(' : ')[0];
        // si intid est null trouver l'id correspondant au nom
        if (intId == null) {
          final List<Map<String, dynamic>> result = await db.query(
            'emotions',
            columns: ['id'],
            where: 'nameEn = ? OR nameFr = ?',
            whereArgs: [emotionName, emotionName],
          );

          if (result.isNotEmpty) {
            emotionsString +=
                '${result.first['id'] as int} : ${emotion.trim().split(' : ')[1]}';
          }
        }
      }
    }
    if (emotionsString != '') {
      Map<String, dynamic> values = {
        'emotions': emotionsString,
      };
      await db.update(
        'entries',
        values,
        where: 'id = ?',
        whereArgs: [entry.id],
      );
    }
  }

  // convert old tag name to ids
  Future<void> _convertTags(Entry entry) async {
    final db = await database;
    String tagsString = '';

    if (entry.tags != null) {
      for (var tag in entry.tags!.split(',')) {
        final intId = int.tryParse(tag.trim().split(' : ')[0]);
        final tagName = tag.trim().split(' : ')[0];
        // si intid est null trouver l'id correspondant au nom
        if (intId == null) {
          final List<Map<String, dynamic>> result = await db.query(
            'tags',
            columns: ['id'],
            where: 'name = ?',
            whereArgs: [tagName],
          );

          if (result.isNotEmpty) {
            tagsString +=
                '${result.first['id'] as int} : ${tag.trim().split(' : ')[1]}';
          }
        }
      }
    }
    if (tagsString != '') {
      Map<String, dynamic> values = {
        'tags': tagsString,
      };
      await db.update(
        'entries',
        values,
        where: 'id = ?',
        whereArgs: [entry.id],
      );
    }
  }

  Future<void> checkIfColumnExists() async {
    final db = await database;
    List<Map<String, dynamic>> columns =
        await db.rawQuery('PRAGMA table_info(emotions);');

    bool isUpToDate = false;
    for (var column in columns) {
      if (column['name'] == 'level') {
        isUpToDate = true;
      }
    }

    if (!isUpToDate) {
      await db.transaction((txn) async {
        await txn.execute('ALTER TABLE emotions RENAME TO old_emotions;');

        await txn.execute('''
        CREATE TABLE emotions (
          id INTEGER PRIMARY KEY,
          nameEn TEXT NOT NULL,
          nameFr TEXT NOT NULL,
          level INTEGER NOT NULL,
          basicEmotion TEXT,
          intermediateEmotion TEXT,
          lastUse INTEGER NOT NULL,
          selectedCount INTEGER NOT NULL
        )
        ''');

        await txn.execute('DROP TABLE old_emotions;');
      });

      _insertInitialEmotions(db);
    }
    final entries = await fetchEntries();
    for (var entry in entries) {
      await _convertEmotions(entry);
      await _convertTags(entry);
    }
  }

  Future<void> setOldTable() async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.execute('ALTER TABLE emotions RENAME TO old_emotions;');

      await txn.execute('''
        CREATE TABLE emotions (
          id INTEGER PRIMARY KEY,
          name TEXT NOT NULL,
          lastUse INTEGER NOT NULL,
          selectedCount INTEGER NOT NULL
        )
        ''');

      await txn.execute('DROP TABLE old_emotions;');
    });
  }

  Future<void> _insertInitialEmotions(Database db) async {
    for (var emotion in emotions) {
      // emotions come from emontions_list.dart
      await db.insert('emotions', emotion);
    }
  }

  // Entry methods

  Future<int> addEntry(Entry entry) async {
    return await _insert('entries', entry.toMap());
  }

  Future<List<Entry>> fetchEntries() async {
    final data = await _query('entries', orderBy: 'date DESC');
    return data.map((e) => Entry.fromMap(e)).toList();
  }

  Future<Entry> getEntry(int id) async {
    final data = await _queryById('entries', id);
    return Entry.fromMap(data!);
  }

  Future<int> getEntryMood(int id) async {
    final entry = await getEntry(id);
    return entry.mood;
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

  Future<void> deleteEmotion(int id) async {
    await _delete('emotions', id);
  }

  Future<List<Emotion>> fetchEmotions() async {
    final data = await _query('emotions', orderBy: 'lastUse DESC');
    return data.map((e) => Emotion.fromMap(e)).toList();
  }

  Future<Emotion> getEmotion(int id) async {
    final data = await _queryById('emotions', id);
    return Emotion.fromMap(data!);
  }

  Future<void> updateEmotion(int id, {int? selectedCount, int? lastUse}) async {
    final values = <String, dynamic>{};
    if (selectedCount != null) values['selectedCount'] = selectedCount;
    if (lastUse != null) values['lastUse'] = lastUse;
    await _update('emotions', values, id);
  }

  Future<void> incrementSelectedEmotionCount(int id) async {
    final emotion = await getEmotion(id);
    final newCount = (emotion.selectedCount < 10)
        ? emotion.selectedCount + 1
        : emotion.selectedCount;
    final lastUse = DateTime.now().toUtc().millisecondsSinceEpoch;
    await updateEmotion(id, selectedCount: newCount, lastUse: lastUse);
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
    final requiredEmotions = 3 - selectedEmotions.length;
    return selectedEmotions +
        unselectedEmotions.take(requiredEmotions).toList();
  }

  Future<void> resetSelectedEmotionsCount() async {
    final db = await database;
    await db.update('emotions', {'selectedCount': 0});
  }

  Future<void> resetSelectedEmotionCount(int id) async {
    await updateEmotion(id, selectedCount: 0);
  }

  Future<void> setSelectedEmotionsCount(int entryId) async {
    final entry = await getEntry(entryId);
    final emotionMap = _convertStringToMap(entry.emotions!);
    final emotions = await fetchEmotions();
    final emotionMapFromDb = {for (var e in emotions) e.id: e};

    for (var entry in emotionMap.entries) {
      final id = entry.key;
      final count = entry.value;
      if (emotionMapFromDb.containsKey(id)) {
        final emotion = emotionMapFromDb[id]!;
        await updateEmotion(emotion.id!, selectedCount: count);
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
    return Tag.fromMap(data!);
  }

  Future<void> updateTag(int id, {int? selectedCount, int? lastUse}) async {
    final values = <String, dynamic>{};
    if (selectedCount != null) values['selectedCount'] = selectedCount;
    if (lastUse != null) values['lastUse'] = lastUse;
    await _update('tags', values, id);
  }

  Future<void> incrementSelectedTagCount(int id) async {
    final tag = await getTag(id);
    final newCount =
        (tag.selectedCount < 10) ? tag.selectedCount + 1 : tag.selectedCount;
    final lastUse = DateTime.now().toUtc().millisecondsSinceEpoch;
    await updateTag(id, selectedCount: newCount, lastUse: lastUse);
  }

  Future<List<Tag>> fetchTagsToDisplay() async {
    final tags = await fetchTags();
    final selectedTags = tags.where((t) => t.selectedCount > 0).toList();
    if (selectedTags.length >= 3) {
      return selectedTags;
    }
    final unselectedTags = tags.where((t) => t.selectedCount == 0).toList();
    final requiredTags = 3 - selectedTags.length;
    return selectedTags + unselectedTags.take(requiredTags).toList();
  }

  Future<void> resetSelectedTagsCount() async {
    final db = await database;
    await db.update('tags', {'selectedCount': 0});
  }

  Future<void> resetSelectedTagCount(int id) async {
    await updateTag(id, selectedCount: 0);
  }

  Future<void> setSelectedTagsCount(int id) async {
    final entry = await getEntry(id);
    final tagMap = _convertStringToMap(entry.tags!);
    final tags = await fetchTags();
    final tagMapFromDb = {for (var t in tags) t.id: t};

    for (var entry in tagMap.entries) {
      final id = entry.key;
      final count = entry.value;
      if (tagMapFromDb.containsKey(id)) {
        final tag = tagMapFromDb[id]!;
        await updateTag(tag.id!, selectedCount: count);
      }
    }
  }

  // Helper method for converting String to Map

  Map<int, int> _convertStringToMap(String data) {
    final items = data.split(',');
    final Map<int, int> map = {};
    for (var item in items) {
      if (item.isEmpty) continue;
      final parts = item.split(':');
      final key = int.parse(parts[0].trim());
      final value = int.tryParse(parts[1].trim()) ?? 0;
      map[key] = value;
    }
    return map;
  }
}
