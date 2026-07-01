import 'package:flutter/material.dart';
import 'auth_prompt_screen.dart';
import 'widgets/news_feed_view.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // 💡 BACKEND STATE CONNECTION:
  // အကောင့်ဝင်ထားပြီးသားလားဆိုတာကို Shared Preferences သို့မဟုတ် Auth Provider မှတစ်ဆင့် ဤနေရာတွင် စစ်ဆေးပါမည်။
  // လက်ရှိစမ်းသပ်ရန်အတွက် true (အကောင့်ဝင်ပြီး) ပေးထားပါသည်။ false ပြောင်းပါက Login UI သို့ ရောက်ပါမည်။
  bool _isLoggedIn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background Gradient ပေါ်လွင်စေရန်
      body: _isLoggedIn
          ? const NewsFeedView()
          : AuthPromptScreen(
        onLoginSuccess: () {
          setState(() {
            _isLoggedIn = true;
          });
        },
      ),
    );
  }
}