import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class ChartAnalyticsWidget extends StatelessWidget {
  final double medicineExpense;
  final double laborExpense;
  final double transportExpense;
  final double otherExpense;

  const ChartAnalyticsWidget({
    super.key,
    required this.medicineExpense,
    required this.laborExpense,
    required this.transportExpense,
    required this.otherExpense,
  });

  @override
  Widget build(BuildContext context) {
    double total = medicineExpense + laborExpense + transportExpense + otherExpense;

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
            
            const Row(
              children: [
                Icon(Icons.pie_chart_outline_rounded, color: AppColors.primaryColor, size: 20),
                SizedBox(width: 8),
                Text(
                  'အသုံးစရိတ် အမျိုးအစားအလိုက် (Pie Chart)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            
            total == 0
                ? const SizedBox(
                    height: 160,
                    child: Center(
                      child: Text(
                        'အချက်အလက် မရှိသေးပါ',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  )
                : SizedBox(
                    height: 180,
                    child: Stack(
                      children: [
                        PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 50,
                            sections: [
                              if (medicineExpense > 0)
                                PieChartSectionData(
                                  color: Colors.teal,
                                  value: medicineExpense,
                                  title: '', 
                                  radius: 28,
                                ),
                              if (laborExpense > 0)
                                PieChartSectionData(
                                  color: Colors.orange,
                                  value: laborExpense,
                                  title: '',
                                  radius: 28,
                                ),
                              if (transportExpense > 0)
                                PieChartSectionData(
                                  color: Colors.blue,
                                  value: transportExpense,
                                  title: '',
                                  radius: 28,
                                ),
                              if (otherExpense > 0)
                                PieChartSectionData(
                                  color: Colors.purple,
                                  value: otherExpense,
                                  title: '',
                                  radius: 28,
                                ),
                            ],
                          ),
                        ),
                        
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'စုစုပေါင်း',
                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                              ),
                              Text(
                                '${total.toStringAsFixed(0)} K',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

            const SizedBox(height: 20),
            const Divider(height: 1),
            const SizedBox(height: 12),

            
            Wrap(
              spacing: 16,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                _buildLegendItem('ဆေးဝါး', AppColors.primaryColor, medicineExpense),
                _buildLegendItem('အလုပ်သမား', Colors.orange, laborExpense),
                _buildLegendItem('Transportation', Colors.blue, transportExpense),
                _buildLegendItem('အခြား', Colors.purple, otherExpense),
              ],
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildLegendItem(String title, Color color, double amount) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$title (${amount.toStringAsFixed(0)})',
          style: const TextStyle(fontSize: 12, color: Colors.black87),
        ),
      ],
    );
  }
}