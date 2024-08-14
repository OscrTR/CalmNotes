class Factor {
  final DateTime date;
  final String name;
  final int value;

  Factor({
    required this.date,
    required this.name,
    required this.value,
  });
}

class FactorSummary {
  int sum;
  int count;

  FactorSummary({
    required this.sum,
    required this.count,
  });
}
