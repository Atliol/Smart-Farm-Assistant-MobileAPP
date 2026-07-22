import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/weather_forecast_model.dart';
import '../../services/weather_forecast_service.dart';

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  final WeatherService _weatherService = WeatherService();
  late Future<List<WeatherForecastModel>> _forecastFuture;

  @override
  void initState() {
    super.initState();
    _forecastFuture = _weatherService.getFourDaysForecast();
  }

  IconData _getWeatherIcon(String code) {
    switch (code) {
      case 'thunder':
        return Icons.thunderstorm_rounded;
      case 'heavy_rain':
        return Icons.water_drop_rounded;
      case 'rain':
        return Icons.grain_rounded;
      case 'cloudy':
        return Icons.cloud_rounded;
      default:
        return Icons.wb_sunny_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F8),
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "နောက် ၄ ရက်စာ မိုးလေဝသခန့်မှန်းချက်",
          style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<WeatherForecastModel>>(
        future: _forecastFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("အချက်အလက်များ ရယူ၍မရပါ"));
          }

          final forecastList = snapshot.data ?? [];

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: forecastList.length,
            itemBuilder: (context, index) {
              final item = forecastList[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // Header (ရက်စွဲ၊ နေ့အမည် နှင့် အပူချိန်)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 💡 Wrapped in Expanded to prevent overflow when text is long
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE1F5FE),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _getWeatherIcon(item.iconCode),
                                  color: const Color(0xFF0288D1),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${item.dayName} (${item.date})",
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.condition,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Temperature ( fixed size )
                        Text(
                          "${item.maxTemp}°C / ${item.minTemp}°C",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(height: 1),
                    ),

                    // အသေးစိတ် မိုးလေဝသအချက်အလက် (မိုးရွာနိုင်ခြေ၊ စိုထိုင်းဆ၊ လေတိုက်နှုန်း)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildDetailItem(Icons.water_drop_outlined, "မိုးရွာနိုင်ခြေ", "${item.rainChance.toInt()}%"),
                        _buildDetailItem(Icons.thermostat_outlined, "စိုထိုင်းဆ", "${item.humidity}%"),
                        _buildDetailItem(Icons.air_rounded, "လေတိုက်နှုန်း", item.windSpeed),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey.shade600),
            const SizedBox(width: 4),
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }
}