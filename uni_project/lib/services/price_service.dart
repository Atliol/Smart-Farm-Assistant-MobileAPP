import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/crop_price_model.dart';

class PriceService {
  static const List<String> cities = [
    'ရန်ကုန်',
    'မန္တလေး',
  ];

  static const List<String> cropCategories = [
    'အားလုံး',
    'စပါး',
    'မတ်ပဲ',
    'ပဲစင်းငုံ',
    'ကြက်သွန်',
    'ဆား',
  ];

  static const Map<String, Map<String, String>> _fieldMapping = {
    'paddy': {
      'category': 'စပါး',
      'cropName': 'ဆန်',
      'unit': 'တန်',
    },
    'matpe': {
      'category': 'မတ်ပဲ',
      'cropName': 'မတ်ပဲ',
      'unit': 'တန်',
    },
    'pigeonPea': {
      'category': 'ပဲစင်းငုံ',
      'cropName': 'ပီဂျင်ပီ',
      'unit': 'တန်',
    },
    'onion': {
      'category': 'ကြက်သွန်',
      'cropName': 'ကြက်သွန်',
      'unit': 'ကီလို',
    },
    'salt': {
      'category': 'ဆား',
      'cropName': 'ဆား',
      'unit': 'ပိဿာ',
    },
  };

  static const Map<String, String> _cityKeyMap = {
    'ရန်ကုန်': 'yangon',
    'မန္တလေး': 'mandalay',
  };

  Future<List<CropPriceModel>> fetchDailyPrices({
    required String city,
    required String selectedCrop,
  }) async {
    final doc = await FirebaseFirestore.instance.collection('crop_prices').doc('today').get();

    if (!doc.exists) {
      return [];
    }

    final data = doc.data();
    if (data == null) {
      return [];
    }

    final cityKey = _cityKeyMap[city] ?? 'yangon';
    final cityData = data[cityKey] as Map<String, dynamic>?;
    if (cityData == null) {
      return [];
    }

    final updatedAt = cityData['updatedAt']?.toString() ?? DateTime.now().toIso8601String().split('T').first;
    final prices = <CropPriceModel>[];

    for (final entry in _fieldMapping.entries) {
      final rawValue = cityData[entry.key];
      if (rawValue == null) {
        continue;
      }

      final price = rawValue.toString().trim();
      if (price.isEmpty) {
        continue;
      }

      prices.add(CropPriceModel(
        id: '${cityKey}_${entry.key}',
        category: entry.value['category']!,
        cropName: entry.value['cropName']!,
        unit: entry.value['unit']!,
        price: price,
        city: city,
        date: updatedAt,
      ));
    }

    if (selectedCrop == 'အားလုံး' || selectedCrop.isEmpty) {
      return prices;
    }

    return prices.where((price) => price.category == selectedCrop).toList();
  }
}