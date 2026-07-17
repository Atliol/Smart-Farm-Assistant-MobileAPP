import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import '../../constants/app_colors.dart';
import '../../models/land_area_model.dart';
import '../../services/land_api_service.dart';
import 'saved_land_screen.dart';

class AreaResultScreen extends StatefulWidget {
  final List<LatLng> points;
  final double areaSqMeters;
  final double areaAcres;
  final double areaHectares;
  final double perimeter;

  const AreaResultScreen({
    super.key,
    required this.points,
    required this.areaSqMeters,
    required this.areaAcres,
    required this.areaHectares,
    required this.perimeter,
  });

  @override
  State<AreaResultScreen> createState() => _AreaResultScreenState();
}

class _AreaResultScreenState extends State<AreaResultScreen> {
  final TextEditingController _titleController = TextEditingController();
  bool _isLoading = false;

  void _navigateToSavedLandScreen() {
    Navigator.pop(context);
  }

  void _saveLand() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("မြေကွက်အမည် ဖြည့်သွင်းပေးပါဗျာ။")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final savedLand = LandAreaModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      areaAcres: widget.areaAcres,
      areaSqMeters: widget.areaSqMeters,
      areaHectares: widget.areaHectares,
      perimeterMeters: widget.perimeter,
      points: widget.points.map((p) => gmaps.LatLng(p.latitude, p.longitude)).toList(),
      createdAt: DateTime.now(),
    );

    try {
      bool isSuccess = await LandApiService().saveLandArea(savedLand);
      if (!mounted) return;
      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("'${savedLand.title}' အား စနစ်တကျသိမ်းဆည်းပြီးပါပြီ။")),
        );
        _navigateToSavedLandScreen();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("ဆာဗာသို့ သိမ်းဆည်းရန် မအောင်မြင်ပါ။ နောက်မှ ပြန်ကြိုးစားပါ။")),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("ချိတ်ဆက်မှု အမှားအယွင်းရှိပါသည်: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Area Result", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isLoading ? null : _navigateToSavedLandScreen,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.green.shade50,
              child: Icon(Icons.landscape, size: 50, color: Colors.green.shade700),
            ),
            const SizedBox(height: 12),
            const Text("Your Land Area", style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 6),
            Text(
              "${widget.areaAcres.toStringAsFixed(2)} Acres",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.green.shade800),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildResultRow("စတုရန်းမီတာ (sqm)", "${widget.areaSqMeters.toStringAsFixed(2)} m²"),
                    const Divider(),
                    _buildResultRow("ဟက်တာ (Hectares)", "${widget.areaHectares.toStringAsFixed(3)} Hectares"),
                    const Divider(),
                    _buildResultRow("ပတ်လည်အလျား (Perimeter)", "${widget.perimeter.toStringAsFixed(2)} m"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _titleController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                labelText: "မြေကွက်အမည် သတ်မှတ်ရန်",
                hintText: "ဥပမာ - ဦးဘတင့် ခြံကွက်",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.edit_road),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isLoading ? null : _navigateToSavedLandScreen,
                    child: const Text("Back to Saved Land"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade800,
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: _isLoading ? null : _saveLand,
                    child: _isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                    )
                        : const Text("Save Land", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
      ],
    );
  }
}