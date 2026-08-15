import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/transaction_model.dart';
import '../../../services/tracker_db_service.dart';
import '../widgets/chart_analytics_widget.dart';
import '../widgets/income_expense_bar_chart_widget.dart';

class TrackerAnalyticsPage extends StatefulWidget {
  const TrackerAnalyticsPage({super.key});

  @override
  State<TrackerAnalyticsPage> createState() => _TrackerAnalyticsPageState();
}

class _TrackerAnalyticsPageState extends State<TrackerAnalyticsPage> {
  List<TransactionModel> _allItems = [];
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  final List<String> _months = [
    'ဇန်နဝါရီ', 'ဖေဖော်ဝါရီ', 'မတ်', 'ဧပြီ', 'မေ', 'ဇွန်',
    'ဇူလိုင်', 'ဩဂုတ်', 'စက်တင်ဘာ', 'အောက်တိုဘာ', 'နိုဝင်ဘာ', 'ဒီဇင်ဘာ'
  ];

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

  List<TransactionModel> get _monthlyItems {
    return _allItems.where((item) {
      return item.date.month == _selectedMonth && item.date.year == _selectedYear;
    }).toList();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Month & Year Selector Card
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
                        Icon(Icons.calendar_month, color: AppColors.primaryColor, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'လချုပ် ကြည့်ရှုရန် ရွေးချယ်ပါ',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedMonth,
                            decoration: InputDecoration(
                              labelText: 'လ',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.primaryColor)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.primaryColor)),
                            ),
                            items: List.generate(12, (index) {
                              return DropdownMenuItem(value: index + 1, child: Text(_months[index], style: const TextStyle(fontSize: 14)));
                            }),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedMonth = val);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            value: _selectedYear,
                            decoration: InputDecoration(
                              labelText: 'နှစ်',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.primaryColor)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.primaryColor)),
                            ),
                            items: [2024, 2025, 2026, 2027]
                                .map((year) => DropdownMenuItem(value: year, child: Text('$year', style: const TextStyle(fontSize: 14))))
                                .toList(),
                            onChanged: (val) {
                              if (val != null) setState(() => _selectedYear = val);
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

            // Monthly Summary Box
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.shade100),
              ),
              child: Column(
                children: [
                  Text(
                    '${_months[_selectedMonth - 1]} $_selectedYear - လချုပ် အစီရင်ခံစာ',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.primaryColor),
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryStat('ဝင်ငွေ', '${_monthlyIncome.toStringAsFixed(0)} ကျပ်', Colors.green.shade700, Icons.arrow_downward_rounded),
                      Container(height: 30, width: 1, color: Colors.grey.shade300),
                      _buildSummaryStat('ထွက်ငွေ', '${_monthlyExpense.toStringAsFixed(0)} ကျပ်', Colors.red.shade700, Icons.arrow_upward_rounded),
                      Container(height: 30, width: 1, color: Colors.grey.shade300),
                      _buildSummaryStat('အသားတင်', '${_monthlyBalance.toStringAsFixed(0)} ကျပ်', _monthlyBalance >= 0 ? const Color(0xFF00796B) : Colors.red.shade700, Icons.account_balance_wallet_outlined),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Charts Section
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
          ],
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
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}