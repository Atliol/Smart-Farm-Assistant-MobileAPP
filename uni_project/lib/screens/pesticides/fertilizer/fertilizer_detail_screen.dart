import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';
import '../../../models/fertilizer_model.dart';
import '../../../widgets/app_background.dart';

class FertilizerDetailScreen extends StatelessWidget {
  final FertilizerModel data;

  const FertilizerDetailScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          "ဓာတ်မြေသြဇာ အသေးစိတ်",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 💡 ပုံမပြတ်ဘဲ အပြည့်အဝ ပေါ်စေရန် ပြင်ဆင်ထားသော Image Container Section
              Container(
                width: double.infinity,
                height: 250,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50, // ပုံနောက်ခံ ငြိမ်စေရန်
                  border: Border(
                    bottom: BorderSide(color: Colors.green.shade100, width: 1),
                  ),
                ),
                child: ClipRRect(
                  child: Image.asset(
                    data.image,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.contain, // 💡 ပုံပြတ်မသွားဘဲ အထက်အောက်/ဘေးအပြည့်ပေါ်စေရန်
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 250,
                      color: Colors.green.shade50,
                      child: Icon(
                        Icons.opacity_rounded,
                        size: 60,
                        color: Colors.green.shade700,
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
                    // ခေါင်းစဉ် (မြေသြဇာအမည်)
                    Text(
                      data.title,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade900,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // အမျိုးအစား
                    Text(
                      "အမျိုးအစား - ${data.typeName}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // အားသာချက်
                    Text(
                      "အားသာချက် - ${data.benefits}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 12),

                    // အချက်အလက်များ
                    const Text(
                      "မြေသြဇာဆိုင်ရာ အချက်အလက်များ",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      data.description,
                      style: const TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                    ),

                    const SizedBox(height: 20),

                    // အဆင့်ဆင့် အသုံးပြုပုံများ (ရှိခဲ့ပါက)
                    if (data.subSteps.isNotEmpty) ...[
                      const Text(
                        "စနစ်တကျကျွေးရမည့် အဆင့်ဆင့်အချိန်အခါ",
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
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
                              border: Border.all(color: Colors.green.shade100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.green.withOpacity(0.03),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  step.subTitle,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  step.subDescription,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    height: 1.6,
                                    color: Colors.black87,
                                  ),
                                ),
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