class CycleStatistics {
  const CycleStatistics({
    required this.averageCycleLength,
    required this.minCycleLength,
    required this.maxCycleLength,
    required this.stdDeviation,
    required this.totalCyclesLogged,
    required this.isRegular,
  });

  final int averageCycleLength;
  final int minCycleLength;
  final int maxCycleLength;
  final double stdDeviation;
  /// Number of complete cycles: the intervals between two saved periods, so
  /// one fewer than the number of saved periods.
  final int totalCyclesLogged;
  final bool isRegular;
}
