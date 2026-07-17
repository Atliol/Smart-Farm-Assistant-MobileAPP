import 'package:flutter/material.dart';
import '../../models/aquaculture_model.dart';
import '../../widgets/app_background.dart';

class AquacultureDetailScreen extends StatelessWidget {
  final AquacultureModel item;

  const AquacultureDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isFreshWater = item.waterType.contains("ရေချို");

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(item.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Colors.teal.shade700,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📷 Banner Image with Soft Corners
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  item.image,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity, height: 220, color: Colors.blue.shade50,
                    child: const Icon(Icons.water, size: 50, color: Colors.teal),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🌟 🌊 ရေလုပ်ငန်းဆိုင်ရာ သော့ချက်လိုအပ်ချက်များ (Param Grid)
              Row(
                children: [
                  _buildAquaMetricCard(
                    context,
                    label: "ရေအမျိုးအစား",
                    value: item.waterType,
                    icon: Icons.waves,
                    color: isFreshWater ? Colors.cyan : Colors.teal,
                  ),
                  const SizedBox(width: 10),
                  _buildAquaMetricCard(
                    context,
                    label: "pH တန်ဖိုး",
                    value: item.phLevel,
                    icon: Icons.science,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(width: 10),
                  _buildAquaMetricCard(
                    context,
                    label: "မွေးမြူရက်",
                    value: item.duration,
                    icon: Icons.timer,
                    color: Colors.orange,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 📝 Main Title
              Text(
                item.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
              ),
              const SizedBox(height: 10),

              // 📖 Description
              Text(
                item.description,
                style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // 💡 Sub steps မွေးမြူနည်းအဆင့်ဆင့်
              if (item.subSteps.isNotEmpty) ...[
                Text(
                  "စနစ်တကျ မွေးမြူနည်း အဆင့်ဆင့်",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                ),
                const SizedBox(height: 16),
                Column(
                  children: item.subSteps.map((step) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            step.subTitle,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          if (step.subImage.isNotEmpty) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(step.subImage, width: double.infinity, height: 150, fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 8),
                          ],
                          Text(
                            step.subDescription,
                            style: TextStyle(fontSize: 14, height: 1.6, color: Colors.grey.shade800),
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // 💡 ရေလုပ်ငန်း parameter ပြသမည့် ကတ်ပြား widget အလှ
  Widget _buildAquaMetricCard(BuildContext context, {required String label, required String value, required IconData icon, required Color color}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.15), width: 1.2),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color.withOpacity(0.9)),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}