class Emotion {
  final int id;
  final String name;
  final int lastUse;
  final int selectedEmotionCount;

  Emotion({
    required this.id,
    required this.name,
    required this.lastUse,
    required this.selectedEmotionCount,
  });

  factory Emotion.fromMap(Map<String, dynamic> map) {
    return Emotion(
      id: map['id'] as int,
      name: map['name'] as String,
      lastUse: map['lastUse'] as int,
      selectedEmotionCount: map['selectedEmotionCount'] as int,
    );
  }

  Emotion updateFrom(Emotion other) {
    return Emotion(
      id: id,
      name: name,
      lastUse: other.lastUse,
      selectedEmotionCount: other.selectedEmotionCount,
    );
  }
}
