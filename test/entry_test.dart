import 'package:calm_notes/models/entry.dart';
import 'package:test/test.dart';

void main() {
  group('Entry', () {
    test('toMap converts Entry to Map correctly', () {
      final entry = Entry(
        id: 1,
        date: '2024-08-20',
        mood: 5,
        emotions: 'Happy, Excited',
        title: 'Great Day',
        description: 'Had a wonderful day!',
        tags: 'personal, work',
      );
      final map = entry.toMap();

      expect(map, {
        'id': 1,
        'date': '2024-08-20',
        'mood': 5,
        'emotions': 'Happy, Excited',
        'title': 'Great Day',
        'description': 'Had a wonderful day!',
        'tags': 'personal, work',
      });
    });

    test('fromMap creates Entry from Map correctly', () {
      final map = {
        'id': 1,
        'date': '2024-08-20',
        'mood': 4,
        'emotions': 'Content',
        'title': 'Good Day',
        'description': 'Today was a good day.',
        'tags': 'work, health',
      };
      final entry = Entry.fromMap(map);

      expect(entry.id, 1);
      expect(entry.date, '2024-08-20');
      expect(entry.mood, 4);
      expect(entry.emotions, 'Content');
      expect(entry.title, 'Good Day');
      expect(entry.description, 'Today was a good day.');
      expect(entry.tags, 'work, health');
    });

    test('fromMap handles null values correctly', () {
      final map = {
        'id': null,
        'date': '2024-08-20',
        'mood': 3,
        'emotions': null,
        'title': null,
        'description': null,
        'tags': null,
      };
      final entry = Entry.fromMap(map);

      expect(entry.id, null);
      expect(entry.date, '2024-08-20');
      expect(entry.mood, 3);
      expect(entry.emotions, null);
      expect(entry.title, null);
      expect(entry.description, null);
      expect(entry.tags, null);
    });

    test('creates a copy with modified fields', () {
      // Original Entry
      final originalEntry = Entry(
        id: 1,
        date: '2024-08-20',
        mood: 5,
        emotions: 'Happy,Excited:2',
        title: 'Great Day',
        description: 'Had a wonderful day!',
        tags: 'personal,work:3',
      );

      // Copy with modified mood
      final modifiedEntry = originalEntry.copyWith(mood: 3);

      expect(modifiedEntry.mood, 3); // Verify that mood is updated
      expect(modifiedEntry.date,
          originalEntry.date); // Other fields remain unchanged
      expect(modifiedEntry.emotions, originalEntry.emotions);
      expect(modifiedEntry.title, originalEntry.title);
      expect(modifiedEntry.description, originalEntry.description);
      expect(modifiedEntry.tags, originalEntry.tags);
      expect(modifiedEntry.id, originalEntry.id);
    });

    test(
        'creates a copy with all fields unchanged if no arguments are provided',
        () {
      // Original Entry
      final originalEntry = Entry(
        id: 1,
        date: '2024-08-20',
        mood: 5,
        emotions: 'Happy,Excited:2',
        title: 'Great Day',
        description: 'Had a wonderful day!',
        tags: 'personal,work:3',
      );

      // Copy without changing any field
      final copiedEntry = originalEntry.copyWith();

      expect(
          copiedEntry.mood, originalEntry.mood); // All fields remain unchanged
      expect(copiedEntry.date, originalEntry.date);
      expect(copiedEntry.emotions, originalEntry.emotions);
      expect(copiedEntry.title, originalEntry.title);
      expect(copiedEntry.description, originalEntry.description);
      expect(copiedEntry.tags, originalEntry.tags);
      expect(copiedEntry.id, originalEntry.id);
    });

    test('creates a copy with multiple fields modified', () {
      // Original Entry
      final originalEntry = Entry(
        id: 1,
        date: '2024-08-20',
        mood: 5,
        emotions: 'Happy,Excited:2',
        title: 'Great Day',
        description: 'Had a wonderful day!',
        tags: 'personal,work:3',
      );

      // Copy with modified mood and title
      final modifiedEntry = originalEntry.copyWith(
        mood: 4,
        title: 'Not So Great Day',
      );

      expect(modifiedEntry.mood, 4); // Verify that mood is updated
      expect(modifiedEntry.title,
          'Not So Great Day'); // Verify that title is updated
      expect(modifiedEntry.date,
          originalEntry.date); // Other fields remain unchanged
      expect(modifiedEntry.emotions, originalEntry.emotions);
      expect(modifiedEntry.description, originalEntry.description);
      expect(modifiedEntry.tags, originalEntry.tags);
      expect(modifiedEntry.id, originalEntry.id);
    });
  });
}
