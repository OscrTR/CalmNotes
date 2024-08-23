import 'package:flutter_test/flutter_test.dart';
import 'package:calm_notes/providers/reminder_provider.dart';
import 'package:calm_notes/services/database_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void sqfliteTestInit() {
  // Initialize ffi implementation
  sqfliteFfiInit();
  // Set global factory
  databaseFactory = databaseFactoryFfi;
}

void main() {
  late ReminderProvider reminderProvider;

  sqfliteTestInit();
  late DatabaseService dbService;

  setUp(() async {
    dbService = DatabaseService.instance;
    reminderProvider = ReminderProvider();
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
    expect(reminderProvider.reminders, []);
  });

  test('addreminder adds a new reminder', () async {
    int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);
    await reminderProvider.addReminder('2024-09-10:00', notificationId);

    expect(reminderProvider.reminders.first.id, notificationId);
    expect(reminderProvider.reminders.first.time, '2024-09-10:00');
  });

  test('deletereminder removes the reminder', () async {
    int notificationId =
        DateTime.now().millisecondsSinceEpoch.remainder(100000);
    await reminderProvider.addReminder('2024-09-10:00', notificationId);
    await reminderProvider.deleteReminder(reminderProvider.reminders.first);

    expect(reminderProvider.reminders, []);
  });
}
