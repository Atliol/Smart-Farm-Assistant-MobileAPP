import '../models/crop_price_model.dart';

class PriceService {
  static const List<String> cities = [
    'ရန်ကုန်',
    'မန္တလေး',
    'နေပြည်တော်',
    'ပဲခူး',
    'မကွေး',
    'စစ်ကိုင်း',
  ];

  static const List<String> cropCategories = [
    'အားလုံး',
    'စပါး',
    'မတ်ပဲ',
    'ပဲစင်းငုံ',
    'စားတော်ပဲ',
    'ကုလားပဲ',
    'ကြက်သွန်',
  ];

  Future<List<CropPriceModel>> fetchDailyPrices({
    required String city,
    required String selectedCrop,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300)); // API Delay Mock

    // စျေးနှုန်း ဒေတာများ ထည့်သွင်းထားသော ရန်ကုန်မြို့ Mock Data
    final List<CropPriceModel> mockData = [
      // စပါး အုပ်စု
      CropPriceModel(id: '1', category: 'စပါး', cropName: 'ဆန်း(ဧည့်မထ ၂၅%)', unit: 'တစ်တင်းခွဲ', price: '၈၅,၀၀၀ ကျပ်', city: 'ရန်ကုန်', date: '2026-07-21'),
      CropPriceModel(id: '2', category: 'စပါး', cropName: 'ဆန်း(ရက် ၉၀ သစ်...)', unit: 'တစ်တင်းခွဲ', price: '၉၂,၀၀၀ ကျပ်', city: 'ရန်ကုန်', date: '2026-07-21'),
      CropPriceModel(id: '3', category: 'စပါး', cropName: 'ဆန်း(သီးထပ်ရှယ်)', unit: 'တစ်တင်းခွဲ', price: '၉၈,၀၀၀ ကျပ်', city: 'ရန်ကုန်', date: '2026-07-21'),
      CropPriceModel(id: '4', category: 'စပါး', cropName: 'ကြားပျံရှယ်', unit: 'တစ်တင်းခွဲ', price: '၁၂၀,၀၀၀ ကျပ်', city: 'ရန်ကုန်', date: '2026-07-21'),
      CropPriceModel(id: '5', category: 'စပါး', cropName: 'ပေါ်ကျွဲ(ဖျာပုံ)', unit: 'တစ်တင်းခွဲ', price: '၁၄၅,၀၀၀ ကျပ်', city: 'ရန်ကုန်', date: '2026-07-21'),

      // မတ်ပဲ အုပ်စု
      CropPriceModel(id: '6', category: 'မတ်ပဲ', cropName: 'မတ်ပဲ(အက်ဖ်အေ...)', unit: '၁ တန်', price: '၃,၂၅၀,၀၀၀ ကျပ်', city: 'ရန်ကုန်', date: '2026-07-21'),
      CropPriceModel(id: '7', category: 'မတ်ပဲ', cropName: 'မတ်ပဲ(အက်စ်ကျူ...)', unit: '၁ တန်', price: '၃,၄၅၀,၀၀၀ ကျပ်', city: 'ရန်ကုန်', date: '2026-07-21'),

      // ပဲစင်းငုံ အုပ်စု
      CropPriceModel(id: '8', category: 'ပဲစင်းငုံ', cropName: 'ပဲစင်းငုံနီ(အာစီ) (...)', unit: '၁ တန်', price: '၄,၁၀၀,၀၀၀ ကျပ်', city: 'ရန်ကုန်', date: '2026-07-21'),

      // စားတော်ပဲ အုပ်စု
      CropPriceModel(id: '9', category: 'စားတော်ပဲ', cropName: 'စားတော်ပဲလုံး', unit: '၁ ပိဿာ', price: '၆,၅၀၀ ကျပ်', city: 'ရန်ကုန်', date: '2026-07-21'),
    ];

    var cityFiltered = mockData.where((element) => element.city == city).toList();

    if (selectedCrop == 'အားလုံး' || selectedCrop.isEmpty) {
      return cityFiltered;
    }

    return cityFiltered.where((element) => element.category == selectedCrop).toList();
  }
}