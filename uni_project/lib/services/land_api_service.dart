import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/land_area_model.dart';

class LandApiService {

  static const String _storageKey = 'saved_lands_key';

  Future<List<LandAreaModel>> getSavedLands() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? landsString = prefs.getString(_storageKey);

      if (landsString == null) {
        return [];
      }

      List<dynamic> jsonList = jsonDecode(landsString);
      return jsonList.map((json) => LandAreaModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('ဒေတာများ ဖတ်ယူရာတွင် အမှားအယွင်းရှိပါသည်: $e');
    }
  }

  Future<bool> saveLandArea(LandAreaModel landData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      List<LandAreaModel> currentLands = await getSavedLands();

      currentLands.insert(0, landData);

      // Model List တစ်ခုလုံးကို Json String အဖြစ် ပြောင်းလဲခြင်း
      String encodedData = jsonEncode(
        currentLands.map((land) => land.toJson()).toList(),
      );

      // ဖုန်းထဲတွင် အပြီးတိုင် သိမ်းဆည်းလိုက်ခြင်း
      return await prefs.setString(_storageKey, encodedData);
    } catch (e) {
      return false;
    }
  }

  // 🟢 ၃။ မြေကွက်အား ဖုန်းထဲမှ ပြန်လည်ဖျက်သိမ်းရန်
  Future<bool> deleteLandArea(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // ရှိပြီးသား ဒေတာစာရင်းကို ယူ
      List<LandAreaModel> currentLands = await getSavedLands();

      // ကိုက်ညီတဲ့ ID ရှိတဲ့ မြေကွက်ကို စာရင်းထဲက ဖယ်ထုတ်
      currentLands.removeWhere((land) => land.id == id);

      // ကျန်ရှိတဲ့ စာရင်းကို ပြန်ပြီး Encoded လုပ်
      String encodedData = jsonEncode(
        currentLands.map((land) => land.toJson()).toList(),
      );

      // Update ဖြစ်သွားတဲ့ စာရင်းကို ဖုန်းထဲ ပြန်သိမ်း
      return await prefs.setString(_storageKey, encodedData);
    } catch (e) {
      return false;
    }
  }

  // 🟢 ၄။ 💡 မြေကွက်အမည်ကို ဖုန်းထဲတွင် သွားရောက်ပြင်ဆင်ရန် (ဖြည့်စွက်လိုက်သော ကုဒ်)
  Future<bool> updateLandTitle(String id, String newTitle) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // ရှိပြီးသား မြေကွက်စာရင်းအားလုံးကို ယူယူမယ်
      List<LandAreaModel> currentLands = await getSavedLands();

      // ပြင်ချင်တဲ့ ID ရှိတဲ့ မြေကွက်ရဲ့ တည်နေရာ (Index) ကို ရှာမယ်
      int index = currentLands.indexWhere((land) => land.id == id);

      // စာရင်းထဲမှာ ရှာမတွေ့ရင် လုပ်ဆောင်ချက်ကို ရပ်မယ်
      if (index == -1) return false;

      // Model ရဲ့ Fields တွေက final ဖြစ်နေရင် ပြဿနာမတက်အောင် အချက်အလက်အဟောင်းတွေကို ယူပြီး အမည်သစ်နဲ့ Model အသစ် ပြန်ဆောက်ပါတယ်
      final oldLand = currentLands[index];
      currentLands[index] = LandAreaModel(
        id: oldLand.id,
        title: newTitle, // 👈 အမည်သစ်ကို အစားထိုးလိုက်ပါတယ်
        areaAcres: oldLand.areaAcres,
        areaSqMeters: oldLand.areaSqMeters,
        areaHectares: oldLand.areaHectares,
        perimeterMeters: oldLand.perimeterMeters,
        points: oldLand.points,
        createdAt: oldLand.createdAt,
      );


      String encodedData = jsonEncode(
        currentLands.map((land) => land.toJson()).toList(),
      );


      return await prefs.setString(_storageKey, encodedData);
    } catch (e) {
      print("Update Land Title Error: $e");
      return false;
    }
  }
}