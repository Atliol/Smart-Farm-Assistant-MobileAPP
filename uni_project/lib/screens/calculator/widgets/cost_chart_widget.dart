import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../models/cost_calculator_model.dart';

class CostChartWidget extends StatelessWidget {
  final CalculationResult result;

  const CostChartWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          '📈 ကုန်ကျစရိတ် အချိုးအစား ပြဇယား',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              sections: [
                PieChartSectionData(
                  value: result.totalFertilizerCost,
                  title: 'ဆေး/မြေဩဇာ',
                  color: Colors.teal,
                  radius: 50,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                PieChartSectionData(
                  value: result.totalLaborCost,
                  title: 'လုပ်သားခ',
                  color: Colors.orange,
                  radius: 50,
                  titleStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}