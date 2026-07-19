import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/fungicide_model.dart';
import '../../../widgets/app_background.dart';

class FungicideDetailScreen extends StatelessWidget {
  final FungicideModel data;

  const FungicideDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text("ဆေးဝါးအသေးစိတ်လမ်းညွှန်ချက်", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
                  width: double.infinity, height: 220, color: Colors.teal.shade50,
                  child: Icon(Icons.healing_rounded, size: 60, color: Colors.teal.shade700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal.shade900)),
                    const SizedBox(height: 8),
                    Text("ဓာတုဗေဒအမည်: ${data.chemicalName}", style: TextStyle(fontSize: 14, color: Colors.teal.shade700, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text("သက်ရောက်မှု: ${data.targetDisease}", style: TextStyle(fontSize: 14, color: Colors.grey.shade800, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),
                    const Text("ရောဂါအကြောင်းနှင့် ဆေးဝါးအာနိသင်", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 8),
                    Text(data.description, style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87)),

                    const SizedBox(height: 24),
                    if (data.subSteps.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(Icons.assignment_turned_in_rounded, color: Colors.teal.shade700, size: 20),
                          const SizedBox(width: 8),
                          const Text("လိုက်နာဆောင်ရွက်ရမည့် နည်းလမ်းများ", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                        ],
                      ),
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
                              border: Border.all(color: Colors.teal.shade600, width: 4), // Left Accent Border
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(step.subTitle, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.teal.shade900)),
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