import 'package:calm_notes/models/emotion.dart';
import 'package:test/test.dart';

void main() {
  group('Emotion', () {
    test('toMap converts Emotion to Map correctly', () {
      final emotion =
          Emotion(id: 1, name: 'Happy', lastUse: 1627848123, selectedCount: 10);
      final map = emotion.toMap();

      expect(map, {
        'id': 1,
        'name': 'Happy',
        'lastUse': 1627848123,
        'selectedCount': 10,
      });
    });

    test('fromMap creates Emotion from Map correctly', () {
      final map = {
        'id': 1,
        'name': 'Sad',
        'lastUse': 1627848123,
        'selectedCount': 5,
      };
      final emotion = Emotion.fromMap(map);

      expect(emotion.id, 1);
      expect(emotion.name, 'Sad');
      expect(emotion.lastUse, 1627848123);
      expect(emotion.selectedCount, 5);
    });

    test('updateFrom creates a new Emotion with updated fields', () {
      final emotion1 =
          Emotion(id: 1, name: 'Happy', lastUse: 1627848123, selectedCount: 10);
      final emotion2 = Emotion(
          id: 2, name: 'Excited', lastUse: 1627858123, selectedCount: 15);

      final updatedEmotion = emotion1.updateFrom(emotion2);

      expect(updatedEmotion.id, 1);
      expect(updatedEmotion.name, 'Happy');
      expect(updatedEmotion.lastUse, 1627858123);
      expect(updatedEmotion.selectedCount, 15);
    });
  });
}
