import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/crop_model.dart';
import '../models/knowledge_model.dart';
import '../models/livestock_model.dart';

class DatabaseService {
  // 💡 Box နာမည်များကို သီးသန့်စီ သတ်မှတ်ပေးထားပါသည်
  static const String cropBoxName = "crops_box";
  static const String liveBoxName = "livestock_box";
  static const String knowBoxName = "knowledge_box";

  // 💡 Stateless UI များမှ ခဏခဏ ခေါ်ယူလျှင် Loop မပတ်စေရန် Future Cache များ ထားရှိခြင်း
  Future<List<CropModel>>? _cropsFuture;
  Future<List<LivestockModel>>? _livestockFuture;
  Future<List<KnowledgeModel>>? _knowledgeFuture;

  // 💡 main.dart မှ နှိုးရန်
  static Future<void> initHive() async {
    await Hive.initFlutter();
  }

  // ==================== ၁။ သီးနှံစိုက်ပျိုးရေးအပိုင်း ====================
  Future<List<CropModel>> getCropsData() {
    _cropsFuture ??= _fetchAndLoadCrops();
    return _cropsFuture!;
  }

  Future<List<CropModel>> _fetchAndLoadCrops() async {
    var box = await Hive.openBox(cropBoxName); // 💡 cropBoxName ကို သုံးပါသည်

    if (box.isEmpty) {
      try {
        final String response = await rootBundle.loadString('assets/data/crops_data.json');
        final List<dynamic> data = json.decode(response);

        for (var item in data) {
          final crop = CropModel.fromJson(item as Map<String, dynamic>);
          await box.put(crop.id, Map<String, dynamic>.from(item as Map));
        }
        await box.flush();
      } catch (e) {
        print("====== HIVE JSON ERROR ====== $e");
      }
    }

    return box.values.map((item) {
      return CropModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  // ==================== ၂။ မွေးမြူရေးနည်းပညာအပိုင်း ====================
  Future<List<LivestockModel>> getLivestockData() {
    _livestockFuture ??= _fetchAndLoadLivestock();
    return _livestockFuture!;
  }

  Future<List<LivestockModel>> _fetchAndLoadLivestock() async {
    var box = await Hive.openBox(liveBoxName); // 💡 liveBoxName ကို သုံးပါသည်

    if (box.isEmpty) {
      try {
        final String response = await rootBundle.loadString('assets/data/livestock_data.json');
        final List<dynamic> data = json.decode(response);

        for (var item in data) {
          final String liveId = item['id'] as String? ?? DateTime.now().toString();
          await box.put(liveId, Map<String, dynamic>.from(item as Map));
        }
        await box.flush();
      } catch (e) {
        print("====== HIVE LIVESTOCK ERROR ====== $e");
      }
    }

    return box.values.map((item) {
      return LivestockModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }

  // ==================== ၃။ အထွေထွေဗဟုသုတအပိုင်း ====================
  Future<List<KnowledgeModel>> getKnowledgeData() {
    _knowledgeFuture ??= _fetchAndLoadKnowledge();
    return _knowledgeFuture!;
  }

  Future<List<KnowledgeModel>> _fetchAndLoadKnowledge() async {
    var box = await Hive.openBox(knowBoxName); // 💡 knowBoxName ကို သုံးပါသည်

    if (box.isEmpty) {
      try {
        final String response = await rootBundle.loadString('assets/data/knowledge_data.json');
        final List<dynamic> data = json.decode(response);

        for (var item in data) {
          final String knowId = item['id'] as String? ?? DateTime.now().toString();
          await box.put(knowId, Map<String, dynamic>.from(item as Map)); // 💡 Map အဖြစ် စနစ်တကျ ပြောင်းသိမ်းပါသည်
        }
        await box.flush();
      } catch (e) {
        print("====== HIVE KNOWLEDGE ERROR ====== $e");
      }
    }

    return box.values.map((item) {
      return KnowledgeModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }
}