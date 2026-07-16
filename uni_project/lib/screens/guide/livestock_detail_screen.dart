import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/livestock_model.dart'; // 💡 LivestockModel သို့ ပြောင်းလဲထားပါသည်
import '../../widgets/app_background.dart';

class LivestockDetailScreen extends StatelessWidget {
  final LivestockModel livestock; // 💡 CropModel နေရာတွင် အစားထိုးပါသည်

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
              // 📷 ပင်မ မွေးမြူရေး Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  livestock.image,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity,
                    height: 220,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 📝 ပင်မ Title (လိုအပ်ပါက Comment ပြန်ဖွင့်နိုင်ရန် အသင့်ပြင်ပေးထားပါသည်)
              Text(
                livestock.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
              ),
              const SizedBox(height: 10),

              // 📖 ပင်မ Description
              Text(
                livestock.description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
                // 💡 စာသားများ ဘယ်ညာညီလိုပါက TextAlign.justify သို့မဟုတ် သဘာဝအတိုင်းထားလိုပါက TextAlign.start သုံးနိုင်ပါသည်
                textAlign: TextAlign.start,
              ),
              const SizedBox(height: 20),

              const Divider(color: Colors.grey),
              const SizedBox(height: 10),

              // 💡 🌟 Condition အရ sub_steps ထဲမှာ Data ရှိမှသာ အောက်ပါ UI ပိုင်းကို ဆွဲမည်
              if (livestock.subSteps.isNotEmpty) ...[
                const Text(
                  "အသေးစိတ် လမ်းညွှန်ချက်များ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                ),
                const SizedBox(height: 16),

                // Sub Steps များကို ဒေတာရှိသလောက် အစီအစဉ်လိုက် Dynamic ဆွဲထုတ်ပြခြင်း
                Column(
                  children: livestock.subSteps.map((step) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0), // အဆင့်တစ်ခုချင်းစီကြား ခြားပေးရန်
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Sub Title (Bold ဖြင့်ပြမည်)
                          Text(
                            step.subTitle,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // 2. Sub Image (ပုံလမ်းကြောင်း မလွတ်မှသာ ပြသမည်)
                          if (step.subImage.isNotEmpty) ...[
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                step.subImage,
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(), // ပုံမရှိရင် ဖျောက်ထားမည်
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],

                          // 3. Sub Text / Description
                          Text(
                            step.subDescription,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.5,
                              color: Colors.grey.shade800,
                            ),
                            // 💡 စာပိုဒ်ရှည်ပါက ဘယ်ညာအညီညှိပေးရန် TextAlign.justify ကို ဆက်သုံးထားပါသည်
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
}