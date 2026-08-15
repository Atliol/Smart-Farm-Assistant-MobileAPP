import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../measure/saved_land_screen.dart';
  import '../../calculator/calculator_screen.dart';
import '../../price/daily_price_screen.dart';
import '../../tracker/tracker_screen.dart';

class QuickAccessSection extends StatelessWidget {
  final Function(int) onTabChanged;

  const QuickAccessSection({super.key, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'တောင်သူလက်စွဲများ',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A237E)),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: QuickAccessCard(
                icon: Icons.account_balance_wallet_outlined,
                label: 'မှတ်တမ်းစနစ်',
                color: Colors.teal.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TrackerScreen(), // 💡 DailyPriceScreen သို့ သွားမည်
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: QuickAccessCard(
                icon: Icons.calculate_rounded,
                label: 'တွက်ချက်ရန်',
                color: Colors.orange.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CalculatorScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: QuickAccessCard(
                icon: Icons.square_foot,
                label: 'တိုင်းတာရန်',
                color: Colors.green.shade800,
                onTap: () {
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

            Expanded(
              child: QuickAccessCard(
                icon: Icons.monetization_on_rounded,
                label: 'သီးနှံဈေးနှုန်း',
                color: Colors.teal.shade700,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DailyPriceScreen(), // 💡 DailyPriceScreen သို့ သွားမည်
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

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
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // 💡 စာသားရှည်ပါက အစဉ်ပြေပြေ ပေါ်စေရန်
            ),
          ],
        ),
      ),
    );
  }
}