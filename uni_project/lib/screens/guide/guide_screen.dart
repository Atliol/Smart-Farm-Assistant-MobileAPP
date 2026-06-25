import 'package:flutter/material.dart';
import 'package:uni_project/widgets/app_background.dart';

class GuideScreen extends StatelessWidget {
  const GuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ကဏ္ဍအလိုက် Data စာရင်း
    final List<Map<String, dynamic>> categories = [
      {
        'title': 'စိုက်ပျိုးနည်းပညာ',
        'subtitle': '124 Guides',
        'icon': Icons.eco_rounded,
        'color': const Color(0xFFE8F5E9), // အစိမ်းဖျော့
        'iconColor': Colors.green.shade700,
      },
      {
        'title': 'မွေးမြူနည်းပညာ',
        'subtitle': '85 Guides',
        'icon': Icons.pets_rounded,
        'color': const Color(0xFFFFF3E0), // လိမ္မော်ဖျော့
        'iconColor': Colors.orange.shade700,
      },
      {
        'title': 'ရေလုပ်ငန်းနည်းပညာ',
        'subtitle': '42 Guides',
        'icon': Icons.water_rounded,
        'color': const Color(0xFFE1F5FE), // အပြာဖျော့
        'iconColor': Colors.blue.shade700,
      },
      {
        'title': 'အထွေထွေဗဟုသုတ',
        'subtitle': '96 Guides',
        'icon': Icons.lightbulb_rounded,
        'color': const Color(0xFFF3E5F5), // ခရမ်းဖျော့
        'iconColor': Colors.purple.shade700,
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
                // ခေါင်းစဉ်ပိုင်း
                const Text(
                  "Knowledge Guides",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A237E), // Navy Blue
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "စိုက်ပျိုးမွေးမြူရေး လမ်းညွှန်ချက်များ ဖတ်ရှုပါ",
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                const SizedBox(height: 24),

                // Category များကို Grid ပုံစံဖြင့် ပြသခြင်း
                Expanded(
                  child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // တန်းစီလျှင် ၂ ခုစီပြမည်
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.95, // Width နှင့် Height အချိုးအစား
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
                          // TODO: သက်ဆိုင်ရာ Category အသေးစိတ်ဆောင်းပါးစာရင်းသို့ သွားရန်
                        },
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

  // ကတ်ပြားတစ်ခုချင်းစီ ဆောက်သည့် Widget Function
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
              // အပေါ်ပိုင်း - Icon အဝိုင်းလေး
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 32,
                ),
              ),

              // အောက်ပိုင်း - စာသားများ
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: iconColor.withOpacity(0.7),
                      ),
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