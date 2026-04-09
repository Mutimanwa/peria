class CyclePrediction {
  final DateTime? nextPeriodStart;
  final DateTime? nextPeriodEnd;
  final DateTime? ovulationDay;
  final DateTime? fertileWindowStart;
  final DateTime? fertileWindowEnd;

  const CyclePrediction({
    this.nextPeriodStart,
    this.nextPeriodEnd,
    this.ovulationDay,
    this.fertileWindowStart,
    this.fertileWindowEnd,
  });
}
