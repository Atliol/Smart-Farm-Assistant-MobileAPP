import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_background.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ဆက်သွယ်ရန်', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: AppBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildContactCard(
                icon: Icons.phone,
                title: 'ဖုန်းနံပါတ်',
                subtitle: '၀၉-၁၂၃၄၅၆၇၈၉ ၊ ၀၉-၉၈၇၆၅၄၃၂၁',
              ),
              const SizedBox(height: 12),
              _buildContactCard(
                icon: Icons.email,
                title: 'အီးမေးလ်',
                subtitle: 'support@shwelelyar.com',
              ),
              const SizedBox(height: 12),
              _buildContactCard(
                icon: Icons.location_on,
                title: 'ရုံးလိပ်စာ',
                subtitle: 'အမှတ် (၁၂၃)၊ စိုက်ပျိုးရေးလမ်း၊ ရန်ကုန်မြို့။',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({required IconData icon, required String title, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryColor.withOpacity(0.1),
            child: Icon(icon, color: AppColors.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
              ],
            ),
          )
        ],
      ),
    );
  }
}