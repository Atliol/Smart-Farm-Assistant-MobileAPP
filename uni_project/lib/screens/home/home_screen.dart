import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uni_project/screens/home/widgets/fertilizer_knowledge_section.dart';

import 'package:uni_project/services/network_service.dart';
import 'package:uni_project/screens/home/service/weather_service.dart';
import 'package:uni_project/screens/home/widgets/crop_overview_section.dart';
import 'package:uni_project/screens/home/widgets/disease_awareness_section.dart';
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
  final NetworkService _networkService = NetworkService();

  Map<String, dynamic>? weatherData;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadWeather();
  }

  Future<void> loadWeather() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      
      bool hasInternet = await _networkService.hasInternetConnection();
      if (!hasInternet) {
        setState(() {
          errorMessage = 'အင်တာနက် လိုင်းမရှိပါ။ ကျေးဇူးပြု၍ စစ်ဆေးပေးပါ။';
          isLoading = false;
        });
        return;
      }

      
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          errorMessage = 'Location Service ဖွင့်မထားပါ။ GPS ဖွင့်ပေးပါ။';
          isLoading = false;
        });
        return;
      }

      
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          errorMessage = 'Location Permission ငြင်းပယ်ထားပါသည်။';
          isLoading = false;
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          errorMessage = 'Location Permission ပိတ်ထားပါသည်။ Setting တွင် ခွင့်ပြုပေးပါ။';
          isLoading = false;
        });
        return;
      }

      
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final data = await _weatherService.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      
      String friendlyMessage = 'အချက်အလက်များ ရယူ၍ မရပါ။ ခဏစောင့်ပြီး အောက်သို့ ဆွဲချ (Refresh) ပြုလုပ်ပါ။';

      String errStr = e.toString().toLowerCase();
      if (errStr.contains('handshake') || errStr.contains('socket') || errStr.contains('connection')) {
        friendlyMessage = 'အင်တာနက်မရှိပါ သို့မဟုတ် လိုင်းကျနေပါသည်။';
      }

      setState(() {
        errorMessage = friendlyMessage;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: RefreshIndicator(
          onRefresh: loadWeather,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: ClampingScrollPhysics(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  if (isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (errorMessage != null)
                    _buildErrorCard()
                  else
                    WeatherCard(
                      weatherData: weatherData,
                    ),

                  const SizedBox(height: 20),

                  QuickAccessSection(
                    onTabChanged: widget.onTabChanged,
                  ),

                  const SizedBox(height: 20),

                  const CropOverviewSection(),

                  const SizedBox(height: 20),

                  const DiseaseAwarenessSection(),

                  const SizedBox(height: 20),

                  const FertilizerKnowledgeSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  
  Widget _buildErrorCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            color: Colors.orangeAccent,
            size: 36,
          ),
          const SizedBox(height: 8),
          Text(
            errorMessage ?? 'အမှားတစ်ခု ဖြစ်ပေါ်နေပါသည်။',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade800,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          InkWell(
            onTap: loadWeather,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh, color: Colors.white, size: 14),
                  SizedBox(width: 4),
                  Text(
                    'ပြန်လည်ကြိုးစားမည်',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}