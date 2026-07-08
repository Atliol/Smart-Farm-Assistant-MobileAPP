import 'package:flutter/material.dart';
// မိမိပရောဂျက်အမည်နှင့် ဖိုဒါလမ်းကြောင်းအတိုင်း လော့ဂ်အင်စကရင်ကို import လုပ်ပေးပါ
import '../auth/login_screen.dart';

class AuthPromptScreen extends StatelessWidget {
  final VoidCallback onLoginSuccess;
  const AuthPromptScreen({super.key, required this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.lock_person_rounded, size: 70, color: Color(0xFF00796B)),
              ),
              const SizedBox(height: 24),
              const Text("ကြည့်ရှုရန် အကောင့်ဝင်ပါ", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              const Text(
                "News Feed နှင့် လုပ်ဆောင်ချက်များကို အပြည့်အဝ အသုံးပြုနိုင်ရန် ကျေးဇူးပြု၍ အကောင့်ဖွင့်ပါ သို့မဟုတ် Login ဝင်ပေးပါဗျာ။",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  // ပြင်ဆင်လိုက်သည့်နေရာ: တိုက်ရိုက် LoginScreen သို့ Navigate လုပ်ခိုင်းခြင်း
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(
                          onLoginSuccess: onLoginSuccess, // အောင်မြင်ရင် NewsScreen ဘက်ကို state လှမ်းပြောင်းခိုင်းမည်
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00796B),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text("လော့ဂ်အင် / အကောင့်ဖွင့်ရန်", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}