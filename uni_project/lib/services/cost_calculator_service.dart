import '../models/cost_calculator_model.dart';

class CostCalculatorService {
  static CalculationResult calculateCost({
    required double acres,
    required String cropType,
    required double ureaPricePerBag,
    required double tspPricePerBag,
    required double mopPricePerBag,
    required double laborCost, 
    required double expectedYieldBags, 
    required double marketPricePerBag, 
  }) {
    
    final safeAcres = acres > 0 ? acres : 0.0;

    
    double ureaBags = safeAcres * 2.0;
    double tspBags = safeAcres * 1.0;
    double mopBags = safeAcres * 2.0;

    
    double totalFertilizerCost = (ureaBags * ureaPricePerBag) +
        (tspBags * tspPricePerBag) +
        (mopBags * mopPricePerBag);

    
    double totalLaborCost = safeAcres * laborCost;

    
    double totalInvestment = totalFertilizerCost + totalLaborCost;

    
    double estimatedYieldMax = safeAcres * expectedYieldBags;

    
    double estimatedRevenue = estimatedYieldMax * marketPricePerBag;

    
    double netProfit = estimatedRevenue - totalInvestment;

    
    double breakEvenYieldBags = marketPricePerBag > 0 
        ? totalInvestment / marketPricePerBag 
        : 0.0;

    return CalculationResult(
      acres: safeAcres,
      cropType: cropType,
      ureaBags: ureaBags,
      tspBags: tspBags,
      mopBags: mopBags,
      totalFertilizerCost: totalFertilizerCost,
      totalLaborCost: totalLaborCost,
      totalInvestment: totalInvestment,
      estimatedYieldMax: estimatedYieldMax,
      estimatedRevenue: estimatedRevenue,
      netProfit: netProfit,
      breakEvenYieldBags: breakEvenYieldBags, 
    );
  }
}