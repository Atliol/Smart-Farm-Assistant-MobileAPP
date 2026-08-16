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

      
      String encodedData = jsonEncode(
        currentLands.map((land) => land.toJson()).toList(),
      );

      
      return await prefs.setString(_storageKey, encodedData);
    } catch (e) {
      return false;
    }
  }

  
  Future<bool> deleteLandArea(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      
      List<LandAreaModel> currentLands = await getSavedLands();

      
      currentLands.removeWhere((land) => land.id == id);

      
      String encodedData = jsonEncode(
        currentLands.map((land) => land.toJson()).toList(),
      );

      
      return await prefs.setString(_storageKey, encodedData);
    } catch (e) {
      return false;
    }
  }

  
  Future<bool> updateLandTitle(String id, String newTitle) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      
      List<LandAreaModel> currentLands = await getSavedLands();

      
      int index = currentLands.indexWhere((land) => land.id == id);

      
      if (index == -1) return false;

      
      final oldLand = currentLands[index];
      currentLands[index] = LandAreaModel(
        id: oldLand.id,
        title: newTitle, 
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