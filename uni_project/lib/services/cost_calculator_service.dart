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
    // ဧကအလိုက် NPK အိတ် အရေအတွက် တွက်ချက်ခြင်း
    double ureaBags = acres * 1.0;
    double tspBags = acres * 0.5;
    double mopBags = acres * 0.5;

    // ကုန်ကျစရိတ်များနှင့် ဝင်ငွေ တွက်ချက်ခြင်း
    double totalFertilizerCost = (ureaBags * ureaPricePerBag) +
        (tspBags * tspPricePerBag) +
        (mopBags * mopPricePerBag);

    double totalInvestment = totalFertilizerCost + laborCost;
    double estimatedYieldMax = acres * expectedYieldBags;
    double estimatedRevenue = estimatedYieldMax * marketPricePerBag;
    double netProfit = estimatedRevenue - totalInvestment;

    return CalculationResult(
      acres: acres,
      cropType: cropType,
      ureaBags: ureaBags,
      tspBags: tspBags,
      mopBags: mopBags,
      totalFertilizerCost: totalFertilizerCost,
      totalLaborCost: laborCost,
      totalInvestment: totalInvestment,
      estimatedYieldMax: estimatedYieldMax,
      estimatedRevenue: estimatedRevenue,
      netProfit: netProfit,
    );
  }
}