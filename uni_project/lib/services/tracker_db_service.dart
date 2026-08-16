import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';

class TrackerDbService {
  static const String _boxName = 'transactions_box';

  
  static Future<void> init() async {
    
    await Hive.initFlutter();

    
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TransactionModelAdapter());
    }

    
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<TransactionModel>(_boxName);
    }
  }

  
  static Box<TransactionModel> get _box {
    if (!Hive.isBoxOpen(_boxName)) {
      throw HiveError('Box is not opened. Please call TrackerDbService.init() first.');
    }
    return Hive.box<TransactionModel>(_boxName);
  }

  
  static List<TransactionModel> getAllTransactions() {
    return _box.values.toList();
  }

  
  static Future<void> addTransaction(TransactionModel item) async {
    await _box.put(item.id, item);
  }

  
  static Future<void> deleteTransaction(String id) async {
    await _box.delete(id);
  }

  
  static Future<void> updateTransaction(TransactionModel item) async {
    await _box.put(item.id, item);
  }

  
  static Future<void> clearAll() async {
    await _box.clear();
  }

  
  static double getTotalIncome() {
    return _box.values
        .where((e) => e.type == 'INCOME')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  
  static double getTotalExpense() {
    return _box.values
        .where((e) => e.type == 'EXPENSE')
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  
  static double getTotalBalance() => getTotalIncome() - getTotalExpense();
}