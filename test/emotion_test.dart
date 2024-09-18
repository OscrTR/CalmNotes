import 'package:calm_notes/models/emotion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Emotion', () {
    test('toMap converts Emotion to Map correctly', () {
      final emotion = Emotion(
          id: 1,
          nameEn: 'happy',
          nameFr: 'joie',
          level: 0,
          basicEmotion: '',
          intermediateEmotion: '',
          lastUse: 1627848123,
          selectedCount: 10);
      final map = emotion.toMap();

      expect(map, {
        'id': 1,
        'nameEn': 'happy',
        'nameFr': 'joie',
        'level': 0,
        'basicEmotion': '',
        'intermediateEmotion': '',
        'lastUse': 1627848123,
        'selectedCount': 10,
      });
    });

    test('fromMap creates Emotion from Map correctly', () {
      final map = {
        'id': 1,
        'nameEn': 'happy',
        'nameFr': 'joie',
        'level': 0,
        'basicEmotion': '',
        'intermediateEmotion': '',
        'lastUse': 1627848123,
        'selectedCount': 10,
      };
      final emotion = Emotion.fromMap(map);

      expect(emotion.id, 1);
      expect(emotion.nameEn, 'happy');
      expect(emotion.nameFr, 'joie');
      expect(emotion.level, 0);
      expect(emotion.basicEmotion, '');
      expect(emotion.intermediateEmotion, '');
      expect(emotion.lastUse, 1627848123);
      expect(emotion.selectedCount, 10);
    });

    test('updateFrom creates a new Emotion with updated fields', () {
      final emotion1 = Emotion(
          id: 1,
          nameEn: 'happy',
          nameFr: 'heureux·se',
          level: 0,
          basicEmotion: '',
          intermediateEmotion: '',
          lastUse: 1627848123,
          selectedCount: 10);
      final emotion2 = Emotion(
          id: 2,
          nameEn: 'excited',
          nameFr: 'enthousiaste',
          level: 1,
          basicEmotion: 'surprised',
          intermediateEmotion: '',
          lastUse: 1627858123,
          selectedCount: 15);

      final updatedEmotion = emotion1.updateFrom(emotion2);

      expect(updatedEmotion.id, 1);
      expect(updatedEmotion.nameEn, 'happy');
      expect(updatedEmotion.lastUse, 1627858123);
      expect(updatedEmotion.selectedCount, 15);
    });
  });
}
