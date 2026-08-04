class CalculationResult {
  final double acres;
  final String cropType;
  final double ureaBags;
  final double tspBags;
  final double mopBags;
  final double totalFertilizerCost;
  final double totalLaborCost;
  final double totalInvestment;
  final double estimatedYieldMax;
  final double estimatedRevenue;
  final double netProfit;

  CalculationResult({
    required this.acres,
    required this.cropType,
    required this.ureaBags,
    required this.tspBags,
    required this.mopBags,
    required this.totalFertilizerCost,
    required this.totalLaborCost,
    required this.totalInvestment,
    required this.estimatedYieldMax,
    required this.estimatedRevenue,
    required this.netProfit,
  });
}