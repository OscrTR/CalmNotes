class Tag {
  final int id;
  final String name;
  final int lastUse;
  final int selectedTagCount;

  Tag({
    required this.id,
    required this.name,
    required this.lastUse,
    required this.selectedTagCount,
  });

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'] as int,
      name: map['name'] as String,
      lastUse: map['lastUse'] as int,
      selectedTagCount: map['selectedTagCount'] as int,
    );
  }

  Tag updateFrom(Tag other) {
    return Tag(
      id: id,
      name: name,
      lastUse: other.lastUse,
      selectedTagCount: other.selectedTagCount,
    );
  }
}
