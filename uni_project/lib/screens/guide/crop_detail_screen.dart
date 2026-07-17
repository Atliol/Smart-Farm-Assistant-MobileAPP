import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/crop_model.dart';
import '../../widgets/app_background.dart';

class CropDetailScreen extends StatelessWidget {
  final CropModel crop;

  const CropDetailScreen({super.key, required this.crop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(crop.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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
              // 📷 ပင်မ Crop Image
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  crop.image,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: double.infinity, height: 220, color: Colors.grey[300],
                    child: const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              //📝 ပင်မ Title
              Text(
                crop.title,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
              ),
              const SizedBox(height: 10),

              //📖 ပင်မ Description
              Text(
                crop.description,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.justify, // 💡 စာသားများကို ဘယ်ညာအညီညှိပေးရန်
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),

              // 💡 🌟 Condition အရ sub_steps ထဲမှာ Data ရှိမှသာ အောက်ပါ UI ပိုင်းကို ဆွဲမည်
              if (crop.subSteps.isNotEmpty) ...[
                const Text(
                  "အသေးစိတ် လမ်းညွှန်ချက်များ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                ),
                const SizedBox(height: 16),

                // Sub Steps များကို ဒေတာရှိသလောက် အစီအစဉ်လိုက် Dynamic ဆွဲထုတ်ပြခြင်း
                Column(
                  children: crop.subSteps.map((step) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 24.0), // အဆင့်တစ်ခုချင်းစီကြားခြားပေးရန်
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
                            textAlign: TextAlign.justify, // 💡 စာသားများကို ဘယ်ညာအညီညှိပေးရန်
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