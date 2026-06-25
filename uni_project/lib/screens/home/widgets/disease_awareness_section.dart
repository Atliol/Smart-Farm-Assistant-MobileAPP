import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiseaseAwarenessSection extends StatelessWidget {
  const DiseaseAwarenessSection({super.key});

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
              'Disease Awareness',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
            ),
            TextButton(
              onPressed: () {
                //TODO: Disease View All
              },
              child: const Text('View All', style: TextStyle(color: Colors.teal)),
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
              const DiseaseRow(
                title: 'Rice Blast',
                description: 'Fungal disease that affects rice leaves.',
                imagePath: 'assets/rice_blast.png',
              ),
              const Divider(height: 24),
              const DiseaseRow(
                title: 'Leaf Curl',
                description: 'Common in vegetables, causes leaf curling.',
                imagePath: 'assets/leaf_curl.png',
              ),
              const Divider(height: 24),
              const DiseaseRow(
                title: 'Brown Spot',
                description: 'Affects yield if not controlled early.',
                imagePath: 'assets/brown_spot.png',
              ),
              const Divider(height: 24),
              const DiseaseRow(
                title: 'Stem Rot',
                description: 'Causes stem rot and plant wilting.',
                imagePath: 'assets/stem_rot.png',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

//To show each disease UI part
class DiseaseRow extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const DiseaseRow({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {//TODO: To disease details page
        /*Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiseaseDetailScreen(
              title: title,
              description: description,
              imagePath: imagePath,
            ),
          ),
        );*/
      },
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
                //if does not exit image
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

            //Middle, name of disease & description
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

            //Right Side Arrow Button
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}















