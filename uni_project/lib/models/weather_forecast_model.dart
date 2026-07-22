class WeatherForecastModel {
  final String date;          // ရက်စွဲ (ဥပမာ - ဇူလိုင် ၂၃)
  final String dayName;       // နေ့အမည် (ဥပမာ - ကြာသပတေး)
  final String condition;     // ရာသီဥတုအခြေအနေ (ဥပမာ - မိုးအသင့်အတင့်ရွာမည်)
  final String iconCode;      // Icon အမျိုးအစား
  final int maxTemp;          // အမြင့်ဆုံး အပူချိန်
  final int minTemp;          // အနိမ့်ဆုံး အပူချိန်
  final int humidity;         // စိုထိုင်းဆ %
  final double rainChance;    // မိုးရွာရန် ရာခိုင်နှုန်း %
  final String windSpeed;     // လေတိုက်နှုန်း

  WeatherForecastModel({
  required this.date,
  required this.dayName,
  required this.condition,
  required this.iconCode,
  required this.maxTemp,
  required this.minTemp,
  required this.humidity,
  required this.rainChance,
  required this.windSpeed,
  });

  factory WeatherForecastModel.fromJson(Map<String, dynamic> json) {
  return WeatherForecastModel(
  date: json['date'] as String? ?? '',
  dayName: json['day_name'] as String? ?? '',
  condition: json['condition'] as String? ?? 'သာယာမည်',
  iconCode: json['icon_code'] as String? ?? 'rain',
  maxTemp: json['max_temp'] as int? ?? 30,
  minTemp: json['min_temp'] as int? ?? 24,
  humidity: json['humidity'] as int? ?? 70,
  rainChance: (json['rain_chance'] as num?)?.toDouble() ?? 0.0,
  windSpeed: json['wind_speed'] as String? ?? '5 km/h',
  );
  }
}