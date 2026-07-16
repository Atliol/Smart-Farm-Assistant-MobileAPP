import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/crop_model.dart';
import '../models/knowledge_model.dart';
import '../models/livestock_model.dart';
import '../models/aquaculture_model.dart'; // 🆕 ၁။ ရေလုပ်ငန်း Model ကို Import လုပ်ပါသည်

class DatabaseService {
  // 💡 Box နာမည်များကို သီးသန့်စီ သတ်မှတ်ပေးထားပါသည်
  static const String cropBoxName = "crops_box";
  static const String liveBoxName = "livestock_box";
  static const String knowBoxName = "knowledge_box";
  static const String aquaBoxName = "aquaculture_box"; // 🆕 ၂။ ရေလုပ်ငန်း Box Name သတ်မှတ်ခြင်း

  // 💡 Stateless UI များမှ ခဏခဏ ခေါ်ယူလျှင် Loop မပတ်စေရန် Future Cache များ ထားရှိခြင်း
  Future<List<CropModel>>? _cropsFuture;
  Future<List<LivestockModel>>? _livestockFuture;
  Future<List<KnowledgeModel>>? _knowledgeFuture;
  Future<List<AquacultureModel>>? _aquacultureFuture; // 🆕 ၃။ ရေလုပ်ငန်းအတွက် Future Cache Variable

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
    var box = await Hive.openBox(cropBoxName);

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
    var box = await Hive.openBox(liveBoxName);

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
    var box = await Hive.openBox(knowBoxName);

    if (box.isEmpty) {
      try {
        final String response = await rootBundle.loadString('assets/data/knowledge_data.json');
        final List<dynamic> data = json.decode(response);

        for (var item in data) {
          final String knowId = item['id'] as String? ?? DateTime.now().toString();
          await box.put(knowId, Map<String, dynamic>.from(item as Map));
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

  // ==================== ၄။ ရေလုပ်ငန်းနည်းပညာအပိုင်း (🆕 အသစ်ပေါင်းစပ်မှု) ====================
  Future<List<AquacultureModel>> getAquacultureData() {
    // Cache ထဲတွင် ရှိပြီးသားဖြစ်က တိုက်ရိုက်ထုတ်ပေးပြီး မရှိသေးမှသာ Load လုပ်ပါမည်
    _aquacultureFuture ??= _fetchAndLoadAquaculture();
    return _aquacultureFuture!;
  }

  Future<List<AquacultureModel>> _fetchAndLoadAquaculture() async {
    var box = await Hive.openBox(aquaBoxName);

    if (box.isEmpty) {
      try {
        final String response = await rootBundle.loadString('assets/data/aquaculture_data.json');
        final List<dynamic> data = json.decode(response);

        for (var item in data) {
          final String aquaId = item['id'] as String? ?? DateTime.now().toString();
          await box.put(aquaId, Map<String, dynamic>.from(item as Map));
        }
        await box.flush();
      } catch (e) {
        print("====== HIVE AQUACULTURE ERROR ====== $e");
      }
    }

    return box.values.map((item) {
      return AquacultureModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }
}