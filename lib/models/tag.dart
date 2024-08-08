class Tag {
  final int? id;
  final String name;
  final int lastUse;
  final int selectedCount;

  Tag({
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

  factory Tag.fromMap(Map<String, dynamic> map) {
    return Tag(
      id: map['id'],
      name: map['name'],
      lastUse: map['lastUse'],
      selectedCount: map['selectedCount'],
    );
  }

  Tag updateFrom(Tag other) {
    return Tag(
      id: id,
      name: name,
      lastUse: other.lastUse,
      selectedCount: other.selectedCount,
    );
  }
}
