import 'package:flutter/material.dart';

class CalculatorInputPage extends StatelessWidget {
  final TextEditingController acresController;
  final TextEditingController ureaPriceController;
  final TextEditingController tspPriceController;
  final TextEditingController mopPriceController;
  final TextEditingController laborCostController;
  final TextEditingController cropPriceController;
  final String selectedCrop;
  final ValueChanged<String?> onCropChanged;
  final VoidCallback onCalculate;

  const CalculatorInputPage({
    super.key,
    required this.acresController,
    required this.ureaPriceController,
    required this.tspPriceController,
    required this.mopPriceController,
    required this.laborCostController,
    required this.cropPriceController,
    required this.selectedCrop,
    required this.onCropChanged,
    required this.onCalculate,
  });

  // ရွေးချယ်နိုင်သော သီးနှံစာရင်းများ
  static const List<String> cropList = [
    'စပါး',
    'ပြောင်း',
    'မတ်ပဲ',
    'ပဲတီစိမ်း',
    'မြေပဲ',
  ];

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00796B);

    // စပါးဆိုလျှင် တင်း ၊ အခြားသီးနှံဆိုလျှင် အိတ် ဖြင့် ပြရန်
    final String cropUnit = selectedCrop == 'စပါး' ? 'တင်း' : 'အိတ်';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: primaryColor.withValues(alpha: 0.2)),
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
                          fontSize: 14,
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

          // Main Form Card
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('သီးနှံနှင့် မြေဧက အချက်အလက်'),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: cropList.contains(selectedCrop) ? selectedCrop : cropList.first,
                    decoration: _inputDecoration(
                      label: 'သီးနှံအမျိုးအစား ရွေးပါ',
                      icon: Icons.grass_outlined,
                    ),
                    items: cropList
                        .map((crop) => DropdownMenuItem(
                              value: crop,
                              child: Text(crop),
                            ))
                        .toList(),
                    onChanged: onCropChanged,
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: acresController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: _inputDecoration(
                      label: 'စိုက်ပျိုးမည့် မြေဧက',
                      suffixText: 'ဧက',
                      icon: Icons.landscape_outlined,
                    ),
                  ),

                  const SizedBox(height: 20),
                  _buildSectionTitle('မြေဩဇာနှင့် ကုန်ကျစရိတ် နှုန်းထားများ'),
                  const SizedBox(height: 12),
                  TextField(
                    controller: ureaPriceController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      label: 'ယူရီးယား (ပုလဲ) ၁ အိတ်စျေး',
                      suffixText: 'ကျပ်',
                      icon: Icons.shopping_bag_outlined,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: tspPriceController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      label: 'နိုက်ထရိုဂျင်/TSP ၁ အိတ်စျေး',
                      suffixText: 'ကျပ်',
                      icon: Icons.shopping_bag_outlined,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: mopPriceController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      label: 'ပိုတက်စီယမ် (K) ၁ အိတ်စျေး',
                      suffixText: 'ကျပ်',
                      icon: Icons.shopping_bag_outlined,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: laborCostController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      label: 'ခန့်မှန်း လုပ်သား/စက်ကိရိယာခ (၁ ဧက)',
                      suffixText: 'ကျပ်',
                      icon: Icons.engineering_outlined,
                    ),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: cropPriceController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration(
                      label: 'ခန့်မှန်း သီးနှံ ပေါက်စျေး (၁ $cropUnit)',
                      suffixText: 'ကျပ်',
                      icon: Icons.sell_outlined,
                    ),
                  ),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: onCalculate,
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
        ],
      ),
    );
  }

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
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF00796B), width: 1.5),
      ),
    );
  }
}