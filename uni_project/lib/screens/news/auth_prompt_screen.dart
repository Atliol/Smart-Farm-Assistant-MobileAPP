import 'package:flutter/material.dart';

class AuthPromptScreen extends StatelessWidget {
  final VoidCallback onLoginSuccess;

  const AuthPromptScreen({super.key, required this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_person_rounded, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              "ကြည့်ရှုရန် အကောင့်ဝင်ပါ",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "News Feed နှင့် လုပ်ဆောင်ချက်များကို အပြည့်အဝ အသုံးပြုနိုင်ရန် ကျေးဇူးပြု၍ အကောင့်ဖွင့်ပါ သို့မဟုတ် Login ဝင်ပေးပါဗျာ။",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),

            // Login Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onLoginSuccess, // စမ်းသပ်ရန် နှိပ်လိုက်ပါက တန်းပြီး Login အောင်မြင်သွားစေရန် ချိတ်ဆက်ထားသည်
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text("လော့ဂ်အင် / အကောင့်ဖွင့်ရန်", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}