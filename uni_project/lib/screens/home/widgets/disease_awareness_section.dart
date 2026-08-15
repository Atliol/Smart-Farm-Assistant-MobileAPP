import 'package:flutter/material.dart';

import '../../../models/knowledge_model.dart';
import '../../../services/database_service.dart';
import '../../guide/knowledge_detail_screen.dart';
import '../../guide/knowledge_list_screen.dart';
// 💡 သင့် General Knowledge List Screen ဖိုင်၏ လမ်းကြောင်းကို Import လုပ်ပေးပါ
// import '../screens/guide/general_knowledge_list_screen.dart';

class DiseaseAwarenessSection extends StatelessWidget {
  const DiseaseAwarenessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title & View All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'အပင်ရောဂါများ',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A237E),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KnowledgeListScreen(
                      initialTag: 'အပင်ရောဂါ',
                    ),
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
              ),
            ],
          ),
          child: Column(
            children: [
              DiseaseRow(
                title: 'စပါးဂုတ်ကျိုးရောဂါ',
                description: 'ရောဂါဒဏ်ခံမျိုးများ ရွေးစိုက်ပါ။',
                imagePath: 'assets/images/know_disease_12.png',
                onTap: () async {
                  final dbService = DatabaseService();
                  final knowledgeList = await dbService.getKnowledgeData();

                  // Database ထဲမှ 'Rice Blast' သို့မဟုတ် 'ဂုတ်ကျိုးရောဂါ' ဒေတာကို ရှာဖွေခြင်း
                  final diseaseItem = knowledgeList.firstWhere(
                        (element) => element.id == 'know_012',
                    orElse: () => KnowledgeModel(
                      id: 'know_012',
                      title: 'စပါးဂုတ်ကျိုးရောဂါ',
                      image: 'assets/images/know_disease_12.png',
                      description: 'ရောဂါဒဏ်ခံနိုင်သော စပါးမျိုးများကို ရွေးချယ်စိုက်ပျိုးပါ။',
                      tag: 'အပင်ရောဂါ',
                      source: 'စိုက်ပျိုးရေး',
                      readTime: '၅ မိနစ်စာဖတ်ရန်',
                      subSteps: [],
                    ),
                  );

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KnowledgeDetailScreen(article: diseaseItem),
                      ),
                    );
                  }
                },
              ),
              const Divider(height: 24),

              DiseaseRow(
                title: 'စပါးရွက်ဖုံးပုတ်ရောဂါ',
                description: 'ပိုတက်ရှ်ထည့်ပါ၊ မှိုဆေးဖျန်းပါ။',
                imagePath: 'assets/images/know_disease_14.png',
                onTap: () async {
                  final dbService = DatabaseService();
                  final knowledgeList = await dbService.getKnowledgeData();

                  final diseaseItem = knowledgeList.firstWhere(
                        (element) => element.id == 'know_014',
                    orElse: () => KnowledgeModel(
                      id: 'know_014',
                      title: 'စပါးရွက်ဖုံးပုတ်ရောဂါ',
                      image: 'assets/images/know_disease_14.png',
                      description: 'ပိုတက်ရှ်မြေသြဇာ ထည့်ပါ။ မှိုသတ်ဆေးဖျန်းပါ',
                      tag: 'အပင်ရောဂါ',
                      source: 'စိုက်ပျိုးရေး',
                      readTime: '၅ မိနစ်စာဖတ်ရန်',
                      subSteps: [],
                    ),
                  );

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KnowledgeDetailScreen(article: diseaseItem),
                      ),
                    );
                  }
                },
              ),
              const Divider(height: 24),

              DiseaseRow(
                title: 'စပါးဘက်တီးရီးယားရွက်စင်းရောဂါ',
                description: 'နိုက်ထရိုဂျင်လျှော့ပါ၊ ကော့ပါးဆေးဖျန်းပါ။',
                imagePath: 'assets/images/know_disease_15.png',
                onTap: () async {
                  final dbService = DatabaseService();
                  final knowledgeList = await dbService.getKnowledgeData();

                  final diseaseItem = knowledgeList.firstWhere(
                        (element) => element.id == 'know_015',
                    orElse: () => KnowledgeModel(
                      id: 'know_015',
                      title: 'စပါးဘက်တီးရီးယားရွက်စင်းရောဂါ',
                      image: 'assets/images/know_disease_15.png',
                      description: 'နိုက်ထရိုဂျင် လျှော့သုံးပါ။ ကော့ပါးပါသော ဆေးဖျန်းပါ။',
                      tag: 'အပင်ရောဂါ',
                      source: 'စိုက်ပျိုးရေး',
                      readTime: '၅ မိနစ်စာဖတ်ရန်',
                      subSteps: [],
                    ),
                  );

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KnowledgeDetailScreen(article: diseaseItem),
                      ),
                    );
                  }
                },
              ),
              const Divider(height: 24),

              DiseaseRow(
                title: 'စပါးဘက်တီးရီးယားရွက်ခြောက်ရောဂါ',
                description: 'နိုက်ထရိုဂျင်လျှော့ပါ၊ ဘက်တီးရီးယားဆေးဖျန်းပါ။',
                imagePath: 'assets/images/know_disease_8.png',
                onTap: () async {
                  final dbService = DatabaseService();
                  final knowledgeList = await dbService.getKnowledgeData();

                  final diseaseItem = knowledgeList.firstWhere(
                        (element) => element.id == 'know_008',
                    orElse: () => KnowledgeModel(
                      id: 'know_008',
                      title: 'စပါးဘက်တီးရီးယားရွက်ခြောက်ရောဂါ',
                      image: 'assets/images/know_disease_8.png',
                      description: 'နိုက်ထရိုဂျင် လျှော့သုံးပါ။ ကော့ပါးပါသော ဘက်တီးရီးယားသတ်ဆေး ဖျန်းပါ။',
                      tag: 'အပင်ရောဂါ',
                      source: 'စိုက်ပျိုးရေး',
                      readTime: '၅ မိနစ်စာဖတ်ရန်',
                      subSteps: [],
                    ),
                  );

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KnowledgeDetailScreen(article: diseaseItem),
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

// To show each disease UI part
class DiseaseRow extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final VoidCallback? onTap;

  const DiseaseRow({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 70,
                    height: 70,
                    color: Colors.green.withOpacity(0.1),
                    child: const Icon(Icons.eco, color: Colors.green),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}