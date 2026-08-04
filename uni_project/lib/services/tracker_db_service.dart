import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';

class TrackerDbService {
  static const String _boxName = 'transactions_box';

  // Database Initialization
  static Future<void> init() async {
    // 1. Hive SDK ကို Flutter နှင့် ချိတ်ဆက် စတင်ခြင်း
    await Hive.initFlutter();

    // 2. Adapter ကို Register ပြုလုပ်ခြင်း
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }

    // 3. Box ကို ဖွင့်လှစ်ခြင်း
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<TransactionModel>(_boxName);
    }
  }

  // Safe Box Getter (Box မပွင့်သေးပါက Safety Check ပါဝင်သည်)
  static Box<TransactionModel> get _box {
    if (!Hive.isBoxOpen(_boxName)) {
      throw HiveError('Box is not opened. Please call TrackerDbService.init() first.');
    }
    return Hive.box<TransactionModel>(_boxName);
  }

  // စာရင်းများအားလုံး ပြန်ထုတ်ယူခြင်း
  static List<TransactionModel> getAllTransactions() {
    return _box.values.toList();
  }

  // စာရင်းသစ် ထည့်သွင်းခြင်း
  static Future<void> addTransaction(TransactionModel item) async {
    await _box.put(item.id, item);
  }

  // စာရင်း ဖျက်ထုတ်ခြင်း
  static Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  // စာရင်း ပြင်ဆင်ခြင်း (Update လုပ်ရန် လိုအပ်ပါက သုံးနိုင်ရန်)
  static Future<void> updateTransaction(TransactionModel item) async {
    await _box.put(item.id, item);
  }

  // စာရင်းအားလုံး ရှင်းလင်းခြင်း (Clear All)
  static Future<void> clearAll() async {
    await _box.clear();
  }

  // စုစုပေါင်း ဝင်ငွေ တွက်ချက်ခြင်း
  static double getTotalIncome() {
    return _box.values
        .where((e) => e.type == 'INCOME')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // စုစုပေါင်း ထွက်ငွေ တွက်ချက်ခြင်း
  static double getTotalExpense() {
    return _box.values
        .where((e) => e.type == 'EXPENSE')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // အသားတင် လက်ကျန်ငွေ တွက်ချက်ခြင်း
  static double getTotalBalance() => getTotalIncome() - getTotalExpense();
}