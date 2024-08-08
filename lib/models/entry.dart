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
}
