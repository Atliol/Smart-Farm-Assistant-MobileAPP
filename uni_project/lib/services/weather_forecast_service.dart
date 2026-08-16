import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather_forecast_model.dart';

class WeatherService {
  final String apiKey = "8fb8375cbf17fed6233ab87c6af52244";

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services ဖွင့်ထားခြင်း မရှိပါ။');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission ငြင်းပယ်ခံရပါသည်။');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions အမြဲတမ်း ပိတ်ထားပါသည်။');
    } 

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.low,
    );
  }

  Future<List<WeatherForecastModel>> getFourDaysForecast() async {
    try {
      double latitude = 20.8783;
      double longitude = 95.8612;

      try {
        Position position = await _getCurrentLocation();
        latitude = position.latitude;
        longitude = position.longitude;
      } catch (e) {
        print("GPS ရယူ၍မရပါ: $e");
      }

      final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude'
        '&appid=$apiKey&units=metric&lang=my',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['list'];

        Map<String, List<dynamic>> groupedByDay = {};

        for (var item in list) {
          String dateStr = item['dt_txt'].split(' ')[0];
          if (!groupedByDay.containsKey(dateStr)) {
            groupedByDay[dateStr] = [];
          }
          groupedByDay[dateStr]!.add(item);
        }

        List<WeatherForecastModel> forecastList = [];
        int count = 0;

        for (var entry in groupedByDay.entries) {
          if (count >= 4) break;

          final dayDataList = entry.value;
          final DateTime date = DateTime.parse(entry.key);

          double maxTemp = -100;
          double minTemp = 100;
          double maxPop = 0;
          int totalHumidity = 0;
          double maxWind = 0;
          String condition = dayDataList[0]['weather'][0]['description'];
          String iconCode = _getIconCode(dayDataList[0]['weather'][0]['main']);

          for (var item in dayDataList) {
            double tempMax = (item['main']['temp_max'] as num).toDouble();
            double tempMin = (item['main']['temp_min'] as num).toDouble();
            double pop = (item['pop'] as num).toDouble();
            int humidity = (item['main']['humidity'] as num).toInt();
            double wind = (item['wind']['speed'] as num).toDouble();

            if (tempMax > maxTemp) maxTemp = tempMax;
            if (tempMin < minTemp) minTemp = tempMin;
            if (pop > maxPop) maxPop = pop;
            if (wind > maxWind) maxWind = wind;
            totalHumidity += humidity;
          }

          int avgHumidity = (totalHumidity / dayDataList.length).round();

          forecastList.add(
            WeatherForecastModel.fromJson({
              'date': _getMyanmarMonthDate(date),
              'day_name': _getMyanmarDayName(date.weekday),
              'condition': condition,
              'icon_code': iconCode,
              'max_temp': maxTemp.round(),
              'min_temp': minTemp.round(),
              'humidity': avgHumidity,
              'rain_chance': (maxPop * 100).roundToDouble(),
              'wind_speed': "${(maxWind * 3.6).round()} ကီလိုမီတာ/နာရီ",
            }),
          );

          count++;
        }

        return forecastList;
      } else {
        throw Exception("OpenWeatherMap Data ယူ၍ မရပါ");
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

  String _getIconCode(String mainCondition) {
    switch (mainCondition.toLowerCase()) {
      case 'clear': return 'sunny';
      case 'clouds': return 'cloudy';
      case 'rain': case 'drizzle': return 'rain';
      case 'thunderstorm': return 'thunder';
      default: return 'rain';
    }
  }
}