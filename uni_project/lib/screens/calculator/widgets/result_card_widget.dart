import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/cost_calculator_model.dart';

class ResultCardWidget extends StatelessWidget {
  final CalculationResult result;

  const ResultCardWidget({
    super.key,
    required this.result,
  });

  // ဂဏန်းများကို ကော်မာ (Commas) ခြားပေးသည့် Helper
  String _formatCurrency(double amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return formatter.format(amount);
  }

  // ဒသမ ကိန်းဂဏန်းများ သပ်ရပ်အောင် ပြပေးသည့် Helper
  String _formatDecimal(double value) {
    return value % 1 == 0 ? value.toInt().toString() : value.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final isProfit = result.netProfit >= 0;
    final String yieldUnit = result.cropType == 'စပါး' ? 'တင်း' : 'အိတ်';

    return Card(
      color: Colors.teal.shade50,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.teal.shade100),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'တွက်ချက်မှု ရလဒ် (${result.cropType} - ${_formatDecimal(result.acres)} ဧက)',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00796B),
                    ),
                  ),
                ),
                Icon(Icons.assessment_outlined, color: Colors.teal.shade700, size: 22),
              ],
            ),
            const Divider(height: 20),

            // ၁။ မြေသြဇာ ပမာဏ အပိုင်း
            const Text(
              'လိုအပ်မည့် မြေဩဇာ ပမာဏ -',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFertilizerRow('နိုက်ထရိုဂျင် (N)', result.ureaBags),
                  _buildFertilizerRow('ဖော့စဖိတ် (P)', result.tspBags),
                  _buildFertilizerRow('ပိုတက်စီယမ် (K)', result.mopBags),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // ၂။ စရိတ် ခွဲဝေမှု အပိုင်း
            _buildCostRow('မြေဩဇာ ကုန်ကျစရိတ်:', '${_formatCurrency(result.totalFertilizerCost)} ကျပ်'),
            const SizedBox(height: 6),
            _buildCostRow('လုပ်သား/စက်ကိရိယာခ:', '${_formatCurrency(result.totalLaborCost)} ကျပ်'),
            
            const SizedBox(height: 8),
            _buildCostRow(
              ' စုစုပေါင်း ရင်းနှီးစရိတ်:',
              '${_formatCurrency(result.totalInvestment)} ကျပ်',
              isBold: true,
              valueColor: Colors.red.shade700,
            ),
            
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // ၃။ အထွက်နှုန်း နှင့် ဝင်ငွေ အပိုင်း
            _buildCostRow(
              ' ခန့်မှန်း အထွက်နှုန်း:',
              '${_formatDecimal(result.estimatedYieldMax)} $yieldUnit',
            ),
            const SizedBox(height: 6),
            _buildCostRow(
              ' ခန့်မှန်း ရရှိမည့် ဝင်ငွေ:',
              '${_formatCurrency(result.estimatedRevenue)} ကျပ်',
            ),
            
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isProfit ? Colors.green.shade100 : Colors.red.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isProfit ? ' ခန့်မှန်း အသားတင်အမြတ်:' : ' ခန့်မှန်း အသားတင်အရှုံး:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isProfit ? Colors.green.shade900 : Colors.red.shade900,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    '${_formatCurrency(result.netProfit.abs())} ကျပ်',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isProfit ? Colors.green.shade900 : Colors.red.shade900,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fertilizer Row Builder
  Widget _buildFertilizerRow(String label, double bags) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(Icons.brightness_1, size: 6, color: Colors.teal.shade700),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
          Text(
            '${_formatDecimal(bags)} အိတ်',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // Cost Row Builder
  Widget _buildCostRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: Colors.black87,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? Colors.black87,
          ),
        ),
      ],
    );
  }
}