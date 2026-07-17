import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/livestock_model.dart';
import '../../widgets/app_background.dart';

class LivestockDetailScreen extends StatelessWidget {
  final LivestockModel livestock;

  const LivestockDetailScreen({super.key, required this.livestock});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(livestock.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📷 Banner Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  livestock.image,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity, height: 220, color: Colors.amber.shade50,
                    child: const Icon(Icons.pets, size: 50, color: Colors.amber),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 🌟 🚜 မွေးမြူရေးဆိုင်ရာ အချက်အလက်ကတ်ပြားများ (Farm Metric Grid)
              Row(
                children: [
                  _buildFarmMetricCard(
                    context,
                    label: "မွေးမြူမှုပုံစံ",
                    value: livestock.type,
                    icon: Icons.assignment_ind,
                    color: Colors.amber.shade800,
                  ),
                  const SizedBox(width: 10),
                  _buildFarmMetricCard(
                    context,
                    label: "အစာစနစ်",
                    value: livestock.feedType,
                    icon: Icons.restaurant,
                    color: Colors.orange.shade800,
                  ),
                  const SizedBox(width: 10),
                  _buildFarmMetricCard(
                    context,
                    label: "မွေးမြူချိန်",
                    value: livestock.duration,
                    icon: Icons.hourglass_bottom_rounded,
                    color: Colors.brown.shade700,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 📝 Main Title
              Text(
                livestock.title,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
              ),
              const SizedBox(height: 10),

              // 📖 Description
              Text(
                livestock.description,
                style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // 💡 Sub steps မွေးမြူနည်းအဆင့်ဆင့်
              if (livestock.subSteps.isNotEmpty) ...[
                Text(
                  "စနစ်တကျ မွေးမြူနည်း အဆင့်ဆင့်",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                ),
                const SizedBox(height: 16),
                Column(
                  children: livestock.subSteps.map((step) {
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

  // 💡 မွေးမြူရေး အချက်အလက်ပြ ကတ်ပြားငယ်
  Widget _buildFarmMetricCard(BuildContext context, {required String label, required String value, required IconData icon, required Color color}) {
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