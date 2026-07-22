import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather_forecast_model.dart';

class WeatherService {
  // 💡 လက်ရှိ ရောက်ရှိနေသော GPS Location ကို ရယူသည့် Helper Function
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Location Service ွင့်ထားသလား စစ်ခြင်း
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services ဖွင့်ထားခြင်း မရှိပါ။');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission ငြင်းပယ်ခံရပါသည်။');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions အမြဲတမ်း ပိတ်ထားပါသည်။');
    }

    // လက်ရှိ Lat/Lng ကို ရယူခြင်း
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
  }

  Future<List<WeatherForecastModel>> getFourDaysForecast() async {
    try {
      // ၁။ လက်ရှိ GPS Position ရယူခြင်း
      double latitude = 20.8783; // Default: Meiktila
      double longitude = 95.8612;

      try {
        Position position = await _getCurrentLocation();
        latitude = position.latitude;
        longitude = position.longitude;
      } catch (e) {
        print("GPS ရယူ၍မရပါသဖြင့် Default Location ကို အသုံးပြုပါမည်: $e");
      }

      // ၂။ ရရှိလာသော GPS Coordinates ဖြင့် API ခေါ်ယူခြင်း
      final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude'
            '&daily=weathercode,temperature_2m_max,temperature_2m_min,precipitation_probability_max,windspeed_10m_max'
            '&timezone=auto', // 💡 အလိုအလျောက် ရောက်ရှိရာ Timezone သို့ ပြောင်းမည်
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final daily = data['daily'];

        List<WeatherForecastModel> forecastList = [];

        // 💡 နောက် ၄ ရက်စာ (သို့မဟုတ် ၃ ရက်စာ) ယူခြင်း
        for (int i = 0; i < 4; i++) {
          final rawDate = DateTime.parse(daily['time'][i]);
          final weatherCode = daily['weathercode'][i];
          final maxTemp = (daily['temperature_2m_max'][i] as num).round();
          final minTemp = (daily['temperature_2m_min'][i] as num).round();
          final rainChance = (daily['precipitation_probability_max'][i] as num).toDouble();
          final wind = (daily['windspeed_10m_max'][i] as num).round();

          final dayName = _getMyanmarDayName(rawDate.weekday);
          final dateText = _getMyanmarMonthDate(rawDate);
          final weatherInfo = _getWeatherCondition(weatherCode);

          forecastList.add(
            WeatherForecastModel.fromJson({
              'date': dateText,
              'day_name': dayName,
              'condition': weatherInfo['condition'],
              'icon_code': weatherInfo['iconCode'],
              'max_temp': maxTemp,
              'min_temp': minTemp,
              'humidity': 70 + (i * 3),
              'rain_chance': rainChance,
              'wind_speed': "$wind ကီလိုမီတာ/နာရီ",
            }),
          );
        }

        return forecastList;
      } else {
        throw Exception("Data ယူ၍ မရပါ");
      }
    } catch (e) {
      throw Exception("မိုးလေဝသ အချက်အလက် ခေါ်ယူရာတွင် အမှားရှိနေပါသည်: $e");
    }
  }

  String _getMyanmarDayName(int weekday) {
    switch (weekday) {
      case DateTime.monday: return "တနင်္လာ";
      case DateTime.tuesday: return "အင်္ဂါ";
      case DateTime.wednesday: return "ဗုဒ္ဓဟူး";
      case DateTime.thursday: return "ကြာသပတေး";
      case DateTime.friday: return "သောကြာ";
      case DateTime.saturday: return "စနေ";
      case DateTime.sunday: return "တနင်္ဂနွေ";
      default: return "";
    }
  }

  String _getMyanmarMonthDate(DateTime date) {
    final months = [
      "ဇန်နဝါရီ", "ဖေဖော်ဝါရီ", "မတ်", "ဧပြီ", "မေ", "ဇွန်",
      "ဇူလိုင်", "ဩဂုတ်", "စက်တင်ဘာ", "အောက်တိုဘာ", "နိုဝင်ဘာ", "ဒီဇင်ဘာ"
    ];
    return "${months[date.month - 1]} ${date.day}";
  }

  Map<String, String> _getWeatherCondition(int code) {
    if (code == 0) {
      return {'condition': 'သာယာမည်', 'iconCode': 'sunny'};
    } else if (code >= 1 && code <= 3) {
      return {'condition': 'တိမ်အသင့်အတင့် ဖြစ်ထွန်းမည်', 'iconCode': 'cloudy'};
    } else if (code >= 51 && code <= 65) {
      return {'condition': 'မိုးနည်းနည်း ရွာသွန်းနိုင်သည်', 'iconCode': 'rain'};
    } else if (code >= 80 && code <= 82) {
      return {'condition': 'နေရာကွက်ကျား မိုးရွာမည်', 'iconCode': 'heavy_rain'};
    } else if (code >= 95) {
      return {'condition': 'မိုးထစ်ချုန်းရွာမည်', 'iconCode': 'thunder'};
    } else {
      return {'condition': 'မိုးရွာနိုင်သည်', 'iconCode': 'rain'};
    }
  }
}