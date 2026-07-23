import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
              'Crop Overview',
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
              )
            ]
          ),
          child: Column(
            children: const [
              CropStatusRow(
                cropName: 'Rice',
                plantingTime: 'Best planting time: May - June',
                tip: 'Kepp field moist and control weeds',
                icon: '🌾',
              ),
              Divider(height: 24),
              CropStatusRow(
                cropName: 'Corn',
                plantingTime: 'Best planting time: June - July',
                tip: 'Ensure good drainage and sunlight',
                icon: '🌽',
              ),
              Divider(height: 24),
              CropStatusRow(
                cropName: 'Tomato',
                plantingTime: 'Best planting time: Nov - Dec',
                tip: 'Water regularly and support plants',
                icon: '🍅',
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

  const CropStatusRow({
    super.key,
    required this.cropName,
    required this.plantingTime,
    required this.tip,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(icon, style: const TextStyle(fontSize: 32)),//Icon Size
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cropName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      plantingTime,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tip,
                      style: const TextStyle(fontSize: 13, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 8),
        OutlinedButton.icon(
          onPressed: () {
            //TODO: Associated guide page
          },
          icon: Icon(Icons.menu_book, size: 16, color: Colors.green.shade700),
          label: Text(
            'Guide',
            style: TextStyle(color: Colors.green.shade700, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          style: OutlinedButton.styleFrom(
            backgroundColor: Colors.green.shade700.withOpacity(0.08),
            side: BorderSide.none,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }
}



















