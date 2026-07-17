import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;

class LandCalculationService {
  // 💡 စတုရန်းမီတာကို ဧက (Acres) ပြောင်းရန်
  static double sqMetersToAcres(double sqMeters) {
    return sqMeters * 0.000247105;
  }

  // 💡 စတုရန်းမီတာကို ဟက်တာ (Hectares) ပြောင်းရန်
  static double sqMetersToHectares(double sqMeters) {
    return sqMeters * 0.0001;
  }

  // 💡 Point များကို တွက်ချက်ပြီး တန်ဖိုးအားလုံး ပြန်ပေးရန်
  static Map<String, double> calculateMetrics(List<LatLng> points) {
    if (points.length < 3) {
      return {'areaSqM': 0.0, 'acres': 0.0, 'hectares': 0.0, 'perimeter': 0.0};
    }

    // Convert to maps_toolkit LatLng formats
    List<mp.LatLng> mpPoints = points.map((p) => mp.LatLng(p.latitude, p.longitude)).toList();

    // 1. Calculate Area (စတုရန်းမီတာ)
    double area = mp.SphericalUtil.computeArea(mpPoints).toDouble();

    // 2. Calculate Perimeter (ပတ်လည်အကွာအဝေး မီတာ)
    double perimeter = 0.0;
    for (int i = 0; i < points.length; i++) {
      LatLng current = points[i];
      LatLng next = points[(i + 1) % points.length]; // နောက်ဆုံးမှတ်မှ ပထမမှတ်သို့ ပြန်ဆက်ရန်
      perimeter += mp.SphericalUtil.computeDistanceBetween(
        mp.LatLng(current.latitude, current.longitude),
        mp.LatLng(next.latitude, next.longitude),
      ).toDouble();
    }

    return {
      'areaSqM': area,
      'acres': sqMetersToAcres(area),
      'hectares': sqMetersToHectares(area),
      'perimeter': perimeter,
    };
  }
}