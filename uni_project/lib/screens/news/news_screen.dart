import 'package:flutter/material.dart';
import '../auth/login_screen.dart';
import 'widgets/news_feed_view.dart';
import 'create_post_screen.dart';
import 'image_viewer_screen.dart';
import 'auth_prompt_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  bool _isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),


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