import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FertilizerKnowledgeSection extends StatelessWidget{
  const FertilizerKnowledgeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //Title & View All
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Fertilizer Knowledge',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
            ),
            TextButton(
              onPressed: () {
                //TODO: Fertilizer View All
              },
              child: const Text('View All', style: TextStyle(color: Colors.teal)),
            ),
          ],
        ),
        const SizedBox(height: 8),

        //Fertilizer List With White Screnn
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
            children: const [
              FertilizerRow(
                title: 'Urea (46% N)',
                tag: 'Nitrogen',
                tagColor: Color(0xFFE3F2FD),
                tagTextColor: Colors.blue,
                description: 'Help in leaf growth and green color.',
                benefit: 'Promotes leaf growth',
                benefitIcon: Icons.eco,
                benefitIconColor: Colors.green,
                imagePath: 'assets/urea.png',
              ),
              Divider(height: 24),
              FertilizerRow(
                title: 'DAP (18-46-0)',
                tag: 'Phosphorus',
                tagColor: Color(0xFFFDF2E9),
                tagTextColor: Colors.orange,
                description: 'Good for root development.',
                benefit: 'Supports strong root growth',
                benefitIcon: Icons.account_tree_outlined,
                benefitIconColor: Colors.teal,
                imagePath: 'assets/dap.png',
              ),
              Divider(height: 24),
              FertilizerRow(
                title: 'Potash (MOP)',
                tag: 'Potassium',
                tagColor: Color(0xFFF3E5F5),
                tagTextColor: Colors.purple,
                description: 'Improves fruit quality and disease resistance.',
                benefit: 'Enhances fruit quality',
                benefitIcon: Icons.apple,
                benefitIconColor: Colors.red,
                imagePath: 'assets/potash.png',
              ),
              Divider(height: 24),
              FertilizerRow(
                title: 'Organic Compost',
                tag: 'Organic',
                tagColor: Color(0xFFE8F5E9),
                tagTextColor: Colors.green,
                description: 'Improves soil health and fertility.',
                benefit: 'Imporves soil fertility',
                benefitIcon: Icons.grass,
                benefitIconColor: Colors.green,
                imagePath: 'assets/organic.png',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//Each Fertilizer of UI
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

  const FertilizerRow ({
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
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //TODO: To detail page of each fertilizer
      },
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //Left fertilizer bag photo
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

            //Middle data part
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Type tag card
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
                  //Name of fertilizer
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  //Description of benefit
                  Text(
                    description,
                    style: const TextStyle(fontSize: 13, color: Colors.black54),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  //Bottom circle benefit
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
            //Right Side Arrow
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}


















