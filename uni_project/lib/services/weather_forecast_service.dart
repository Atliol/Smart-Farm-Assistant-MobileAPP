import '../models/weather_forecast_model.dart';

class WeatherService {
  Future<List<WeatherForecastModel>> getFourDaysForecast() async {
    await Future.delayed(const Duration(milliseconds: 400)); // Mock API delay

    // ၄ ရက်စာ မိုးလေဝသ နမူနာ Data
    return [
      WeatherForecastModel(
        date: 'ဇူလိုင် ၂၃',
        dayName: 'ကြာသပတေး',
        condition: 'နေရာကွက်ကျား မိုးထစ်ချုန်းရွာမည်',
        iconCode: 'thunder',
        maxTemp: 32,
        minTemp: 25,
        humidity: 82,
        rainChance: 75.0,
        windSpeed: '၁၂ ကီလိုမီတာ/နာရီ',
      ),
      WeatherForecastModel(
        date: 'ဇူလိုင် ၂၄',
        dayName: 'သောကြာ',
        condition: 'မိုးသည်းထန်စွာ ရွာသွန်းနိုင်သည်',
        iconCode: 'heavy_rain',
        maxTemp: 29,
        minTemp: 24,
        humidity: 90,
        rainChance: 90.0,
        windSpeed: '၁၅ ကီလိုမီတာ/နာရီ',
      ),
      WeatherForecastModel(
        date: 'ဇူလိုင် ၂၅',
        dayName: 'စနေ',
        condition: 'မိုးအသင့်အတင့် ရွာမည်',
        iconCode: 'rain',
        maxTemp: 31,
        minTemp: 25,
        humidity: 78,
        rainChance: 60.0,
        windSpeed: '၈ ကီလိုမီတာ/နာရီ',
      ),
      WeatherForecastModel(
        date: 'ဇူလိုင် ၂၆',
        dayName: 'တနင်္ဂနွေ',
        condition: 'တိမ်အသင့်အတင့် ဖြစ်ထွန်းမည်',
        iconCode: 'cloudy',
        maxTemp: 34,
        minTemp: 26,
        humidity: 65,
        rainChance: 20.0,
        windSpeed: '၆ ကီလိုမီတာ/နာရီ',
      ),
    ];
  }
}