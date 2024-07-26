class Entry {
  final int id;
  final int mood;
  final String date;
  final String? emotions;
  final String? description;
  final String? tags;

  Entry({
    required this.id,
    required this.date,
    required this.mood,
    this.emotions,
    this.description,
    this.tags,
  });
}