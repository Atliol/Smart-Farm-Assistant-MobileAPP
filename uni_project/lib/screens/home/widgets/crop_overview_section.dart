import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/crop_model.dart';
import '../../../services/database_service.dart';
import '../../guide/crop_detail_screen.dart';
import '../../guide/crop_list_screen.dart';

class CropOverviewSection extends StatelessWidget {
  const CropOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'စိုက်ပျိုးနည်းပညာများ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            TextButton(
              onPressed: () {
                // 💡 Guide Screen ထဲက Crop List Screen သို့ သွားရန်
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CropListScreen(),
                  ),
                );
              },
              child: const Text('အားလုံး', style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ]
          ),

          child: Column(
            children: [
              CropStatusRow(
                cropName: 'စပါးစိုက်ပျိုးနည်း',
                plantingTime: 'အကောင်းဆုံး စိုက်ပျိုးချိန် - မေလ မှ ဇွန်လ',
                tip: 'စိုက်ခင်းကို ရေငွေ့ဓာတ် ထိန်းထားပါ၊ ပေါင်းမြက်များ နှိမ်နင်းပါ',
                icon: '🌾',
                onTap: () async {
                  // 💡 Database / Service ထဲမှ စပါး (Rice) အတွက် CropModel ဒေတာ ရယူခြင်း
                  final dbService = DatabaseService();
                  final cropList = await dbService.getCropsData(); // သင့် Project ထဲမှ function နာမည်

                  // 'Rice' သို့မဟုတ် 'စပါး' နဲ့ ကိုက်ညီသော CropModel ကို ရှာဖွေခြင်း
                  final riceCrop = cropList.firstWhere(
                        (element) => element.title.contains('စပါး') || element.title.contains('Rice'),
                    orElse: () => CropModel(
                      id: 'crop_001',
                      title: 'စပါးစိုက်ပျိုးနည်း',
                      image: 'assets/rice.png',
                      description: 'စပါးစိုက်ပျိုးရေးဆိုင်ရာ အသေးစိတ် လမ်းညွှန်ချက်များ...',
                      subSteps: [],
                    ),
                  );

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CropDetailScreen(crop: riceCrop), // 💡 CropModel Object ပို့ပေးခြင်း
                      ),
                    );
                  }
                },
              ),
              const Divider(height: 24),
              CropStatusRow(
                cropName: 'ပြောင်းစိုက်ပျိုးနည်း',
                plantingTime: 'အကောင်းဆုံး စိုက်ပျိုးချိန် - ဇွန်လ မှ ဇူလိုင်လ',
                tip: 'ရေမဝပ်စေရန်နှင့် နေရောင်ခြည် လုံလောက်စွာရရှိစေရန်ဆောင်ရွက်ပါ',
                icon: '🌽',
                onTap: () async {
                  // 💡 1. Database/Service မှ Crop List ကို ရယူခြင်း
                  final dbService = DatabaseService();
                  final cropList = await dbService.getCropsData();

                  // 💡 2. 'ပြောင်းဖူး' သို့မဟုတ် 'Corn' ဟု ပါဝင်သော CropModel ကို ရှာဖွေခြင်း
                  final cornCrop = cropList.firstWhere(
                        (element) => element.title.contains('ပြောင်းစိုက်ပျိုးနည်း') || element.title.contains('Corn'),
                    orElse: () => CropModel(
                      id: 'crop_005',
                      title: 'ပြောင်းစိုက်ပျိုးနည်း',
                      image: 'assets/corn.png',
                      description: 'ပြောင်းဖူးစိုက်ပျိုးရေးဆိုင်ရာ အသေးစိတ် လမ်းညွှန်ချက်များ...',
                      subSteps: [],
                    ),
                  );

                  // 💡 3. CropDetailScreen သို့ CropModel ပို့ပေးပြီး Navigate လုပ်ခြင်း
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CropDetailScreen(crop: cornCrop),
                      ),
                    );
                  }
                },
              ),
              const Divider(height: 24),
              CropStatusRow(
                cropName: 'ခရမ်းချဉ်စိုက်ပျိုးနည်း',
                plantingTime: 'အကောင်းဆုံး စိုက်ပျိုးချိန် - နိုဝင်ဘာလ မှ ဒီဇင်ဘာလ',
                tip: 'မှန်မှန် ရေလောင်းပေးပါ၊ အပင်များ ယိုင်နဲ့မသွားစေရန် ထောက်မပေးပါ',
                icon: '🍅',
                onTap: () async {
                  final dbService = DatabaseService();
                  final cropList = await dbService.getCropsData();

                  final tomatoCrop = cropList.firstWhere(
                        (element) => element.title.contains('ခရမ်းချဉ်') || element.title.contains('Tomato'),
                    orElse: () => CropModel(
                      id: 'crop_002',
                      title: 'ခရမ်းချဉ်စိုက်ပျိုးနည်း',
                      image: 'assets/tomato.png',
                      description: 'ခရမ်းချဉ်စိုက်ပျိုးရေးဆိုင်ရာ အသေးစိတ် လမ်းညွှန်ချက်များ...',
                      subSteps: [],
                    ),
                  );

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CropDetailScreen(crop: tomatoCrop),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CropStatusRow extends StatelessWidget {
  final String cropName;
  final String plantingTime;
  final String tip;
  final String icon;
  final VoidCallback? onTap;

  const CropStatusRow({
    super.key,
    required this.cropName,
    required this.plantingTime,
    required this.tip,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 32)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cropName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    plantingTime,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    tip,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}



















