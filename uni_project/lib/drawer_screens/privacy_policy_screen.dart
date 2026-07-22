import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_background.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text(
          'Privacy Policy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: AppBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🛡️ Header Section
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.security_rounded,
                        size: 60,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'လုံခြုံစိတ်ချရသော ရွှေလယ်ယာ',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const Text(
                      'နောက်ဆုံးပြင်ဆင်သည့်ရက်စွဲ - ဇူလိုင် ၂၁၊ ၂၀၂၆',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 📍 Section 1: Location & Data
              _buildPolicyCard(
                icon: Icons.location_on_rounded,
                title: 'တည်နေရာနှင့် အချက်အလက်များ',
                description:
                'ကျွန်ုပ်တို့သည် စိုက်ပျိုးမြေတိုင်းတာခြင်းနှင့် မိုးလေဝသခန့်မှန်းချက်များကို တိကျစွာ ထုတ်ပြန်ပေးနိုင်ရန်အတွက်သာ သင်၏ တည်နေရာ (Location) အချက်အလက်ကို အသုံးပြုပါသည်။',
              ),

              // 📱 Section 2: Offline Storage
              _buildPolicyCard(
                icon: Icons.phonelink_lock_rounded,
                title: 'အချက်အလက်များ သိမ်းဆည်းမှု',
                description:
                'သင်တိုင်းတာထားသော မြေနေရာမှတ်တမ်းများနှင့် ကိုယ်ရေးအချက်အလက်များကို သင့်ဖုန်းအတွင်း၌သာ (Offline) သိမ်းဆည်းပေးထားပါသည်။ မည်သည့် Server ပေါ်သို့မျှ ပေးပို့ခြင်း မပြုလုပ်ပါ။',
              ),

              // 🚫 Section 3: Third-party Sharing
              _buildPolicyCard(
                icon: Icons.block_rounded,
                title: 'အချက်အလက် မျှဝေခြင်း',
                description:
                'ရွှေလယ်ယာသည် သင်၏ အချက်အလက်များကို မည်သည့် တတိယအဖွဲ့အစည်း (Third-party) ထံသို့မျှ ရောင်းချခြင်း သို့မဟုတ် မျှဝေခြင်း လုံးဝပြုလုပ်မည် မဟုတ်ပါ။',
              ),

              // ⚙️ Section 4: User Control
              _buildPolicyCard(
                icon: Icons.settings_suggest_rounded,
                title: 'ထိန်းချုပ်နိုင်မှု',
                description:
                'သင်သည် ဖုန်း၏ Settings ထဲမှနေ၍ တည်နေရာအသုံးပြုခွင့်ကို အချိန်မရွေး ပြန်လည်ပိတ်သိမ်းနိုင်ပြီး၊ App ထဲရှိ ဒေတာများကိုလည်း စိတ်ကြိုက် ဖျက်ပစ်နိုင်ပါသည်။',
              ),

              const SizedBox(height: 20),
              const Center(
                child: Text(
                  'မေးမြန်းလိုပါက contact@shwelelyar.com သို့ ဆက်သွယ်နိုင်ပါသည်။',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 💡 စနစ်တကျ Card ပုံစံဖြင့် တည်ဆောက်ထားသော Widget
  Widget _buildPolicyCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}