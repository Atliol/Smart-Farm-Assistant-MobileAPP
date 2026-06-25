import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        // 💡 App တစ်ခုလုံးအတွက် သုံးမည့် နူးညံ့သော အစိမ်းမှ အဖြူရောင်ပြေး Gradient
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFC8E6C9), // အပေါ်ဘက်: Medium Mint Green
            Color(0xFFFFFFFF), // အောက်ဘက်: Pure White
          ],
          stops: [0.0, 1], // အပေါ်ဘက် ၃၅% မှာတင် Gradient ပြေးမှုကို အဆုံးသတ်ပြီး အောက်ပိုင်းကို အဖြူသန့်သန့် ထားခြင်း
        ),
      ),
      child: child,
    );
  }
}