import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:uni_project/screens/home/service/weather_service.dart';
import 'package:uni_project/screens/home/widgets/crop_overview_section.dart';
import 'package:uni_project/screens/home/widgets/disease_awareness_section.dart';
import 'package:uni_project/screens/home/widgets/fertilizer_knowledge_section.dart';
import 'package:uni_project/screens/home/widgets/quick_access_section.dart';
import 'package:uni_project/screens/home/widgets/weather_card.dart';
import 'package:uni_project/widgets/app_background.dart';

class HomeScreen extends StatefulWidget {
  final Function(int) onTabChanged;

  const HomeScreen({
    super.key,
    required this.onTabChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherService _weatherService = WeatherService();

  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    try {
      bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          errorMessage = 'Location Service is disabled';
          isLoading = false;
        });
        return;
      }

      LocationPermission permission =
      await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
        await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          errorMessage = 'Location Permission Denied';
          isLoading = false;
        });
        return;
      }

      if (permission ==
          LocationPermission.deniedForever) {
        setState(() {
          errorMessage =
          'Location Permission Permanently Denied';
          isLoading = false;
        });
        return;
      }

      Position position =
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final data =
      await _weatherService.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                if (isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  WeatherCard(
                    weatherData: weatherData,
                  ),

                const SizedBox(height: 20),

                const CropOverviewSection(),

                const SizedBox(height: 20),

                QuickAccessSection(
                  onTabChanged:
                  widget.onTabChanged,
                ),

                const SizedBox(height: 20),

                const DiseaseAwarenessSection(),

                const SizedBox(height: 20),

                const FertilizerKnowledgeSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}