import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/crop_model.dart';
import '../models/fertilizer_model.dart';
import '../models/fungicide_model.dart';
import '../models/herbicide_model.dart';
import '../models/insecticide_model.dart';
import '../models/knowledge_model.dart';
import '../models/livestock_model.dart';
import '../models/aquaculture_model.dart';

class DatabaseService {
  static const String cropBoxName = "crops_box";
  static const String liveBoxName = "livestock_box";
  static const String knowBoxName = "knowledge_box";
  static const String aquaBoxName = "aquaculture_box";
  static const String insBoxName = "insecticide_box";
  static const String fungBoxName = "fungicide_box";
  static const String herbBoxName = "herbicide_box";
  static const String ferBoxName = "fertilizer_box";

  Future<List<CropModel>>? _cropsFuture;
  Future<List<LivestockModel>>? _livestockFuture;
  Future<List<KnowledgeModel>>? _knowledgeFuture;
  Future<List<AquacultureModel>>? _aquacultureFuture;
  Future<List<InsecticideModel>>? _insecticideFuture;
  Future<List<FungicideModel>>? _fungicideFuture;
  Future<List<HerbicideModel>>? _herbicideFuture;
  Future<List<FertilizerModel>>? _fertilizerFuture;

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
      } catch (e) {
        print("====== HIVE JSON ERROR ====== $e");
      }
      await box.flush(); // 💡 Safe flush
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
      } catch (e) {
        print("====== HIVE LIVESTOCK ERROR ====== $e");
      }
      await box.flush();
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

    try {
      final String response = await rootBundle.loadString('assets/data/knowledge_data.json');
      final List<dynamic> data = json.decode(response);

      for (var item in data) {
        final castedItem = _safeCast(item);
        final String knowId = castedItem['id'] as String? ?? DateTime.now().toString();
        await box.put(knowId, castedItem);
      }
    } catch (e) {
      print("====== HIVE KNOWLEDGE ERROR ====== $e");
    }
    await box.flush();

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
      } catch (e) {
        print("====== HIVE AQUACULTURE ERROR ====== $e");
      }
      await box.flush();
    }

    return box.values.map((item) {
      return AquacultureModel.fromJson(_safeCast(item));
    }).toList();
  }

  // ==================== ၅။ ပိုးသတ်ဆေးအပိုင်း (ပြင်ဆင်ပြီး) ====================
  Future<List<InsecticideModel>> getInsecticideData() {
    _insecticideFuture ??= _fetchAndLoadInsecticides();
    return _insecticideFuture!;
  }

  Future<List<InsecticideModel>> _fetchAndLoadInsecticides() async {
    var box = await Hive.openBox(insBoxName);

    // 💡 Performance ကောင်းမွန်စေရန် box ထဲမှာ ဘာမှမရှိမှသာ JSON ကို Read လုပ်ပြီး ထည့်ရန် ပြင်ဆင်လိုက်သည်
    if (box.isEmpty) {
      try {
        final String response = await rootBundle.loadString('assets/data/insecticide_data.json');
        final List<dynamic> data = json.decode(response);

        for (var item in data) {
          final castedItem = _safeCast(item);
          final String insId = castedItem['id'] as String? ?? DateTime.now().toString();
          await box.put(insId, castedItem);
        }
      } catch (e) {
        print("====== HIVE INSECTICIDE ERROR ====== $e");
      }
      await box.flush();
    }

    return box.values.map((item) {
      return InsecticideModel.fromJson(_safeCast(item));
    }).toList();
  }

  // ==================== ၆။ ရောဂါကာကွယ်ကုသဆေးအပိုင်း ====================
  Future<List<FungicideModel>> getFungicideData() {
    _fungicideFuture ??= _fetchAndLoadFungicides();
    return _fungicideFuture!;
  }

  Future<List<FungicideModel>> _fetchAndLoadFungicides() async {
    var box = await Hive.openBox(fungBoxName);

    if (box.isEmpty) {
      try {
        final String response = await rootBundle.loadString('assets/data/fungicide_data.json');
        final List<dynamic> data = json.decode(response);

        for (var item in data) {
          final castedItem = _safeCast(item);
          final String fungId = castedItem['id'] as String? ?? DateTime.now().toString();
          await box.put(fungId, castedItem);
        }
      } catch (e) {
        print("====== HIVE FUNGICIDE ERROR ====== $e");
      }
      await box.flush();
    }

    return box.values.map((item) {
      return FungicideModel.fromJson(_safeCast(item));
    }).toList();
  }

  // ==================== ၇။ ပေါင်းသတ်ဆေးအပိုင်း ====================
  Future<List<HerbicideModel>> getHerbicideData() {
    _herbicideFuture ??= _fetchAndLoadHerbicides();
    return _herbicideFuture!;
  }

  Future<List<HerbicideModel>> _fetchAndLoadHerbicides() async {
    var box = await Hive.openBox(herbBoxName);

    if (box.isEmpty) {
      try {
        final String response = await rootBundle.loadString('assets/data/herbicide_data.json');
        final List<dynamic> data = json.decode(response);

        for (var item in data) {
          final castedItem = _safeCast(item);
          final String herbId = castedItem['id'] as String? ?? DateTime.now().toString();
          await box.put(herbId, castedItem);
        }
      } catch (e) {
        print("====== HIVE HERBICIDE ERROR ====== $e");
      }
      await box.flush();
    }

    return box.values.map((item) {
      return HerbicideModel.fromJson(_safeCast(item));
    }).toList();
  }

  // ==================== ၈။ ဓာတ်မြေအောဇာအပိုင်း ====================
  Future<List<FertilizerModel>> getFertilizerData() {
    _fertilizerFuture ??= _fetchAndLoadFertilizers();
    return _fertilizerFuture!;
  }

  Future<List<FertilizerModel>> _fetchAndLoadFertilizers() async {
    var box = await Hive.openBox(ferBoxName);

    if (box.isEmpty) {
      try {
        final String response = await rootBundle.loadString('assets/data/fertilizer_data.json');
        final List<dynamic> data = json.decode(response);

        for (var item in data) {
          final castedItem = _safeCast(item);
          final String ferId = castedItem['id'] as String? ?? DateTime.now().toString();
          await box.put(ferId, castedItem);
        }
      } catch (e) {
        print("====== HIVE FERTILIZER ERROR ====== $e");
      }
      await box.flush();
    }

    return box.values.map((item) {
      return FertilizerModel.fromJson(_safeCast(item));
    }).toList();
  }
}