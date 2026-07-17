import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../constants/app_colors.dart';
import '../../services/land_calculation_service.dart';
import 'area_result_screen.dart';

class MeasureMapScreen extends StatefulWidget {
  const MeasureMapScreen({super.key});

  @override
  State<MeasureMapScreen> createState() => _MeasureMapScreenState();
}

class _MeasureMapScreenState extends State<MeasureMapScreen> {
  final MapController _mapController = MapController();
  bool _isSatellite = true;
  final List<LatLng> _points = [];
  bool _isDrawing = false;
  bool _isLocating = false;

  static const LatLng _initialPosition = LatLng(21.9588, 96.0891);

  void _onMapTap(TapPosition tapPosition, LatLng latLng) {
    if (!_isDrawing) return;
    setState(() {
      _points.add(latLng);
    });
  }

  void _toggleMapType() {
    setState(() {
      _isSatellite = !_isSatellite;
    });
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    setState(() {
      _isLocating = true;
    });

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'ကျေးဇူးပြု၍ ဖုန်း/Browser ၏ GPS (Location) ကို ဖွင့်ပေးပါဗျာ။';
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location ရယူခွင့်ကို ငြင်းပယ်ထားပါသဖြင့် တည်နေရာ ရှာမရနိုင်ပါ။';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw 'Location ခွင့်ပြုချက်ကို အပြီးတိုင် ပိတ်ထားသဖြင့် ဖုန်း Setting ထဲတွင် သွားဖွင့်ပေးရပါမည်။';
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _mapController.move(
        LatLng(position.latitude, position.longitude),
        18.5, // 💡 လက်ရှိနေရာရောက်ရင် Point ချရလွယ်အောင် Zoom Level ကို ပိုမိုနီးကပ်အောင် မြှင့်ထားပါတယ်
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLocating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Polygon> polygons = [];
    if (_points.length >= 3) {
      polygons.add(
        Polygon(
          points: _points,
          borderStrokeWidth: 3,
          borderColor: Colors.green.shade400,
          color: Colors.white.withOpacity(0.3),
        ),
      );
    }

    List<Marker> markers = _points.asMap().entries.map((entry) {
      return Marker(
        point: entry.value,
        width: 40,
        height: 40,
        child: Icon(
          Icons.location_on,
          color: Colors.green.shade700,
          size: 35,
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Measure Land Area", style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialPosition,
              initialZoom: 15.0,
              maxZoom: 22.0,
              minZoom: 3.0,
              onTap: _onMapTap,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: _isSatellite
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.uni_project.app',
                maxNativeZoom: 18,
              ),
              PolygonLayer(polygons: polygons),
              MarkerLayer(markers: markers),
            ],
          ),


          Positioned(
            top: 16,
            left: 16,
            child: FloatingActionButton.small(
              heroTag: "btn_map_type",
              backgroundColor: Colors.white,
              onPressed: _toggleMapType,
              child: Icon(
                _isSatellite ? Icons.map : Icons.satellite_alt,
                color: Colors.green.shade800,
              ),
            ),
          ),


          Positioned(
            top: 72,
            left: 16,
            child: FloatingActionButton.small(
              heroTag: "btn_current_location",
              backgroundColor: Colors.white,
              onPressed: _isLocating ? null : _getCurrentLocation,
              child: _isLocating
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.green),
              )
                  : Icon(
                Icons.my_location,
                color: Colors.green.shade800,
              ),
            ),
          ),


          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: "btn_zoom_in",
                  backgroundColor: Colors.white,
                  onPressed: () {

                    _mapController.move(
                        _mapController.camera.center,
                        (_mapController.camera.zoom + 1).clamp(3.0, 22.0)
                    );
                  },
                  child: Icon(Icons.add, color: Colors.green.shade800, size: 22),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: "btn_zoom_out",
                  backgroundColor: Colors.white,
                  onPressed: () {

                    _mapController.move(
                        _mapController.camera.center,
                        (_mapController.camera.zoom - 1).clamp(3.0, 22.0)
                    );
                  },
                  child: Icon(Icons.remove, color: Colors.green.shade800, size: 22),
                ),
              ],
            ),
          ),


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
                            onPressed: () => setState(() {
                              _isDrawing = false;
                              _points.clear();
                            }),
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
                              final googleMapsPoints = _points.map((p) => gmaps.LatLng(p.latitude, p.longitude)).toList();
                              final metrics = LandCalculationService.calculateMetrics(googleMapsPoints);

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
                            child: const Text("Calculate Area", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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