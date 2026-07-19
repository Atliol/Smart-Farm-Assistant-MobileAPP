import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/herbicide_model.dart';
import '../../../widgets/app_background.dart';

class HerbicideDetailScreen extends StatelessWidget {
  final HerbicideModel data;

  const HerbicideDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("ပေါင်းသတ်ဆေး အသေးစိတ်လမ်းညွှန်", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                data.image,
                width: double.infinity, height: 220, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: double.infinity, height: 220, color: Colors.orange.shade50,
                  child: Icon(Icons.grass_rounded, size: 60, color: Colors.orange.shade700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.orange.shade900)),
                    const SizedBox(height: 6),
                    Text("ဓာတုအမည် - ${data.chemicalName}", style: TextStyle(fontSize: 14, color: Colors.orange.shade900, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("နှိမ်နင်းနိုင်မှု - ${data.targetWeed}", style: TextStyle(fontSize: 14, color: Colors.grey.shade800, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    const Text("ဆေးဝါးအာနိသင် ရှင်းလင်းချက်", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(data.description, style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87)),

                    const SizedBox(height: 20),
                    if (data.subSteps.isNotEmpty) ...[
                      const Text("ဆေးဖျန်းရာတွင် လိုက်နာရန် အဆင့်ဆင့်", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 12),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data.subSteps.length,
                        itemBuilder: (context, index) {
                          final step = data.subSteps[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.orange.shade100),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(step.subTitle, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.orange.shade900)),
                                const SizedBox(height: 8),
                                Text(step.subDescription, style: const TextStyle(fontSize: 13, height: 1.6, color: Colors.black87)),
                              ],
                            ),
                          );
                        },
                      )
                    ]
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}