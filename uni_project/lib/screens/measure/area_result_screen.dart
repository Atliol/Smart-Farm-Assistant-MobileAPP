import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../constants/app_colors.dart';
import '../../models/land_area_model.dart';

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

  void _saveLand() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("မြေကွက်အမည် ဖြည့်သွင်းပေးပါဗျာ။")),
      );
      return;
    }

    // 💡 Backend သို့မဟုတ် Local DB သို့ ပေးပို့ရန် Model အသင့်ဖန်တီးခြင်း
    final savedLand = LandAreaModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      areaAcres: widget.areaAcres,
      areaSqMeters: widget.areaSqMeters,
      areaHectares: widget.areaHectares,
      perimeterMeters: widget.perimeter,
      points: widget.points,
      createdAt: DateTime.now(),
    );

    // TODO: ချိတ်ဆက်ရန် အသင့်ဖြစ်သော Backend API logic (HTTP POST) ကို ဤနေရာတွင် ရေးသားနိုင်ပါသည်
    // Example: await http.post(url, body: jsonEncode(savedLand.toJson()));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("'${savedLand.title}' အား စနစ်တကျသိမ်းဆည်းပြီးပါပြီ။")),
    );
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Area Result", style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // 🚜 Decorative Icon Card
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

            // Detailed Area Matrix
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

            // Input Field for Name
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "မြေကွက်အမည် သတ်မှတ်ရန်",
                hintText: "ဥပမာ - ဦးဘတင့် ခြံကွက်",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.edit_road),
              ),
            ),
            const SizedBox(height: 30),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Back to Map"),
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
                    onPressed: _saveLand,
                    child: const Text("Save Land", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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