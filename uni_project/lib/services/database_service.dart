import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/crop_model.dart';
import '../models/knowledge_model.dart';
import '../models/livestock_model.dart';
import '../models/aquaculture_model.dart';

class DatabaseService {
  static const String cropBoxName = "crops_box";
  static const String liveBoxName = "livestock_box";
  static const String knowBoxName = "knowledge_box";
  static const String aquaBoxName = "aquaculture_box";

  Future<List<CropModel>>? _cropsFuture;
  Future<List<LivestockModel>>? _livestockFuture;
  Future<List<KnowledgeModel>>? _knowledgeFuture;
  Future<List<AquacultureModel>>? _aquacultureFuture;

  static Future<void> initHive() async {
    await Hive.initFlutter();
  }

  // Helper function to safely cast Hive map to Map<String, dynamic>
  Map<String, dynamic> _safeCast(dynamic item) {
    if (item is Map) {
      return item.map((key, value) => MapEntry(key.toString(), value));
    }
    return <String, dynamic>{};
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
          final castedItem = _safeCast(item);
          final crop = CropModel.fromJson(castedItem);
          await box.put(crop.id, castedItem);
        }
        await box.flush();
      } catch (e) {
        print("====== HIVE JSON ERROR ====== $e");
      }
    }

    return box.values.map((item) {
      return CropModel.fromJson(_safeCast(item));
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
          final castedItem = _safeCast(item);
          final String liveId = castedItem['id'] as String? ?? DateTime.now().toString();
          await box.put(liveId, castedItem);
        }
        await box.flush();
      } catch (e) {
        print("====== HIVE LIVESTOCK ERROR ====== $e");
      }
    }

    return box.values.map((item) {
      return LivestockModel.fromJson(_safeCast(item));
    }).toList();
  }

  // ==================== ၃။ အထွေထွေဗဟုသုတအပိုင်း ====================
  Future<List<KnowledgeModel>> getKnowledgeData() {
    _knowledgeFuture ??= _fetchAndLoadKnowledge();
    return _knowledgeFuture!;
  }

  Future<List<KnowledgeModel>> _fetchAndLoadKnowledge() async {
    var box = await Hive.openBox(knowBoxName);

    // 💡 ပြဿနာဖြေရှင်းချက် - JSON ဒေတာအသစ်များကို Hive ထဲသို့ အမြဲတမ်း Overwrite / Update လုပ်ပေးရန် ပြင်ဆင်ထားပါသည်
    try {
      final String response = await rootBundle.loadString('assets/data/knowledge_data.json');
      final List<dynamic> data = json.decode(response);

      // JSON ထဲက Data သစ်တွေကို database ထဲ အတင်းထည့်ပေးပါမည်
      for (var item in data) {
        final castedItem = _safeCast(item);
        final String knowId = castedItem['id'] as String? ?? DateTime.now().toString();
        await box.put(knowId, castedItem);
      }
      await box.flush();
    } catch (e) {
      print("====== HIVE KNOWLEDGE ERROR ====== $e");
    }

    return box.values.map((item) {
      return KnowledgeModel.fromJson(_safeCast(item));
    }).toList();
  }

  // ==================== ၄။ ရေလုပ်ငန်းနည်းပညာအပိုင်း ====================
  Future<List<AquacultureModel>> getAquacultureData() {
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
          final castedItem = _safeCast(item);
          final String aquaId = castedItem['id'] as String? ?? DateTime.now().toString();
          await box.put(aquaId, castedItem);
        }
        await box.flush();
      } catch (e) {
        print("====== HIVE AQUACULTURE ERROR ====== $e");
      }
    }

    return box.values.map((item) {
      return AquacultureModel.fromJson(_safeCast(item));
    }).toList();
  }
}