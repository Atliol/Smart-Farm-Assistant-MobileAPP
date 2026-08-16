import 'package:flutter/material.dart';
import 'package:uni_project/screens/pesticides/fertilizer/fertilizer_detail_screen.dart';

import '../../../models/fertilizer_model.dart';
import '../../../services/database_service.dart';
import '../../pesticides/fertilizer/fertilizer_list_screen.dart';

class FertilizerKnowledgeSection extends StatelessWidget {
  const FertilizerKnowledgeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ဓာတ်မြေသြဇာများ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FertilizerListScreen(),
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
            ],
          ),
          child: Column(
            children: [
              
              FertilizerRow(
                title: 'ကောမက်ဗိုက်တာကွန်ပေါင်း',
                tag: 'အမြစ်အားကောင်း',
                tagColor: const Color(0xFFE3F2FD),
                tagTextColor: Colors.blue,
                description: 'အမြစ်ဆင်း အားကောင်းစေသည်။',
                benefit: 'အထွက်နှုန်းတိုး',
                benefitIcon: Icons.eco,
                benefitIconColor: Colors.green,
                imagePath: 'assets/images/fertilizer_1.png',
                onTap: () async {
                  final dbService = DatabaseService();
                  final fertilizerList = await dbService.getFertilizerData();

                  final fertilizerItem = fertilizerList.firstWhere(
                        (element) => element.id == 'fer_001',
                    orElse: () => FertilizerModel(
                      id: 'fer_001',
                      title: 'ကောမက်ဗိုက်တာကွန်ပေါင်း',
                      image: 'assets/images/fertilizer_1.png',
                      description: 'Help in leaf growth and green color.',
                      typeName: 'Fertilizer',
                      benefits: 'Promotes leaf growth',
                      subSteps: [],
                    ),
                  );

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        
                        builder: (context) => FertilizerDetailScreen(data: fertilizerItem),
                      ),
                    );
                  }
                },
              ),
              const Divider(height: 24),

              
              FertilizerRow(
                title: 'ကောမက်ပုလဲနက်',
                tag: 'ကြာရှည်ခံ',
                tagColor: const Color(0xFFE3F2FD),
                tagTextColor: Colors.blue,
                description: 'အပင်ကြီးထွားမှုကို မြန်ဆန်စေသည်။',
                benefit: 'အာဟာရ ကြာရှည်ခံသည်',
                benefitIcon: Icons.eco,
                benefitIconColor: Colors.green,
                imagePath: 'assets/images/fertilizer_2.png',
                onTap: () async {
                  final dbService = DatabaseService();
                  final fertilizerList = await dbService.getFertilizerData();

                  final fertilizerItem = fertilizerList.firstWhere(
                        (element) => element.id == 'fer_002',
                    orElse: () => FertilizerModel(
                      id: 'fer_002',
                      title: 'ကောမက်ပုလဲနက်',
                      image: 'assets/images/fertilizer_2.png',
                      description: 'Help in leaf growth and green color.',
                      typeName: 'Fertilizer',
                      benefits: 'Promotes leaf growth',
                      subSteps: [],
                    ),
                  );

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        
                        builder: (context) => FertilizerDetailScreen(data: fertilizerItem),
                      ),
                    );
                  }
                },
              ),
              const Divider(height: 24),

              
              FertilizerRow(
                title: 'ကောမက်ပရီမို',
                tag: 'အာဟာရစုံ',
                tagColor: const Color(0xFFE3F2FD),
                tagTextColor: Colors.blue,
                description: 'အသီး/အပွင့် ဖြစ်ထွန်းစေသည်။',
                benefit: 'NPK အာဟာရဓာတ် မျှတစွာပါဝင်',
                benefitIcon: Icons.eco,
                benefitIconColor: Colors.green,
                imagePath: 'assets/images/fertilizer_10.png',
                onTap: () async {
                  final dbService = DatabaseService();
                  final fertilizerList = await dbService.getFertilizerData();

                  final fertilizerItem = fertilizerList.firstWhere(
                        (element) => element.id == 'fer_010',
                    orElse: () => FertilizerModel(
                      id: 'fer_010',
                      title: 'ကောမက်ပရီမို',
                      image: 'assets/images/fertilizer_10.png',
                      description: 'Help in leaf growth and green color.',
                      typeName: 'Fertilizer',
                      benefits: 'Promotes leaf growth',
                      subSteps: [],
                    ),
                  );

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        
                        builder: (context) => FertilizerDetailScreen(data: fertilizerItem),
                      ),
                    );
                  }
                },
              ),
              const Divider(height: 24),

              
              FertilizerRow(
                title: 'ကောမက် ဂျီ ၄၆',
                tag: 'အပင်ပွား',
                tagColor: const Color(0xFFE3F2FD),
                tagTextColor: Colors.blue,
                description: 'အပင် သန်မာထုထည် ကြီးမားစေသည်။',
                benefit: 'အပင်ပွားနှင့် အကိုင်းအခက်ထွက်ရှိ',
                benefitIcon: Icons.eco,
                benefitIconColor: Colors.green,
                imagePath: 'assets/images/fertilizer_9.png',
                onTap: () async {
                  final dbService = DatabaseService();
                  final fertilizerList = await dbService.getFertilizerData();

                  final fertilizerItem = fertilizerList.firstWhere(
                        (element) => element.id == 'fer_009',
                    orElse: () => FertilizerModel(
                      id: 'fer_009',
                      title: 'ကောမက် ဂျီ ၄၆',
                      image: 'assets/images/fertilizer_9.png',
                      description: 'Help in leaf growth and green color.',
                      typeName: 'Fertilizer',
                      benefits: 'Promotes leaf growth',
                      subSteps: [],
                    ),
                  );

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FertilizerDetailScreen(data: fertilizerItem),
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


class FertilizerRow extends StatelessWidget {
  final String title;
  final String tag;
  final Color tagColor;
  final Color tagTextColor;
  final String description;
  final String benefit;
  final IconData benefitIcon;
  final Color benefitIconColor;
  final String imagePath;
  final VoidCallback? onTap;

  const FertilizerRow({
    super.key,
    required this.title,
    required this.tag,
    required this.tagColor,
    required this.tagTextColor,
    required this.description,
    required this.benefit,
    required this.benefitIcon,
    required this.benefitIconColor,
    required this.imagePath,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                width: 75,
                height: 75,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 75,
                    height: 75,
                    color: Colors.green.withOpacity(0.1),
                    child: const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),

            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: tagColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(color: tagTextColor, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 6),
                  
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  
                  Text(
                    description,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 11,
                        backgroundColor: benefitIconColor.withOpacity(0.1),
                        child: Icon(benefitIcon, size: 13, color: benefitIconColor),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        benefit,
                        style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w500),
                      ),
                    ],
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