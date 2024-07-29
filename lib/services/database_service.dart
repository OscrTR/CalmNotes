import 'package:calm_notes/models/entry.dart';
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
    final data = await db.query(_entriesTableName);
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

  void updateEntry(int id, int mood) async {
    final db = await database;
    db.update(
      _entriesTableName,
      {
        _entriesMoodColumnName: mood,
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
}
