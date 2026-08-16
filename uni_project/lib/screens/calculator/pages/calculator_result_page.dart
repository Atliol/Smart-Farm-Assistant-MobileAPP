import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/app_colors.dart';
import '../../../models/cost_calculator_model.dart';
import '../widgets/cost_chart_widget.dart';
import '../widgets/result_card_widget.dart';

class CalculatorResultPage extends StatelessWidget {
  final CalculationResult? result;
  final VoidCallback onReset;

  const CalculatorResultPage({
    super.key,
    required this.result,
    required this.onReset,
  });

  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    if (result == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'တွက်ချက်ထားသော ရလဒ်များ မရှိသေးပါ',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'အချက်အလက်များ ဖြည့်စွက်၍ အရင်တွက်ချက်ပေးပါ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF00796B),
                  side: const BorderSide(color: Color(0xFF00796B)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: onReset,
                icon: const Icon(Icons.edit_note_rounded, size: 20),
                label: const Text('တွက်ချက်ရန် စာမျက်နှာသို့သွားမည်'),
              ),
            ],
          ),
        ),
      );
    }

    final isProfit = result!.netProfit >= 0;
    final statusColor = isProfit ? const Color(0xFF2E7D32) : Colors.red.shade700;
    final statusBgColor = isProfit ? const Color(0xFFE8F5E9) : Colors.red.shade50;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: statusBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: statusColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  isProfit ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                  color: statusColor,
                  size: 36,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isProfit ? 'ခန့်မှန်း အသားတင် အမြတ်' : 'ခန့်မှန်း အသားတင် အရှုံး',
                        style: TextStyle(
                          fontSize: 12,
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_formatCurrency(result!.netProfit.abs())} ကျပ်',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          ResultCardWidget(result: result!),
          const SizedBox(height: 16),

          CostChartWidget(result: result!),
          const SizedBox(height: 24),

          Center(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'အသစ်ပြန်လည်တွက်ချက်ရန်',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}