import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_background.dart';
// 🆕 ပိုးသတ်ဆေးအတွက် သီးခြားဆောက်ထားသော List Screen အား Import လုပ်ပါ
import 'fertilizer/fertilizer_list_screen.dart';
import 'fungicide/fungicide_list_screen.dart';
import 'herbicide/herbicide_list_screen.dart';
import 'insecticide/insecticide_list_screen.dart';

class PesticidesScreen extends StatelessWidget {
  const PesticidesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // 💡 targetScreen နေရာတွင် အင်းဆက်ပိုးသတ်ဆေးအတွက် သီးခြားခွဲထုတ်ထားသော ကဏ္ဍကို ချိတ်ဆက်ပေးလိုက်ပါသည်
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'ပိုးသတ်ဆေး',
        'subtitle': 'ပိုးမွှားနှင့် ဖျက်ဆီးတတ်သော အင်းဆက်များ ကာကွယ်ရန်',
        'icon': Icons.bug_report_rounded,
        'color': const Color(0xFFFFEBEE),
        'iconColor': Colors.red.shade700,
        // 💡 ၎င်းနှင့် သက်ဆိုင်ရာ သီးခြား List Screen Widget ကို တိုက်ရိုက်ခေါ်သုံးလိုက်ပါသည်
        'targetScreen': InsecticideListScreen(),
      },
      {
        'title': 'ရောဂါကာကွယ်ကုသဆေး',
        'subtitle': 'မှိုရောဂါ၊ ဘက်တီးရီးယားနှင့် အပင်ရောဂါများအတွက်',
        'icon': Icons.healing_rounded,
        'color': const Color(0xFFE8F8F5),
        'iconColor': Colors.teal.shade700,
        'targetScreen': FungicideListScreen(),
      },
      {
        'title': 'ပေါင်းသတ်ဆေး',
        'subtitle': 'စိုက်ခင်းအတွင်း မလိုလားအပ်သော ပေါင်းမြက်များ နှိမ်နင်းရန်',
        'icon': Icons.grass_rounded,
        'color': const Color(0xFFFFF3E0),
        'iconColor': Colors.orange.shade800,
        'targetScreen': HerbicideListScreen(),
      },
      {
        'title': 'ဓာတ်မြေသြဇာ',
        'subtitle': 'အပင်ထွားကြိုင်းပြီး အထွက်နှုန်းတိုးစေမည့် အာဟာရများ',
        'icon': Icons.opacity_rounded,
        'color': const Color(0xFFE8F5E9),
        'iconColor': Colors.green.shade700,
        'targetScreen': FertilizerListScreen(),
      },
    ];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ဆေးဝါးများ",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
                ),
                const SizedBox(height: 10),
                const Text(
                  "ဆေးဝါးနှင့် ဓာတ်မြေသြဇာ အမျိုးအစားများအလိုက် ရှာဖွေပါ",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final item = categories[index];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => item['targetScreen'] as Widget,
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(28),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: item['color'],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    item['icon'],
                                    color: item['iconColor'],
                                    size: 34,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'],
                                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['subtitle'],
                                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey.shade400),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}