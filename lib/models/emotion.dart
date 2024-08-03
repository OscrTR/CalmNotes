class Emotion {
  final int id;
  final String name;
  final String? lastUse;

  Emotion({
    required this.id,
    required this.name,
    this.lastUse,
  });
}
