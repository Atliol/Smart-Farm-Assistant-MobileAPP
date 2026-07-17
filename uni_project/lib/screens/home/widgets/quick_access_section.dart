import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../measure/saved_land_screen.dart';

class QuickAccessSection extends StatelessWidget {
  final Function(int) onTabChanged;

  const QuickAccessSection({super.key, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Access',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 🟢 Measure (နှိပ်လိုက်လျှင် SavedLandScreen သို့ တိုက်ရိုက်သွားမည်)
            Expanded(
              child: QuickAccessCard(
                icon: Icons.square_foot,
                label: 'Measure',
                color: Colors.green.shade800,
                onTap: () {
                  // 💡 Navigator ကိုသုံးပြီး SavedLandScreen ဆီ တိုက်ရိုက် Push လုပ်ပါသည်
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SavedLandScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),

            // AI Assistant
            Expanded(
              child: QuickAccessCard(
                icon: Icons.psychology,
                label: 'AI Assistant',
                color: Colors.cyan.shade700,
                onTap: () {
                  onTabChanged(2); // ယခင် Index အတိုင်း ပြန်ထားနိုင်ပါသည်
                },
              ),
            ),
            const SizedBox(width: 10),

            // Pesticides
            Expanded(
              child: QuickAccessCard(
                icon: Icons.science,
                label: 'Pesticides',
                color: Colors.orange.shade700,
                onTap: () {
                  onTabChanged(3); // ယခင် Index အတိုင်း ပြန်ထားနိုင်ပါသည်
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}

// QuickAccessCard Widget ကို quick_access_section.dart ဖိုင်အောက်ခြေမှာ ထည့်ပေးထားပါ
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
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}