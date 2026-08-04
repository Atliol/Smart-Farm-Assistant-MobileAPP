import 'package:flutter/material.dart';

class DashboardCardWidget extends StatelessWidget {
  final double totalBalance;
  final double totalIncome;
  final double totalExpense;

  const DashboardCardWidget({
    super.key,
    required this.totalBalance,
    required this.totalIncome,
    required this.totalExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF00796B),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Total Balance',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(
              '${totalBalance.toStringAsFixed(0)} ကျပ်',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildIncomeExpenseItem('Total Income', totalIncome, Colors.greenAccent),
                Container(height: 30, width: 1, color: Colors.white30),
                _buildIncomeExpenseItem('Total Expense', totalExpense, Colors.redAccent),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeExpenseItem(String title, double amount, Color color) {
    return Column(
      children: [
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12)),
        const SizedBox(height: 4),
        Text(
          '${amount.toStringAsFixed(0)} ကျပ်',
          style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}