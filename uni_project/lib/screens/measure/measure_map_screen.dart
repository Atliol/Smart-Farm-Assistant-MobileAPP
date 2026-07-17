import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../constants/app_colors.dart';
import '../../services/land_calculation_service.dart';
import 'area_result_screen.dart';

class MeasureMapScreen extends StatefulWidget {
  const MeasureMapScreen({super.key});

  @override
  State<MeasureMapScreen> createState() => _MeasureMapScreenState();
}

class _MeasureMapScreenState extends State<MeasureMapScreen> {
  GoogleMapController? _mapController; // 💡 Nullable ပြောင်းလဲ၍ Safe ဖြစ်စေပါသည်
  MapType _currentMapType = MapType.satellite;
  final List<LatLng> _points = [];
  bool _isDrawing = false;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(21.9588, 96.0891),
    zoom: 15.0,
  );

  void _onMapTap(LatLng latLng) {
    if (!_isDrawing) return;
    setState(() {
      _points.add(latLng);
    });
  }

  @override
  void dispose() {
    _mapController?.dispose(); // 💡 Screen အပိတ်တွင် Controller ကို သေချာဖျက်ပေးပါသည်
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Set<Polygon> polygons = {};
    if (_points.length >= 3) {
      polygons.add(
        Polygon(
          polygonId: const PolygonId('measured_area'),
          points: _points,
          strokeWidth: 3,
          strokeColor: Colors.green.shade400,
          fillColor: Colors.white.withOpacity(0.3),
        ),
      );
    }

    Set<Marker> markers = _points.asMap().entries.map((entry) {
      return Marker(
        markerId: MarkerId('point_${entry.key}'),
        position: entry.value,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      );
    }).toSet();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Measure Land Area", style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            mapType: _currentMapType,
            onMapCreated: (controller) => _mapController = controller,
            onTap: _onMapTap,
            polygons: polygons,
            markers: markers,
            myLocationEnabled: true, // 💡 သင့်ဖုန်းရဲ့ Blue dot တည်နေရာပြရန်
            myLocationButtonEnabled: true,
          ),

          // အောက်ခြေ Button UI overlays များ (ယခင်အတိုင်း ဆက်လက်ရှိနေပါမည်...)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topRight: Radius.circular(24), topLeft: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isDrawing) ...[
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.green.shade800),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "မြေပုံပေါ်တွင် တိုင်းတာမည့်အကွက်ကို အစက်များချ၍ တိုင်းတာနိုင်ပါသည်။",
                            style: TextStyle(fontSize: 13, color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade800,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () => setState(() => _isDrawing = true),
                      child: const Text("တိုင်းတာခြင်းစတင်မည်", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ] else ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Points: ${_points.length}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Row(
                          children: [
                            TextButton.icon(
                              onPressed: () => setState(() => _points.isNotEmpty ? _points.removeLast() : null),
                              icon: const Icon(Icons.undo, color: Colors.orange),
                              label: const Text("Undo"),
                            ),
                            TextButton.icon(
                              onPressed: () => setState(() => _points.clear()),
                              icon: const Icon(Icons.delete, color: Colors.red),
                              label: const Text("Clear"),
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(0, 48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () => setState(() => _isDrawing = false),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade800,
                              minimumSize: const Size(0, 48),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _points.length < 3
                                ? null
                                : () {
                              final metrics = LandCalculationService.calculateMetrics(_points);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AreaResultScreen(
                                    points: _points,
                                    areaSqMeters: metrics['areaSqM']!,
                                    areaAcres: metrics['acres']!,
                                    areaHectares: metrics['hectares']!,
                                    perimeter: metrics['perimeter']!,
                                  ),
                                ),
                              );
                            },
                            child: const Text("Calculate Area", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    )
                  ]
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}