import 'package:flutter/material.dart';
import '../../../models/cost_calculator_model.dart';

class ResultCardWidget extends StatelessWidget {
  final CalculationResult result;

  const ResultCardWidget({
    super.key,
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.teal.shade50,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📊 တွက်ချက်မှု ရလဒ် (${result.cropType} - ${result.acres} ဧက)',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF00796B),
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            const Text(
              'လိုအပ်မည့် မြေဩဇာ ပမာဏ -',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• ယူရီးယား (Urea): ${result.ureaBags.toStringAsFixed(1)} အိတ်'),
                  Text('• တီစူပါ (TSP): ${result.tspBags.toStringAsFixed(1)} အိတ်'),
                  Text('• ပိုတက်ရှ် (MOP): ${result.mopBags.toStringAsFixed(1)} အိတ်'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('မြေဩဇာ ကုန်ကျစရိတ်:'),
                Text(
                  '${result.totalFertilizerCost.toStringAsFixed(0)} ကျပ်',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('လုပ်သား/စက်ကိရိယာခ:'),
                Text(
                  '${result.totalLaborCost.toStringAsFixed(0)} ကျပ်',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '💰 စုစုပေါင်း ရင်းနှီးစရိတ်:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${result.totalInvestment.toStringAsFixed(0)} ကျပ်',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '✨ ခန့်မှန်း အသားတင်အမြတ်:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${result.netProfit.toStringAsFixed(0)} ကျပ်',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}