import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../service/weather_service.dart';

class WeatherCard extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  const WeatherCard({
    super.key,
    required this.weatherData,
  });

  @override
  Widget build(BuildContext context) {
    final city = weatherData['name'] ?? 'Unknown';

    final temp =
    ((weatherData['main']?['temp'] ?? 0) as num)
        .round();

    final condition =
        weatherData['weather'][0]['main'] ?? 'Clear';

    final iconCode =
        weatherData['weather'][0]['icon'] ?? '01d';

    final humidity =
    weatherData['main']['humidity'].toString();

    final wind =
    weatherData['wind']['speed'].toString();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(
            WeatherService.getBackgroundUrl(
              condition,
            ),
          ),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.25),
            BlendMode.darken,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        children: [
          /// LEFT
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    city,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.location_on,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),

              const SizedBox(height: 10),

              Text(
                '$temp°C',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),

              Text(
                condition,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          /// RIGHT
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: [
              Image.network(
                WeatherService.getWeatherIcon(
                  iconCode,
                ),
                width: 70,
                height: 70,
              ),

              const SizedBox(height: 10),

              WeatherInfoTile(
                icon: Icons.water_drop,
                label: 'Humidity',
                value: '$humidity%',
              ),

              WeatherInfoTile(
                icon: Icons.air,
                label: 'Wind',
                value: '$wind m/s',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WeatherInfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const WeatherInfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label $value ',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          Icon(
            icon,
            color: Colors.white,
            size: 16,
          ),
        ],
      ),
    );
  }
}