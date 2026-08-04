import 'package:flutter/material.dart';
import '../../models/transaction_model.dart';
import '../../services/tracker_db_service.dart';
import 'widgets/chart_analytics_widget.dart';
import 'widgets/dashboard_card_widget.dart';
import 'widgets/income_expense_bar_chart_widget.dart';
import 'widgets/transaction_tile_widget.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  List<TransactionModel> _allItems = [];
  String _selectedCategory = 'All';

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  final List<String> _months = [
    'ဇန်နဝါရီ',
    'ဖေဖော်ဝါရီ',
    'မတ်',
    'ဧပြီ',
    'မေ',
    'ဇွန်',
    'ဇူလိုင်',
    'ဩဂုတ်',
    'စက်တင်ဘာ',
    'အောက်တိုဘာ',
    'နိုဝင်ဘာ',
    'ဒီဇင်ဘာ'
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Database မှ Data များကို async ဖြင့် ပြန်လည်ဆွဲထုတ်ခြင်း
  Future<void> _loadData() async {
    final items = await TrackerDbService.getAllTransactions();
    setState(() {
      _allItems = items;
    });
  }

  List<TransactionModel> get _monthlyItems {
    return _allItems.where((item) {
      return item.date.month == _selectedMonth &&
          item.date.year == _selectedYear;
    }).toList();
  }

  List<TransactionModel> get _filteredItems {
    if (_selectedCategory == 'All') {
      return _monthlyItems;
    }
    return _monthlyItems
        .where((item) => item.category == _selectedCategory)
        .toList();
  }

  double get _monthlyIncome {
    return _monthlyItems
        .where((item) => item.type == 'INCOME')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get _monthlyExpense {
    return _monthlyItems
        .where((item) => item.type == 'EXPENSE')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  double get _monthlyBalance => _monthlyIncome - _monthlyExpense;

  double _getExpenseByCategory(String category) {
    return _monthlyItems
        .where((item) => item.type == 'EXPENSE' && item.category == category)
        .fold(0.0, (sum, item) => sum + item.amount);
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Row(
                children: [
                  Icon(Icons.add_circle_outline, color: Color(0xFF00796B)),
                  SizedBox(width: 8),
                  Text(
                    'စာရင်းသစ် ထည့်သွင်းမည်',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
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
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'ပမာဏ (ကျပ်)',
                        prefixIcon: const Icon(Icons.attach_money),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: type,
                      decoration: InputDecoration(
                        labelText: 'အမျိုးအစား',
                        prefixIcon: const Icon(Icons.swap_horiz),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'EXPENSE',
                          child: Text('ထွက်ငွေ (Expense)'),
                        ),
                        DropdownMenuItem(
                          value: 'INCOME',
                          child: Text('ဝင်ငွေ (Income)'),
                        ),
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => type = val);
                        }
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: category,
                      decoration: InputDecoration(
                        labelText: 'အမျိုးအစား ခွဲခြားမှု',
                        prefixIcon: const Icon(Icons.category_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: ['ဆေးဝါး', 'အလုပ်သမား', 'Transportation', 'အခြား']
                          .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => category = val);
                        }
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
                    backgroundColor: const Color(0xFF00796B),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                  onPressed: () async {
                    if (titleController.text.isNotEmpty &&
                        amountController.text.isNotEmpty) {
                      final newTransaction = TransactionModel(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text,
                        amount: double.tryParse(amountController.text) ?? 0,
                        type: type,
                        category: category,
                        date: DateTime.now(),
                      );

                      // Database သို့ သိမ်းဆည်းခြင်း
                      await TrackerDbService.addTransaction(newTransaction);
                      await _loadData();
                      if (context.mounted) Navigator.pop(context);
                    }
                  },
                  child: const Text(
                    'သိမ်းမည်',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
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
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          'စိုက်ပျိုးမွေးမြူရေး Money Tracker 🌾',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF00796B),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ၁။ Overall Total Balance Card
            DashboardCardWidget(
              totalBalance: totalBalance,
              totalIncome: totalIncome,
              totalExpense: totalExpense,
            ),

            const SizedBox(height: 16),

            // ၂။ Month & Year Selector Card
            Card(
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
                        Icon(Icons.calendar_month, color: Color(0xFF00796B), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'လချုပ် ကြည့်ရှုရန် ရွေးချယ်ပါ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF00796B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        // Month Dropdown
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedMonth,
                            decoration: InputDecoration(
                              labelText: 'လ',
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            items: List.generate(12, (index) {
                              return DropdownMenuItem(
                                value: index + 1,
                                child: Text(_months[index], style: const TextStyle(fontSize: 14)),
                              );
                            }),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedMonth = val);
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        // Year Dropdown
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedYear,
                            decoration: InputDecoration(
                              labelText: 'နှစ်',
                              filled: true,
                              fillColor: Colors.grey.shade50,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: Colors.grey.shade300),
                              ),
                            ),
                            items: [2024, 2025, 2026, 2027]
                                .map((year) => DropdownMenuItem(
                              value: year,
                              child: Text('$year', style: const TextStyle(fontSize: 14)),
                            ))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) {
                                setState(() => _selectedYear = val);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ၃။ Monthly Summary Display Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.shade100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.teal.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '${_months[_selectedMonth - 1]} $_selectedYear - လချုပ် အစီရင်ခံစာ',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF00796B),
                    ),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryStat(
                        'ဝင်ငွေ',
                        '${_monthlyIncome.toStringAsFixed(0)} ကျပ်',
                        Colors.green.shade700,
                        Icons.arrow_downward_rounded,
                      ),
                      Container(height: 30, width: 1, color: Colors.grey.shade300),
                      _buildSummaryStat(
                        'ထွက်ငွေ',
                        '${_monthlyExpense.toStringAsFixed(0)} ကျပ်',
                        Colors.red.shade700,
                        Icons.arrow_upward_rounded,
                      ),
                      Container(height: 30, width: 1, color: Colors.grey.shade300),
                      _buildSummaryStat(
                        'အသားတင်',
                        '${_monthlyBalance.toStringAsFixed(0)} ကျပ်',
                        _monthlyBalance >= 0 ? const Color(0xFF00796B) : Colors.red.shade700,
                        Icons.account_balance_wallet_outlined,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ၄။ Chart Analytics Section (Bar Chart & Pie Chart)
            IncomeExpenseBarChartWidget(
              allItems: _allItems,
              selectedYear: _selectedYear,
            ),

            const SizedBox(height: 16),

            ChartAnalyticsWidget(
              medicineExpense: _getExpenseByCategory('ဆေးဝါး'),
              laborExpense: _getExpenseByCategory('အလုပ်သမား'),
              transportExpense: _getExpenseByCategory('Transportation'),
              otherExpense: _getExpenseByCategory('အခြား'),
            ),

            const SizedBox(height: 20),

            // ၅။ Category Filter & Transaction List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'စာရင်းများ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
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
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      ),
                      items: ['All', 'ဆေးဝါး', 'အလုပ်သမား', 'Transportation', 'အခြား']
                          .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCategory = val);
                        }
                      },
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ၆။ Daily Expense List
            _filteredItems.isEmpty
                ? Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 36.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'ရွေးချယ်ထားသော လတွင် စာရင်းများ မရှိသေးပါ',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            )
                : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                return TransactionTileWidget(
                  transaction: item,
                  onDelete: () async {
                    // Database မှ တိုက်ရိုက် ဖျက်ထုတ်ခြင်း
                    await TrackerDbService.deleteTransaction(item.id);
                    await _loadData(); // Screen ပြန်လည် Update လုပ်ခြင်း
                  },
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF00796B),
        onPressed: _showAddTransactionDialog,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'စာရင်းသစ်',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildSummaryStat(String title, String value, Color color, IconData icon) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
            Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}