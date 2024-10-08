class Entry {
  final int? id;
  final int mood;
  final String date;
  final String? emotions;
  final String? title;
  final String? description;
  final String? tags;

  Entry({
    this.id,
    required this.date,
    required this.mood,
    this.emotions,
    this.title,
    this.description,
    this.tags,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'mood': mood,
      'emotions': emotions,
      'title': title,
      'description': description,
      'tags': tags,
    };
  }

  factory Entry.fromMap(Map<String, dynamic> map) {
    return Entry(
      id: map['id'],
      date: map['date'],
      mood: map['mood'],
      emotions: map['emotions'],
      title: map['title'],
      description: map['description'],
      tags: map['tags'],
    );
  }

  Entry copyWith({
    int? id,
    int? mood,
    String? date,
    String? emotions,
    String? title,
    String? description,
    String? tags,
  }) {
    return Entry(
      id: id ?? this.id,
      mood: mood ?? this.mood,
      date: date ?? this.date,
      emotions: emotions ?? this.emotions,
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
    );
  }
}
