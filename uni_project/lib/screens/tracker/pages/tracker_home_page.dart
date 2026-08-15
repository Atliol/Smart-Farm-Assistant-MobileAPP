import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/transaction_model.dart';
import '../../../services/tracker_db_service.dart';
import '../widgets/dashboard_card_widget.dart';
import '../widgets/chart_analytics_widget.dart';
import '../widgets/transaction_tile_widget.dart';

class TrackerHomePage extends StatefulWidget {
  const TrackerHomePage({super.key});

  @override
  State<TrackerHomePage> createState() => _TrackerHomePageState();
}

class _TrackerHomePageState extends State<TrackerHomePage> {
  List<TransactionModel> _allItems = [];
  String _selectedCategory = 'All';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final items = await TrackerDbService.getAllTransactions();
    setState(() {
      _allItems = items;
    });
  }

  List<TransactionModel> get _filteredItems {
    if (_selectedCategory == 'All') {
      return _allItems;
    }
    return _allItems.where((item) => item.category == _selectedCategory).toList();
  }

  void _showAddTransactionDialog() {
    final titleController = TextEditingController();
    final amountController = TextEditingController();
    String type = 'EXPENSE';
    String category = 'ဆေးဝါး';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(Icons.add_circle_outline, color: Color(0xFF00796B)),
                  SizedBox(width: 8),
                  Text('စာရင်းသစ် ထည့်သွင်းမည်', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'အကြောင်းအရာ',
                        prefixIcon: const Icon(Icons.edit_note),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'ပမာဏ (ကျပ်)',
                        prefixIcon: const Icon(Icons.attach_money),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: type,
                      decoration: InputDecoration(
                        labelText: 'အမျိုးအစား',
                        prefixIcon: const Icon(Icons.swap_horiz),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'EXPENSE', child: Text('ထွက်ငွေ (Expense)')),
                        DropdownMenuItem(value: 'INCOME', child: Text('ဝင်ငွေ (Income)')),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => type = val);
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: InputDecoration(
                        labelText: 'အမျိုးအစား ခွဲခြားမှု',
                        prefixIcon: const Icon(Icons.category_outlined),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: ['ဆေးဝါး', 'အလုပ်သမား', 'Transportation', 'အခြား']
                          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => category = val);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('မလုပ်တော့ပါ', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    if (titleController.text.isNotEmpty && amountController.text.isNotEmpty) {
                      final newTransaction = TransactionModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text,
                        amount: double.tryParse(amountController.text) ?? 0,
                        type: type,
                        category: category,
                        date: DateTime.now(),
                      );
                      await TrackerDbService.addTransaction(newTransaction);
                      await _loadData();
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text('သိမ်းမည်', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalIncome = TrackerDbService.getTotalIncome();
    double totalExpense = TrackerDbService.getTotalExpense();
    double totalBalance = TrackerDbService.getTotalBalance();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardCardWidget(
              totalBalance: totalBalance,
              totalIncome: totalIncome,
              totalExpense: totalExpense,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'မကြာသေးမီက စာရင်းများ',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _selectedCategory,
                      isDense: true,
                      style: const TextStyle(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600),
                      items: ['All', 'ဆေးဝါး', 'အလုပ်သမား', 'Transportation', 'အခြား']
                          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCategory = val);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _filteredItems.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          Text('စာရင်းများ မရှိသေးပါ', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];
                        return TransactionTileWidget(
                          transaction: item,
                          onDelete: () async {
                            await TrackerDbService.deleteTransaction(item.id);
                            await _loadData();
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryColor,
        onPressed: _showAddTransactionDialog,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('စာရင်းသစ်', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}