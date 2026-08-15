import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/transaction_model.dart';

class IncomeExpenseBarChartWidget extends StatelessWidget {
  final List<TransactionModel> allItems;
  final int selectedYear;

  const IncomeExpenseBarChartWidget({
    super.key,
    required this.allItems,
    required this.selectedYear,
  });

  @override
  Widget build(BuildContext context) {
    // ၁။ ဇန်နဝါရီ မှ ဇွန် လအထိ (၁၂ လစာ) Income / Expense စုစုပေါင်း တွက်ချက်ခြင်း
    List<double> monthlyIncomes = List.filled(12, 0.0);
    List<double> monthlyExpenses = List.filled(12, 0.0);
    

    for (var item in allItems) {
      if (item.date.year == selectedYear && item.date.month >= 1 && item.date.month <= 12) {
        int monthIndex = item.date.month - 1;
        if (item.type == 'INCOME') {
          monthlyIncomes[monthIndex] += item.amount;
        } else if (item.type == 'EXPENSE') {
          monthlyExpenses[monthIndex] += item.amount;
        }
      }
    }

    // ၂။ Dynamic Max Y တွက်ချက်ခြင်း (Chart တိုင်အမြင့်ကို Auto ညှိပေးရန်)
    double maxData = 0;
    for (int i = 0; i < 12; i++) {
      if (monthlyIncomes[i] > maxData) maxData = monthlyIncomes[i];
      if (monthlyExpenses[i] > maxData) maxData = monthlyExpenses[i];
    }
    double calculatedMaxY = maxData == 0 ? 1000 : maxData * 1.25;

    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ဝင်ငွေ Vs ထွက်ငွေ',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
            ),
            const SizedBox(height: 12),
            // Legend Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildLegend(Colors.green.shade700, 'ဝင်ငွေ'),
                const SizedBox(width: 16),
                _buildLegend(Colors.red.shade700, 'ထွက်ငွေ'),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: calculatedMaxY,
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const SizedBox();
                          return Text(
                            value >= 1000 ? '${(value / 1000).toStringAsFixed(0)}k' : '${value.toInt()}',
                            style: const TextStyle(color: Colors.grey, fontSize: 10),
                          );
                        },
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun','Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                          int index = value.toInt();
                          if (index >= 0 && index < titles.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                titles[index],
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: List.generate(12, (index) {
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: monthlyIncomes[index],
                          color: Colors.green.shade700,
                          width: 10,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        BarChartRodData(
                          toY: monthlyExpenses[index],
                          color: Colors.red.shade700,
                          width: 10,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
