import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as json_latlong;
import '../../constants/app_colors.dart';
import '../../models/land_area_model.dart';

class ViewSavedMapScreen extends StatefulWidget {
  final LandAreaModel land;

  const ViewSavedMapScreen({super.key, required this.land});

  @override
  State<ViewSavedMapScreen> createState() => _ViewSavedMapScreenState();
}

class _ViewSavedMapScreenState extends State<ViewSavedMapScreen> {
  final MapController _mapController = MapController();
  bool _isSatellite = true;

  @override
  Widget build(BuildContext context) {

    final List<json_latlong.LatLng> mapPoints = widget.land.points.map((p) {
      return json_latlong.LatLng(p.latitude, p.longitude);
    }).toList();

    final json_latlong.LatLng initialCenter = mapPoints.isNotEmpty
        ? mapPoints.first
        : const json_latlong.LatLng(21.9588, 96.0891);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.land.title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // 🗺️ မြေပုံအပိုင်း
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: initialCenter,
              initialZoom: 17.0,
              maxZoom: 22.0,
              minZoom: 3.0,
              interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
            ),
            children: [
              TileLayer(
                urlTemplate: _isSatellite
                    ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
                    : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.uni_project.app',
                maxNativeZoom: 18,
              ),
              // သိမ်းဆည်းထားသော အကွက်အား ပြန်လည်ဆွဲပြခြင်း
              PolygonLayer(
                polygons: [
                  Polygon(
                    points: mapPoints,
                    borderStrokeWidth: 3,
                    borderColor: Colors.green.shade400,
                    color: Colors.white.withOpacity(0.3),
                  ),
                ],
              ),
              // အစက်ချထားသော ထောင့်စွန်း Marker များ ပြန်ပြခြင်း
              MarkerLayer(
                markers: mapPoints.map((point) {
                  return Marker(
                    point: point,
                    width: 30,
                    height: 30,
                    child: Icon(Icons.location_on, color: Colors.green.shade700, size: 28),
                  );
                }).toList(),
              ),
            ],
          ),

          // 💡 Map Type Toggle ခလုတ်
          Positioned(
            top: 16,
            left: 16,
            child: FloatingActionButton.small(
              heroTag: "view_map_type",
              backgroundColor: Colors.white,
              onPressed: () => setState(() => _isSatellite = !_isSatellite),
              child: Icon(_isSatellite ? Icons.map : Icons.satellite_alt, color: Colors.green.shade800),
            ),
          ),

          // 💡 Zoom ထိန်းချုပ်မည့် ခလုတ်များ
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: "view_zoom_in",
                  backgroundColor: Colors.white,
                  onPressed: () => _mapController.move(_mapController.camera.center, (_mapController.camera.zoom + 1).clamp(3.0, 22.0)),
                  child: Icon(Icons.add, color: Colors.green.shade800),
                ),
                const SizedBox(height: 8),
                FloatingActionButton.small(
                  heroTag: "view_zoom_out",
                  backgroundColor: Colors.white,
                  onPressed: () => _mapController.move(_mapController.camera.center, (_mapController.camera.zoom - 1).clamp(3.0, 22.0)),
                  child: Icon(Icons.remove, color: Colors.green.shade800),
                ),
              ],
            ),
          ),

          // 💡 အောက်ခြေမှ အကျယ်အဝန်း အသေးစိတ်အချက်အလက်ပြ ကတ်ပြား (UI Card)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.landscape, color: Colors.green.shade700),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.land.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                        Text(
                          "${widget.land.areaAcres.toStringAsFixed(2)} Acres",
                          style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                    const Divider(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildMiniDetail("စတုရန်းမီတာ", "${widget.land.areaSqMeters.toStringAsFixed(2)} m²"),
                        _buildMiniDetail("ဟက်တာ", "${widget.land.areaHectares.toStringAsFixed(3)} Ha"),
                        _buildMiniDetail("ပတ်လည်အလျား", "${widget.land.perimeterMeters.toStringAsFixed(1)} m"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }
}