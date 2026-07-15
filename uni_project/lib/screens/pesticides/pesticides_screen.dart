import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_background.dart';
// 💡 မိမိဆောက်ထားမည့် Sub UI Screen ဖိုင်များကို ဤနေရာတွင် Import လုပ်ပါ
// import 'sub_screens/insecticide_screen.dart';
// import 'sub_screens/fungicide_screen.dart';
// import 'sub_screens/herbicide_screen.dart';
// import 'sub_screens/fertilizer_screen.dart';

class PesticidesScreen extends StatelessWidget {
  const PesticidesScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // 💡 တောင်းဆိုထားသည့်အတိုင်း categories list ထဲတွင် သွားရမည့် Sub UI ဖိုင်များကို တစ်ခါတည်း သတ်မှတ်ခြင်း
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'ပိုးသတ်ဆေး',
        'subtitle': 'ပိုးမွှားနှင့် ဖျက်ဆီးတတ်သော အင်းဆက်များ ကာကွယ်ရန်',
        'icon': Icons.bug_report_rounded,
        'color': const Color(0xFFFFEBEE),
        'iconColor': Colors.red.shade700,
        // 💡 နှိပ်လျှင် သွားရမည့် ပိုးသတ်ဆေးသီးသန့် Sub UI Widget
        'targetScreen': const InsecticideScreen(),
      },
      {
        'title': 'ရောဂါကာကွယ်ကုသဆေး',
        'subtitle': 'မှိုရောဂါ၊ ဘက်တီးရီးယားနှင့် အပင်ရောဂါများအတွက်',
        'icon': Icons.healing_rounded,
        'color': const Color(0xFFE8F8F5),
        'iconColor': Colors.teal.shade700,
        // 💡 နှိပ်လျှင် သွားရမည့် ရောဂါကာကွယ်ကုသဆေးသီးသန့် Sub UI Widget
        'targetScreen': const FungicideScreen(),
      },
      {
        'title': 'ပေါင်းသတ်ဆေး',
        'subtitle': 'စိုက်ခင်းအတွင်း မလိုလားအပ်သော ပေါင်းမြက်များ နှိမ်နင်းရန်',
        'icon': Icons.grass_rounded,
        'color': const Color(0xFFFFF3E0),
        'iconColor': Colors.orange.shade800,
        // 💡 နှိပ်လျှင် သွားရမည့် ပေါင်းသတ်ဆေးသီးသန့် Sub UI Widget
        'targetScreen': const HerbicideScreen(),
      },
      {
        'title': 'ဓာတ်မြေသြဇာ',
        'subtitle': 'အပင်ထွားကြိုင်းပြီး အထွက်နှုန်းတိုးစေမည့် အာဟာရများ',
        'icon': Icons.opacity_rounded,
        'color': const Color(0xFFE8F5E9),
        'iconColor': Colors.green.shade700,
        // 💡 နှိပ်လျှင် သွားရမည့် ဓာတ်မြေသြဇာသီးသန့် Sub UI Widget
        'targetScreen': const FertilizerScreen(),
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
                const SizedBox(height: 4),
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
                          // 💡 နှိပ်လိုက်လျှင် list ထဲတွင် သတ်မှတ်ထားသော Sub UI ဖိုင်ဆီသို့ တိုက်ရိုက် ဦးတည်သွားစေမည့် Function
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
                            padding: const EdgeInsets.all(16),
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

// 💡 အောက်ခြေက ယာယီ Dummy Screens တွေရဲ့ AppBar ထဲမှာ backgroundColor သတ်မှတ်ပေးလိုက်ပါ

class InsecticideScreen extends StatelessWidget {
  const InsecticideScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("ပိုးသတ်ဆေးများ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      backgroundColor: AppColors.primaryColor, // 💡 Background Color
      foregroundColor: Colors.white, // App Bar ပေါ်က စာသားနှင့် မျှားအရောင်ကို အမည်းရောင်ပြောင်းရန်
      elevation: 0, // App Bar အောက်က အရိပ်လိုင်းကို ဖျောက်ရန်
    ),
    body: const Center(child: Text("ပိုးသတ်ဆေး စာရင်း UI")),
  );
}

class FungicideScreen extends StatelessWidget {
  const FungicideScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("ရောဂါကာကွယ်ကုသဆေးများ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      backgroundColor: AppColors.primaryColor, // 💡 Background Color
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    body: const Center(child: Text("ရောဂါကာကွယ်ကုသဆေး စာရင်း UI")),
  );
}

class HerbicideScreen extends StatelessWidget {
  const HerbicideScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("ပေါင်းသတ်ဆေးများ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      backgroundColor: AppColors.primaryColor, // 💡 Background Color
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    body: const Center(child: Text("ပေါင်းသတ်ဆေး စာရင်း UI")),
  );
}

class FertilizerScreen extends StatelessWidget {
  const FertilizerScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("ဓာတ်မြေသြဇာများ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      backgroundColor: AppColors.primaryColor, // 💡 Background Color
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    body: const Center(child: Text("ဓာတ်မြေသြဇာ စာရင်း UI")),
  );
}