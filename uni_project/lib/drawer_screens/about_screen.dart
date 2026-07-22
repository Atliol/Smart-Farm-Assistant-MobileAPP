import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/app_background.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('အက်ပ်အကြောင်း', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: AppBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/app_logo.png'),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Shwe Lel Yar',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryColor),
                ),
                const SizedBox(height: 6),
                const Text('Version 1.0.0', style: TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 20),
                const Text(
                  'ရွှေလယ်ယာ အပလီကေးရှင်းသည် မြန်မာတောင်သူဦးကြီးများ၏ စိုက်ပျိုးရေး လုပ်ငန်းစဉ်များကို ခေတ်မီနည်းပညာများ အသုံးပြု၍ ပိုမိုလွယ်ကူ လျှင်မြန်စေရန် ရည်ရွယ်၍ ဖန်တီးထားခြင်း ဖြစ်ပါသည်။',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, height: 1.6, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}