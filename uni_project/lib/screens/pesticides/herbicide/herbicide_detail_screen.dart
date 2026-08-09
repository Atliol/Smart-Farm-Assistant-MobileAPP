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
        title: const Text(
          "ပေါင်းသတ်ဆေး အသေးစိတ်",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 💡 ပုံပြတ်မသွားဘဲ အထက်အောက် အပြည့်အဝ ပေါ်စေရန် ပြင်ဆင်ထားသော Image Container Section
              Container(
                width: double.infinity,
                height: 250,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50, // ပုံနောက်ခံ ငြိမ်စေရန်
                  border: Border(
                    bottom: BorderSide(color: Colors.orange.shade100, width: 1),
                  ),
                ),
                child: ClipRRect(
                  child: Image.asset(
                    data.image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain, // 💡 ပုံပြတ်မသွားဘဲ အပြည့်ပေါ်စေရန်
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.orange.shade50,
                      child: Icon(
                        Icons.grass_rounded,
                        size: 60,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ),
              ),

              // အချက်အလက်များ ဖော်ပြသည့် အပိုင်း
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ဆေးအမည် (Title)
                    Text(
                      data.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade900,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // ဓာတုအမည်
                    Text(
                      "ဓာတုအမည် - ${data.chemicalName}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.orange.shade900,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // နှိမ်နင်းနိုင်မှု
                    Text(
                      "နှိမ်နင်းနိုင်မှု - ${data.targetWeed}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),

                    // ဆေးဝါးအာနိသင် ရှင်းလင်းချက်
                    const Text(
                      "ဆေးဝါးအာနိသင် ရှင်းလင်းချက်",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.description,
                      style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),

                    const SizedBox(height: 24),

                    // လိုက်နာဆောင်ရွက်ရမည့် အဆင့်များ
                    if (data.subSteps.isNotEmpty) ...[
                      Row(
                        children: [
                          Icon(Icons.assignment_turned_in_rounded, color: Colors.orange.shade700, size: 20),
                          const SizedBox(width: 8),
                          const Text(
                            "ဆေးဖျန်းရာတွင် လိုက်နာရန် အဆင့်ဆင့်",
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
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
                      ),
                    ],
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