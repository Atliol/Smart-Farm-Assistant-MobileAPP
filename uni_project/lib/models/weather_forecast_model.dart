class WeatherForecastModel {
  final String date;
  final String dayName;
  final String condition;
  final String iconCode;
  final int maxTemp;
  final int minTemp;
  final int humidity;
  final double rainChance;
  final String windSpeed;

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
      maxTemp: (json['max_temp'] as num?)?.round() ?? 30,
      minTemp: (json['min_temp'] as num?)?.round() ?? 24,
      humidity: (json['humidity'] as num?)?.round() ?? 70,
      rainChance: (json['rain_chance'] as num?)?.toDouble() ?? 0.0,
      windSpeed: json['wind_speed'] as String? ?? '5 km/h',
    );
  }
}