import 'package:calm_notes/models/reminder.dart';
import 'package:test/test.dart';

void main() {
  group('Reminder', () {
    test('toMap converts Reminder to Map correctly', () {
      final reminder = Reminder(id: 1, time: '08:00 AM');
      final map = reminder.toMap();

      expect(map, {
        'id': 1,
        'time': '08:00 AM',
      });
    });

    test('fromMap creates Reminder from Map correctly', () {
      final map = {
        'id': 1,
        'time': '09:00 AM',
      };
      final reminder = Reminder.fromMap(map);

      expect(reminder.id, 1);
      expect(reminder.time, '09:00 AM');
    });
  });
}
