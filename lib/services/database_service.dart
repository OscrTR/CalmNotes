import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();

  final String _entriesTableName = 'entries';
  final String _entriesIdColumnName = 'id';
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
    final database = openDatabase(
      databasePath,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_entriesTableName (
          $_entriesIdColumnName INTEGER PRIMARY KEY,
          $_entriesDateColumnName TEXT NOT NULL,
          $_entriesMoodColumnName INTEGER NOT NULL,
          $_entriesEmotionsColumnName TEXT,
          $_entriesDescriptionColumnName TEXT,
          $_entriesTagsColumnName TEXT
        )
        ''');
      },
    );
    return database;
  }
}
