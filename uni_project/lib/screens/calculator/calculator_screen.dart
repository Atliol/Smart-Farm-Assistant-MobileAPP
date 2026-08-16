import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/cost_calculator_model.dart';
import '../../services/cost_calculator_service.dart';
import 'pages/calculator_input_page.dart';
import 'pages/calculator_result_page.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  int _currentIndex = 0;

  final _acresController = TextEditingController(text: '1');
  final _ureaPriceController = TextEditingController(text: '120000');
  final _tspPriceController = TextEditingController(text: '110000');
  final _mopPriceController = TextEditingController(text: '95000');
  final _laborCostController = TextEditingController(text: '150000');
  final _cropPriceController = TextEditingController(text: '20000');

  String _selectedCrop = 'စပါး';
  CalculationResult? _result;

  double _getExpectedYieldForCrop(String crop) {
    switch (crop) {
      case 'စပါး':
        return 70.0;
      case 'ပြောင်း':
        return 50.0;
      case 'မတ်ပဲ':
      case 'ပဲတီစိမ်း':
        return 20.0;
      case 'မြေပဲ':
        return 40.0;
      default:
        return 50.0;
    }
  }

  void _onCalculate() {
    FocusScope.of(context).unfocus();

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
        expectedYieldBags: _getExpectedYieldForCrop(_selectedCrop),
        marketPricePerBag: cropPrice,
      );
      _currentIndex = 1;
    });
  }

  void _onReset() {
    setState(() {
      _acresController.text = '1';
      _ureaPriceController.text = '120000';
      _tspPriceController.text = '110000';
      _mopPriceController.text = '95000';
      _laborCostController.text = '150000';
      _cropPriceController.text = '20000';
      _selectedCrop = 'စပါး';
      _result = null;
      _currentIndex = 0;
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
    final List<Widget> pages = [
      CalculatorInputPage(
        acresController: _acresController,
        ureaPriceController: _ureaPriceController,
        tspPriceController: _tspPriceController,
        mopPriceController: _mopPriceController,
        laborCostController: _laborCostController,
        cropPriceController: _cropPriceController,
        selectedCrop: _selectedCrop,
        onCropChanged: (val) {
          if (val != null) setState(() => _selectedCrop = val);
        },
        onCalculate: _onCalculate,
      ),
      CalculatorResultPage(
        result: _result,
        onReset: _onReset,
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'စိုက်ပျိုးစရိတ် တွက်ချက်ခြင်း',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (index == 1 && _result == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('ကျေးဇူးပြု၍ အချက်အလက်များဖြည့်စွက်ပြီး "တွက်ချက်မည်" ကို နှိပ်ပါ'),
                duration: Duration(seconds: 2),
              ),
            );
            return;
          }
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_note_outlined),
            activeIcon: Icon(Icons.edit_note_rounded),
            label: 'တွက်ချက်ရန်',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            activeIcon: Icon(Icons.bar_chart_rounded),
            label: 'ရလဒ်များ',
          ),
        ],
      ),
    );
  }
}