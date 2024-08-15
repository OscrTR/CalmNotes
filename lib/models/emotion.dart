class Emotion {
  final int? id;
  final String name;
  final int lastUse;
  int selectedCount;

  Emotion({
    this.id,
    required this.name,
    required this.lastUse,
    required this.selectedCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lastUse': lastUse,
      'selectedCount': selectedCount,
    };
  }

  factory Emotion.fromMap(Map<String, dynamic> map) {
    return Emotion(
      id: map['id'] as int,
      name: map['name'] as String,
      lastUse: map['lastUse'] as int,
      selectedCount: map['selectedCount'] as int,
    );
  }

  Emotion updateFrom(Emotion other) {
    return Emotion(
      id: id,
      name: name,
      lastUse: other.lastUse,
      selectedCount: other.selectedCount,
    );
  }
}
