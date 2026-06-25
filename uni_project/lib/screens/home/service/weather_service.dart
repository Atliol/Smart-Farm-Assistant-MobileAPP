import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String apiKey = '8fb8375cbf17fed6233ab87c6af52244';

  static const String baseUrl =
      'https://api.openweathermap.org/data/2.5/weather';

  /// City Name နဲ့ Weather ယူမယ်
  Future<Map<String, dynamic>> getWeather(
      String city,
      ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl?q=$city&appid=$apiKey&units=metric',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load weather');
  }

  /// GPS Location နဲ့ Weather ယူမယ်
  Future<Map<String, dynamic>> getWeatherByLocation(
      double latitude,
      double longitude,
      ) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric',
      ),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    throw Exception('Failed to load weather');
  }

  /// Weather အလိုက် Online Background Image
  static String getBackgroundUrl(
      String condition,
      ) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=1200';

      case 'clouds':
        return 'https://images.unsplash.com/photo-1534088568595-a066f410bcda?w=1200';

      case 'rain':
      case 'drizzle':
        return 'https://images.unsplash.com/photo-1515694346937-94d85e41e6f0?w=1200';

      case 'thunderstorm':
        return 'https://images.unsplash.com/photo-1605727216801-e27ce1d0cc28?w=1200';

      case 'snow':
        return 'https://images.unsplash.com/photo-1517299321609-52687d1bc55a?w=1200';

      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
        return 'https://images.unsplash.com/photo-1485236715568-ddc5ee6ca227?w=1200';

      default:
        return 'https://images.unsplash.com/photo-1506744038136-46273834b3fb?w=1200';
    }
  }

  /// Weather Icon URL
  static String getWeatherIcon(
      String iconCode,
      ) {
    return 'https://openweathermap.org/img/wn/$iconCode@4x.png';
  }
}