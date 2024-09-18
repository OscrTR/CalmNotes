class Emotion {
  final int? id;
  final String nameEn;
  final String nameFr;
  final int level;
  final String? basicEmotion;
  final String? intermediateEmotion;
  final int lastUse;
  int selectedCount;

  Emotion({
    this.id,
    required this.nameEn,
    required this.nameFr,
    required this.level,
    this.basicEmotion,
    this.intermediateEmotion,
    required this.lastUse,
    required this.selectedCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nameEn': nameEn,
      'nameFr': nameFr,
      'level': level,
      'lastUse': lastUse,
      'basicEmotion': basicEmotion,
      'intermediateEmotion': intermediateEmotion,
      'selectedCount': selectedCount,
    };
  }

  factory Emotion.fromMap(Map<String, dynamic> map) {
    return Emotion(
      id: map['id'] as int,
      nameEn: map['nameEn'] as String,
      nameFr: map['nameFr'] as String,
      level: map['level'] as int,
      basicEmotion: map['basicEmotion'] as String,
      intermediateEmotion: map['intermediateEmotion'] as String,
      lastUse: map['lastUse'] as int,
      selectedCount: map['selectedCount'] as int,
    );
  }

  Emotion updateFrom(Emotion other) {
    return Emotion(
      id: id,
      nameEn: nameEn,
      nameFr: nameFr,
      level: level,
      basicEmotion: basicEmotion,
      intermediateEmotion: intermediateEmotion,
      lastUse: other.lastUse,
      selectedCount: other.selectedCount,
    );
  }
}
