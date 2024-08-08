class Reminder {
  final int? id;
  final String time;

  Reminder({
    this.id,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'time': time,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map) {
    return Reminder(
      id: map['id'],
      time: map['time'],
    );
  }
}
