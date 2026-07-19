import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/insecticide_model.dart';
import '../../../widgets/app_background.dart';

class InsecticideDetailScreen extends StatelessWidget {
  final InsecticideModel data;

  const InsecticideDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("ပိုးသတ်ဆေး အသေးစိတ်လမ်းညွှန်", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
                  width: double.infinity, height: 220, color: Colors.red.shade50,
                  child: Icon(Icons.bug_report, size: 60, color: Colors.red.shade700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
                    const SizedBox(height: 6),
                    Text("ဓာတုအမည် - ${data.chemicalName}", style: TextStyle(fontSize: 14, color: Colors.red.shade900, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text("နှိမ်နင်းနိုင်သောပိုးမွှား - ${data.targetPest}", style: TextStyle(fontSize: 14, color: Colors.grey.shade800, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    const Text("ဆေးဝါးအကြောင်း ရှင်းလင်းချက်", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(data.description, style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87)),

                    const SizedBox(height: 20),
                    if (data.subSteps.isNotEmpty) ...[
                      const Text("အသုံးပြုပုံနှင့် သတိပြုရန် အဆင့်ဆင့်", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
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
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(step.subTitle, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red.shade800)),
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