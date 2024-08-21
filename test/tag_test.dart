import 'package:calm_notes/models/tag.dart';
import 'package:test/test.dart';

void main() {
  group('Tag', () {
    test('toMap converts Tag to Map correctly', () {
      final tag =
          Tag(id: 1, name: 'Work', lastUse: 1627848123, selectedCount: 8);
      final map = tag.toMap();

      expect(map, {
        'id': 1,
        'name': 'Work',
        'lastUse': 1627848123,
        'selectedCount': 8,
      });
    });

    test('fromMap creates Tag from Map correctly', () {
      final map = {
        'id': 1,
        'name': 'Personal',
        'lastUse': 1627848123,
        'selectedCount': 3,
      };
      final tag = Tag.fromMap(map);

      expect(tag.id, 1);
      expect(tag.name, 'Personal');
      expect(tag.lastUse, 1627848123);
      expect(tag.selectedCount, 3);
    });

    test('updateFrom creates a new Tag with updated fields', () {
      final tag1 =
          Tag(id: 1, name: 'Work', lastUse: 1627848123, selectedCount: 8);
      final tag2 =
          Tag(id: 2, name: 'Health', lastUse: 1627858123, selectedCount: 10);

      final updatedTag = tag1.updateFrom(tag2);

      expect(updatedTag.id, 1);
      expect(updatedTag.name, 'Work');
      expect(updatedTag.lastUse, 1627858123);
      expect(updatedTag.selectedCount, 10);
    });
  });
}
