import 'package:flutter/material.dart';
import '../../models/cost_calculator_model.dart';
import '../../services/cost_calculator_service.dart';
import 'widgets/cost_chart_widget.dart';
import 'widgets/result_card_widget.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

@override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _acresController = TextEditingController(text: '1');
  final _ureaPriceController = TextEditingController(text: '120000');
  final _tspPriceController = TextEditingController(text: '110000');
  final _mopPriceController = TextEditingController(text: '95000');
  final _laborCostController = TextEditingController(text: '150000');
  final _cropPriceController = TextEditingController(text: '20000');

  String _selectedCrop = 'စပါး';
  CalculationResult? _result;

  void _onCalculate() {
    FocusScope.of(context).unfocus(); // Keyboard ခေါက်ချရန်

    double acres = double.tryParse(_acresController.text) ?? 1.0;
    double ureaPrice = double.tryParse(_ureaPriceController.text) ?? 0;
    double tspPrice = double.tryParse(_tspPriceController.text) ?? 0;
    double mopPrice = double.tryParse(_mopPriceController.text) ?? 0;
    double labor = double.tryParse(_laborCostController.text) ?? 0;
    double cropPrice = double.tryParse(_cropPriceController.text) ?? 0;

    setState(() {
      _result = CostCalculatorService.calculateCost(
        acres: acres,
        cropType: _selectedCrop,
        ureaPricePerBag: ureaPrice,
        tspPricePerBag: tspPrice,
        mopPricePerBag: mopPrice,
        laborCost: labor,
        expectedYieldBags: 70,
        marketPricePerBag: cropPrice,
      );
    });
  }

  @override
  void dispose() {
    _acresController.dispose();
    _ureaPriceController.dispose();
    _tspPriceController.dispose();
    _mopPriceController.dispose();
    _laborCostController.dispose();
    _cropPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00796B);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'စိုက်ပျိုးစရိတ် တွက်ချက်စက် 🧮',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Header Banner Box
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primaryColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calculate_outlined, color: primaryColor, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'စိုက်ပျိုးစရိတ်နှင့် အမြတ် ခန့်မှန်းရန်',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            fontSize: 15,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'အချက်အလက်များကို ဖြည့်သွင်း၍ တွက်ချက်မည်ကို နှိပ်ပါ',
                          style: TextStyle(color: Colors.black45, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // 2. Input Section Card
            Card(
              elevation: 1.5,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('သီးနှံနှင့် မြေဧက အချက်အလက်'),
                    const SizedBox(height: 12),
                    
                    // Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedCrop,
                      decoration: _inputDecoration(
                        label: 'သီးနှံအမျိုးအစား ရွေးပါ',
                        icon: Icons.grass_outlined,
                      ),
                      items: ['စပါး', 'ပြောင်း', 'နှမ်း', 'မြေပဲ']
                          .map((crop) => DropdownMenuItem(
                                value: crop,
                                child: Text(crop),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedCrop = val);
                        }
                      },
                    ),
                    const SizedBox(height: 14),

                    // Acres Input
                    TextField(
                      controller: _acresController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      decoration: _inputDecoration(
                        label: 'စိုက်ပျိုးမည့် မြေဧက',
                        suffixText: 'ဧက',
                        icon: Icons.landscape_outlined,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    _buildSectionTitle('ကုန်ကျစရိတ်နှင့် စျေးနှုန်းများ'),
                    const SizedBox(height: 12),

                    // Urea Price Input
                    TextField(
                      controller: _ureaPriceController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                        label: 'ယူရီးယား ၁ အိတ်စျေး',
                        suffixText: 'ကျပ်',
                        icon: Icons.shopping_bag_outlined,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Labor Cost Input
                    TextField(
                      controller: _laborCostController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                        label: 'ခန့်မှန်း လုပ်သား/စက်ကိရိယာခ',
                        suffixText: 'ကျပ်',
                        icon: Icons.engineering_outlined,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Market Price Input
                    TextField(
                      controller: _cropPriceController,
                      keyboardType: TextInputType.number,
                      decoration: _inputDecoration(
                        label: 'ခန့်မှန်း သီးနှံ ပေါက်စျေး (၁ တင်း)',
                        suffixText: 'ကျပ်',
                        icon: Icons.sell_outlined,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Calculate Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _onCalculate,
                        icon: const Icon(Icons.analytics_outlined, color: Colors.white),
                        label: const Text(
                          'တွက်ချက်မည်',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 3. Results & Chart Display Section
            if (_result != null) ...[
              ResultCardWidget(result: _result!),
              const SizedBox(height: 16),
              CostChartWidget(result: _result!),
            ],
          ],
        ),
      ),
    );
  }

  // Section Label Builder
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: Color(0xFF00796B),
      ),
    );
  }

  // Custom Input Decoration
  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    String? suffixText,
  }) {
    return InputDecoration(
      labelText: label,
      suffixText: suffixText,
      prefixIcon: Icon(icon, color: const Color(0xFF00796B), size: 20),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF00796B), width: 1.8),
      ),
    );
  }
}