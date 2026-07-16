import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/crop_model.dart';
import '../models/livestock_model.dart';

class DatabaseService {
  static const String boxName = "crops_box";
  static const String liveBoxName = "livestock_box";

  // 💡 StatelessWidget ဖြစ်နေသော UI ဘက်မှ ခဏခဏ လှမ်းခေါ်လျှင် Loop မပတ်စေရန် Future ကို Cache လုပ်ထားမည့် variable
  Future<List<CropModel>>? _cropsFuture;

  // 💡 main.dart မှ လှမ်းခေါ်ရမည့် Function
  static Future<void> initHive() async {
    await Hive.initFlutter();
  }

  Future<List<CropModel>> getCropsData() {
    // အကယ်၍ _cropsFuture ထဲမှာ ဒေတာ ရှိပြီးသားဖြစ်ပါက အသစ်ထပ်မလုပ်တော့ဘဲ လက်ရှိရှိတာကိုပဲ တန်းပြန်ပေးမည်
    _cropsFuture ??= _fetchAndLoadCrops();
    return _cropsFuture!;
  }

  Future<List<LivestockModel>> getLivestockData() async {
    var box = await Hive.openBox(liveBoxName);

    // ဒေတာ အသစ်ဝင်အောင် စမ်းသပ်စဉ်မှာ clear() ခဏသုံးနိုင်ပြီး အဆင်ပြေရင် ပိတ်လိုက်ပါ
    // await box.clear();

    if (box.isEmpty) {
      try {
        final String response = await rootBundle.loadString('assets/data/livestock_data.json');
        final List<dynamic> data = json.decode(response);

        for (var item in data) {
          final String liveId = item['id'] as String? ?? DateTime.now().toString();
          await box.put(liveId, item);
        }
        await box.flush();
      } catch (e) {
        print("====== HIVE LIVESTOCK ERROR ====== $e");
      }
    }

    return box.values.map((item) {
      return LivestockModel.fromJson(Map<String, dynamic>.from(item));
    }).toList();
  }


  // 💡 JSON မှ ဖတ်ပြီး Hive ထဲထည့်ကာ ဒေတာထုတ်ပေးမည့် သီးသန့် အဓိကဖန်ရှင်
  Future<List<CropModel>> _fetchAndLoadCrops() async {
    // Box မပွင့်သေးလျှင် ဖွင့်မည်
    var box = await Hive.openBox(boxName);

    // အဟောင်းတွေ ရှုပ်မနေအောင် ရှင်းထုတ်မည်
    //await box.clear();

    if (box.isEmpty) {
      try {
        // ၁။ JSON ဖိုင်ကို လှမ်းဖတ်ခြင်း
        final String response = await rootBundle.loadString('assets/data/crops_data.json');

        // ၂။ JSON Data ကို Decode လုပ်ခြင်း
        final List<dynamic> data = json.decode(response);

        // ၃။ ဒေတာများကို ပိုမိုစိတ်ချရသော Cast ဖြင့် Hive ထဲ ထည့်ခြင်း
        for (var item in data) {
          final crop = CropModel.fromJson(item as Map<String, dynamic>);
          await box.put(crop.id, Map<String, dynamic>.from(item as Map));
        }

        // ၄။ Memory ထဲမှ ဒေတာများကို Device Storage (Disk) ပေါ်သို့ အသေသိမ်းခြင်း
        await box.flush();
      } catch (e) {
        print("====== HIVE JSON ERROR ====== $e");
      }
    }

    // ၅။ Hive ထဲမှ ဒေတာများကို Type casting မှန်ကန်စွာဖြင့် List ပြန်ထုတ်ခြင်း
    return box.values.map((item) {
      return CropModel.fromJson(Map<String, dynamic>.from(item as Map));
    }).toList();
  }
}