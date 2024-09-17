class Emotion {
  final int? id;
  final String name_en;
  final String name_fr;
  final int level;
  final String? linkedEmotion;
  final int lastUse;
  int selectedCount;

  Emotion({
    this.id,
    required this.name_en,
    required this.name_fr,
    required this.level,
    this.linkedEmotion,
    required this.lastUse,
    required this.selectedCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name_en': name_en,
      'name_fr': name_fr,
      'lastUse': lastUse,
      'selectedCount': selectedCount,
    };
  }

  factory Emotion.fromMap(Map<String, dynamic> map) {
    return Emotion(
      id: map['id'] as int,
      name_en: map['name_en'] as String,
      name_fr: map['name_fr'] as String,
      level: map['level'] as int,
      linkedEmotion: map['linkedEmotion'] as String,
      lastUse: map['lastUse'] as int,
      selectedCount: map['selectedCount'] as int,
    );
  }

  Emotion updateFrom(Emotion other) {
    return Emotion(
      id: id,
      name_en: name_en,
      name_fr: name_fr,
      level: level,
      linkedEmotion: linkedEmotion,
      lastUse: other.lastUse,
      selectedCount: other.selectedCount,
    );
  }
}
