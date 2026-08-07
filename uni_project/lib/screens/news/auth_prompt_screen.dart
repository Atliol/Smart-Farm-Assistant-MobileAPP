import 'package:flutter/material.dart';
import '../auth/login_screen.dart';

class AuthPromptScreen extends StatelessWidget {
  final VoidCallback onLoginSuccess;
  const AuthPromptScreen({super.key, required this.onLoginSuccess});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Background Image with Dark Overlay
          Positioned.fill(
            child: Image.asset(
              'assets/images/watermelon_1.png', // မိမိ project ထဲမှ ပုံလမ်းကြောင်း ပြောင်းပေးပါ
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.45), // စာသားများ ပေါ်လွင်စေရန် အမဲရောင် အုပ်ပေးခြင်း
            ),
          ),

          // 2. Main Content Layout
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                children: [
                  const Spacer(),

                  // Title: Newsfeed
                  const Text(
                    "Newsfeed",
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Subtitle Description
                  const Text(
                    "စိုက်ပျိုးရေးနှင့်မွေးမြုုရေးဆိုင်ရာအကြောင်းအရာများကိုဆွေးနွေးနိင်ရန်အတွက်အင်တာနက်ဖွင့်ပြီး Login ဝင်ရန်လိုအပ်ပါသည်",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.4,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Login Button (White Rounded Button)
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(
                              onLoginSuccess: onLoginSuccess,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF004D40),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF004D40),
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.logout_rounded,
                            color: Color(0xFF004D40),
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}