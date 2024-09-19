class Factor {
  final DateTime date;
  final String nameEn;
  final String nameFr;
  double value;

  Factor({
    required this.date,
    required this.nameEn,
    required this.nameFr,
    required this.value,
  });

  void incrementValue(double amount) {
    value += amount;
  }
}
