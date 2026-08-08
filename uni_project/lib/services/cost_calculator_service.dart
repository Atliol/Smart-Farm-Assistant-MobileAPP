import '../models/cost_calculator_model.dart';

class CostCalculatorService {
  static CalculationResult calculateCost({
    required double acres,
    required String cropType,
    required double ureaPricePerBag,
    required double tspPricePerBag,
    required double mopPricePerBag,
    required double laborCost, // ၁ ဧက လျှင် ကုန်ကျမည့် လုပ်သား/စက်ကိရိယာခ
    required double expectedYieldBags, // ၁ ဧက ထွက်ရှိနိုင်မည့် အထွက်နှုန်း (တင်း/အိတ်)
    required double marketPricePerBag, // ၁ တင်း/၁ အိတ် ပေါက်စျေး
  }) {
    // Input validation: ဧက သို့မဟုတ် စျေးနှုန်း ၀ ထက်ငယ်ပါက ဘေးကင်းအောင် ၀ အဖြစ် သတ်မှတ်မည်
    final safeAcres = acres > 0 ? acres : 0.0;

    // ဧကအလိုက် NPK အိတ် အရေအတွက် တွက်ချက်ခြင်း (Standard Recommendation)
    double ureaBags = safeAcres * 2.0;
    double tspBags = safeAcres * 1.0;
    double mopBags = safeAcres * 2.0;

    // ၁။ မြေသြဇာ ကုန်ကျစရိတ် စုစုပေါင်း
    double totalFertilizerCost = (ureaBags * ureaPricePerBag) +
        (tspBags * tspPricePerBag) +
        (mopBags * mopPricePerBag);

    // ၂။ လုပ်သားစရိတ် စုစုပေါင်း (၁ ဧက စရိတ် x ဧက အရေအတွက်)
    double totalLaborCost = safeAcres * laborCost;

    // ၃။ စုစုပေါင်း ရင်းနှီးမြှုပ်နှံမှု ကုန်ကျစရိတ်
    double totalInvestment = totalFertilizerCost + totalLaborCost;

    // ၄။ ခန့်မှန်း အထွက်နှုန်း စုစုပေါင်း (၁ ဧက အထွက်နှုန်း x ဧက အရေအတွက်)
    double estimatedYieldMax = safeAcres * expectedYieldBags;

    // ၅။ ခန့်မှန်း ရရှိမည့် ဝင်ငွေ စုစုပေါင်း
    double estimatedRevenue = estimatedYieldMax * marketPricePerBag;

    // ၆။ အသားတင် အမြတ် (ဝင်ငွေ - ရင်းနှီးမြှုပ်နှံမှု)
    double netProfit = estimatedRevenue - totalInvestment;

    // ၇။ အရင်းကြေ အထွက်နှုန်း (Breakeven Yield in Bags/Bushels)
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
      breakEvenYieldBags: breakEvenYieldBags, // Model ထဲတွင် ထည့်လိုပါက သုံးနိုင်ပါသည်
    );
  }
}