class CropPriceModel {
  final String id;
  final String category;
  final String cropName;
  final String unit;
  final String price;
  final String city;
  final String date;

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