import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'widgets/news_feed_view.dart';
import 'auth_prompt_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data;
          if (user != null) {
            return const NewsFeedView();
          }

          return AuthPromptScreen(
            onLoginSuccess: () {
              setState(() {});
            },
          );
        },
      ),
    );
  }
}