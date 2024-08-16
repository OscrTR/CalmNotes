class Factor {
  final DateTime date;
  final String name;
  final double value;

  Factor({
    required this.date,
    required this.name,
    required this.value,
  });
}

class FactorSummary {
  double sum;
  double count;

  FactorSummary({
    required this.sum,
    required this.count,
  });
}
