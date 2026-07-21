class CropPriceModel {
  final String id;
  final String category;     // စပါးအမျိုးအစားများ၊ မတ်ပဲအမျိုးအစားများ...
  final String cropName;     // ဆန်း(ဧည့်မထ ၂၅%)၊ မတ်ပဲ(အက်ဖ်အေ)...
  final String unit;         // တစ်တင်းခွဲ၊ ၁ တန်၊ ၁ ပိဿာ...
  final String price;        // စျေးနှုန်း (ဥပမာ - ၁၂၅,၀၀၀ ကျပ်)
  final String city;         // ရန်ကုန်၊ မန္တလေး...
  final String date;         // YYYY-MM-DD

  CropPriceModel({
  required this.id,
  required this.category,
  required this.cropName,
  required this.unit,
  required this.price,
  required this.city,
  required this.date,
  });

  factory CropPriceModel.fromJson(Map<String, dynamic> json) {
  return CropPriceModel(
  id: json['id'] as String? ?? '',
  category: json['category'] as String? ?? '',
  cropName: json['crop_name'] as String? ?? '',
  unit: json['unit'] as String? ?? '',
  price: json['price'] as String? ?? 'စျေးနှုန်းဖော်ပြရန်မရှိပါ',
  city: json['city'] as String? ?? '',
  date: json['date'] as String? ?? '',
  );
  }

  Map<String, dynamic> toJson() {
  return {
  'id': id,
  'category': category,
  'crop_name': cropName,
  'unit': unit,
  'price': price,
  'city': city,
  'date': date,
  };
  }
}