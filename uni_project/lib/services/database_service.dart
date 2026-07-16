import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/crop_model.dart';

class DatabaseService {
  static const String boxName = "crops_box";

  static Future<void> initHive() async {
    await Hive.initFlutter();
  }

  Future<List<CropModel>> getCropsData() async {
    // 💡 စိတ်ချရအောင် Box မပွင့်သေးရင် ဖွင့်ပေးမည့်စနစ်
    var box = await Hive.openBox(boxName);

    // 🔥 [အရေးကြီးဆုံး ပြင်ဆင်ချက်] စမ်းသပ်ရလွယ်ကူအောင် Box ကို အမြဲတမ်း Clear လုပ်ပြီး JSON ကနေ ပြန်ဖတ်ခိုင်းကြည့်ပါမည်
    // နောက်ပိုင်း အားလုံးအဆင်ပြေမှ box.clear() ကို ပြန်ဖြုတ်နိုင်ပါတယ်
    await box.clear();

    if (box.isEmpty) {
      try {
        // ၁။ JSON ဖိုင်ကို လှမ်းဖတ်ခြင်း
        final String response = await rootBundle.loadString('assets/data/crops_data.json');

        // ၂။ JSON Data ကို Decode လုပ်ခြင်း
        final List<dynamic> data = json.decode(response);

        // ၃။ ဒေတာတစ်ခုချင်းစီကို Hive ထဲ ထည့်ခြင်း
        for (var item in data) {
          final crop = CropModel.fromJson(item);
          await box.put(crop.id, item);
        }

        // ၄။ Disk ပေါ်သို့ အသေသိမ်းခိုင်းခြင်း
        await box.flush();

      } catch (e) {
        // 💡 တကယ်လို့ Error တက်ရင် ဘာကြောင့်လဲဆိုတာကို Debug Console မှာ မြင်ရအောင် ပရင့်ထုတ်ခိုင်းခြင်း
        print("====== HIVE JSON ERROR ======");
        print(e.toString());
        print("=============================");
      }
    }

    // Hive ထဲက ဒေတာများကို List အဖြစ် ပြန်ထုတ်ပေးခြင်း
    final List<CropModel> cropList = box.values.map((item) {
      return CropModel.fromJson(Map<String, dynamic>.from(item));
    }).toList();

    return cropList;
  }
}