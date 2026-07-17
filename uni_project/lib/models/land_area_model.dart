import 'package:google_maps_flutter/google_maps_flutter.dart';

class LandAreaModel {
  final String id;
  final String title;
  final double areaAcres;
  final double areaSqMeters;
  final double areaHectares;
  final double perimeterMeters;
  final List<LatLng> points;
  final DateTime createdAt;

  LandAreaModel({
    required this.id,
    required this.title,
    required this.areaAcres,
    required this.areaSqMeters,
    required this.areaHectares,
    required this.perimeterMeters,
    required this.points,
    required this.createdAt,
  });

  // Backend သို့ ပို့ရန် သို့မဟုတ် Hive ထဲသိမ်းရန် Map အဖြစ်ပြောင်းလဲခြင်း
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'areaAcres': areaAcres,
      'areaSqMeters': areaSqMeters,
      'areaHectares': areaHectares,
      'perimeterMeters': perimeterMeters,
      'points': points.map((p) => {'lat': p.latitude, 'lng': p.longitude}).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Backend သို့မဟုတ် Local DB မှ ပြန်ဖတ်ယူခြင်း
  factory LandAreaModel.fromJson(Map<String, dynamic> json) {
    var pointsList = json['points'] as List;
    List<LatLng> parsedPoints = pointsList.map((p) {
      final pointMap = Map<String, dynamic>.from(p as Map);
      return LatLng(pointMap['lat'] as double, pointMap['lng'] as double);
    }).toList();

    return LandAreaModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      areaAcres: (json['areaAcres'] as num? ?? 0.0).toDouble(),
      areaSqMeters: (json['areaSqMeters'] as num? ?? 0.0).toDouble(),
      areaHectares: (json['areaHectares'] as num? ?? 0.0).toDouble(),
      perimeterMeters: (json['perimeterMeters'] as num? ?? 0.0).toDouble(),
      points: parsedPoints,
      createdAt: DateTime.parse(json['createdAt'] as String? ?? DateTime.now().toIso8601String()),
    );
  }
}