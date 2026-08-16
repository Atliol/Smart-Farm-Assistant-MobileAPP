import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/transaction_model.dart';

class TransactionTileWidget extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback onDelete;

  const TransactionTileWidget({
    super.key,
    required this.transaction,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isExpense = transaction.type == 'EXPENSE';
    final amountColor = isExpense ? Colors.red.shade700 : Colors.green.shade700;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            
            CircleAvatar(
              backgroundColor: isExpense ? Colors.red.shade50 : Colors.green.shade50,
              child: Icon(
                isExpense ? Icons.medical_services_outlined : Icons.arrow_downward,
                color: isExpense ? Colors.red : Colors.green,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          transaction.category,
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        DateFormat('d/M/yyyy').format(transaction.date),
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${isExpense ? '-' : '+'}${transaction.amount.toStringAsFixed(0)} ကျပ်',
                  style: TextStyle(
                    color: amountColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete_outline, size: 18, color: Colors.grey.shade400),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}