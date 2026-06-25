import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuickAccessSection extends StatelessWidget {
  final Function(int) onTabChanged;

  const QuickAccessSection({super.key, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quick Access', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E))),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //Guide(Bottom Navigation Index 1)
            Expanded(
              child: QuickAccessCard(
                icon: Icons.menu_book,
                label: 'Guide',
                color: Colors.green.shade700,
                onTap: () {
                  onTabChanged(1); //To Guide Page
                },
              ),
            ),
            const SizedBox(width: 10),

            //AI Assistant
            Expanded(
              child: QuickAccessCard(
                icon: Icons.psychology,
                label: 'AI Assistant',
                color: Colors.cyan.shade700,
                onTap: () {
                  onTabChanged(2);//To AI Page
                },
              ),
            ),
            const SizedBox(width: 10),

            //Pesticides
            Expanded(
              child: QuickAccessCard(
                icon: Icons.science,
                label: 'Pesticides',
                color: Colors.orange.shade700,
                onTap: () {
                  onTabChanged(3);//To Pesticides Page
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}

//QuickAccessCard Widget
class QuickAccessCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const QuickAccessCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,//May be error
            ),
          ],
        ),
      ),
    );
  }
}

















