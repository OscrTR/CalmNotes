class Emotion {
  final int id;
  final String name;
  final int lastUse;

  Emotion({
    required this.id,
    required this.name,
    required this.lastUse,
  });

  factory Emotion.fromMap(Map<String, dynamic> map) {
    return Emotion(
      id: map['id'] as int,
      name: map['name'] as String,
      lastUse: map['lastUse'] as int,
    );
  }
}
