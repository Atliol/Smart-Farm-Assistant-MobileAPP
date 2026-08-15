import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../constants/app_colors.dart';
import '../../../models/cost_calculator_model.dart';

class CostChartWidget extends StatelessWidget {
  final CalculationResult result;

  const CostChartWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    // စုစုပေါင်း ရင်းနှီးစရိတ် ၀ ဖြစ်နေပါက Percentage Error မတက်စေရန်
    final double totalCost = result.totalInvestment;
    final bool hasData = totalCost > 0;

    // ရာခိုင်နှုန်း တွက်ချက်ခြင်း
    final double fertPercentage = hasData
        ? (result.totalFertilizerCost / totalCost) * 100
        : 0;
    final double laborPercentage = hasData
        ? (result.totalLaborCost / totalCost) * 100
        : 0;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'ကုန်ကျစရိတ် အချိုးအစား ပြဇယား',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: hasData
                  ? PieChart(
                      PieChartData(
                        sectionsSpace: 3,
                        centerSpaceRadius: 35,
                        sections: [
                          // ၁။ မြေဩဇာ စရိတ်
                          PieChartSectionData(
                            value: result.totalFertilizerCost,
                            title: fertPercentage > 0
                                ? '${fertPercentage.toStringAsFixed(0)}%'
                                : '',
                            color:AppColors.primaryColor,
                            radius: 45,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // ၂။ လုပ်သား စရိတ်
                          PieChartSectionData(
                            value: result.totalLaborCost,
                            title: laborPercentage > 0
                                ? '${laborPercentage.toStringAsFixed(0)}%'
                                : '',
                            color: Colors.orange.shade600,
                            radius: 45,
                            titleStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Center(
                      child: Text(
                        'ကုန်ကျစရိတ် အချက်အလက် မရှိပါ',
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                    ),
            ),
            const SizedBox(height: 16),
            
            // Chart Legends (အရောင်အညွှန်းများ)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegendItem(
                  color: AppColors.primaryColor,
                  label: 'မြေဩဇာ စရိတ်',
                ),
                const SizedBox(width: 20),
                _buildLegendItem(
                  color: Colors.orange.shade600,
                  label: 'လုပ်သား/စက်ခ',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Legend Item Builder
  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}