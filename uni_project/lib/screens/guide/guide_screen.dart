import 'package:flutter/material.dart';
import 'package:uni_project/widgets/app_background.dart';
import '../../models/knowledge_model.dart';
import '../../services/database_service.dart';
import '../../models/crop_model.dart';
import '../../models/livestock_model.dart';   // 🆕 LivestockModel Import
import 'crop_list_screen.dart';
import 'knowledge_list_screen.dart';
import 'livestock_list_screen.dart';          // 🆕 LivestockListScreen Import

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        // 💡 Future.wait ကိုသုံးပြီး စိုက်ပျိုးရေးနှင့် မွေးမြူရေး ဒေတာနှစ်ခုစလုံးကို တစ်ပြိုင်နက် ဖတ်ယူခြင်း
        child: FutureBuilder<List<dynamic>>(
          future: Future.wait([
            DatabaseService().getCropsData(),
            DatabaseService().getLivestockData(),
            DatabaseService().getKnowledgeData(),
          ]),
          builder: (context, snapshot) {
            // ဒေတာအရေအတွက်ကို dynamic ယူမည် (ဒေတာမကျသေးပါက 0 ပြထားမည်)
            int cropCount = 0;
            int livestockCount = 0;
            int knowledgeCount = 0;

            if (snapshot.hasData) {
              final List<CropModel> crops = List<CropModel>.from(snapshot.data![0]);
              final List<LivestockModel> livestock = List<LivestockModel>.from(snapshot.data![1]);
              final List<KnowledgeModel> knowledge = List<KnowledgeModel>.from(snapshot.data![2]);

              cropCount = crops.length;
              livestockCount = livestock.length;
              knowledgeCount = knowledge.length;
            }

            // 💡 ဒေတာရရှိမှုအပေါ် မူတည်ပြီး ကဏ္ဍစာရင်းကို ညှိယူခြင်း
            final List<Map<String, dynamic>> categories = [
              {
                'title': 'စိုက်ပျိုးနည်းပညာ',
                'subtitle': '$cropCount Guides',
                'icon': Icons.eco_rounded,
                'color': const Color(0xFFE8F5E9),
                'iconColor': Colors.green.shade700,
              },
              {
                'title': 'မွေးမြူနည်းပညာ',
                'subtitle': '$livestockCount Guides', // 💡 🆕 Dynamic Count ပြောင်းလဲထားပါသည်
                'icon': Icons.pets_rounded,
                'color': const Color(0xFFFFF3E0),
                'iconColor': Colors.orange.shade700,
              },
              {
                'title': 'ရေလုပ်ငန်းနည်းပညာ',
                'subtitle': '42 Guides',
                'icon': Icons.water_rounded,
                'color': const Color(0xFFE1F5FE),
                'iconColor': Colors.blue.shade700,
              },
              {
                'title': 'အထွေထွေဗဟုသုတ',
                'subtitle': '$knowledgeCount Guides',
                'icon': Icons.lightbulb_rounded,
                'color': const Color(0xFFF3E5F5),
                'iconColor': Colors.purple.shade700,
              },
            ];

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Content
                    const Text(
                      "Knowledge Guides",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A237E),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "စိုက်ပျိုးမွေးမြူရေး လမ်းညွှန်ချက်များ ဖတ်ရှုပါ",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),

                    // Category Grid
                    Expanded(
                      child: GridView.builder(
                        itemCount: categories.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.95,
                        ),
                        itemBuilder: (context, index) {
                          final item = categories[index];
                          return _buildCategoryCard(
                            context,
                            title: item['title'],
                            subtitle: item['subtitle'],
                            icon: item['icon'],
                            bgColor: item['color'],
                            iconColor: item['iconColor'],
                            onTap: () {
                              // 💡 စိုက်ပျိုးနည်းပညာကို နှိပ်လိုက်လျှင်
                              if (item['title'] == 'စိုက်ပျိုးနည်းပညာ') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CropListScreen(),
                                  ),
                                );
                              }
                              // 🆕 မွေးမြူနည်းပညာကို နှိပ်လိုက်လျှင် LivestockListScreen သို့ သွားရန်
                              else if (item['title'] == 'မွေးမြူနည်းပညာ') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LivestockListScreen(),
                                  ),
                                );
                              }

                              else if (item['title'] == 'အထွေထွေဗဟုသုတ') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => KnowledgeListScreen(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // မူလ ကတ်ပြားဒီဇိုင်း Function (ပြောင်းလဲမှုမရှိပါ)
  Widget _buildCategoryCard(
      BuildContext context, {
        required String title,
        required String subtitle,
        required IconData icon,
        required Color bgColor,
        required Color iconColor,
        required VoidCallback onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 32),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    Icon(Icons.arrow_forward_rounded, size: 16, color: iconColor.withOpacity(0.7)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}