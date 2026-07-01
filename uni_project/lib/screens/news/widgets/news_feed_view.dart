import 'package:flutter/material.dart';
import '../create_post_screen.dart';
import 'post_card.dart';
import '../../../widgets/app_background.dart';

class NewsFeedView extends StatelessWidget {
  const NewsFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    // 💡 BACKEND API DUMMY DATA:
    // API မှ ကျလာမည့် Post Data Lists (နောက်ပိုင်း Model Class ဖြင့် အစားထိုးရန်)
    final List<Map<String, dynamic>> posts = [
      {
        'author': 'U Aung Kyaw',
        'location': 'Hpa-an, Kayin State',
        'timeAgo': '2h ago',
        'content': 'Just applied organic compost to my rice field. Soil looks better already!',
        'images': [
          'https://images.fotmob.com/image_resources/logo/teamlogo/8634_small.png',
          'https://images.fotmob.com/image_resources/logo/teamlogo/8634_small.png',
          'https://images.fotmob.com/image_resources/logo/teamlogo/8634_small.png',
          'https://images.fotmob.com/image_resources/logo/teamlogo/8634_small.png',
          'https://images.fotmob.com/image_resources/logo/teamlogo/8634_small.png',
          'https://images.fotmob.com/image_resources/logo/teamlogo/8634_small.png',
          'https://images.fotmob.com/image_resources/logo/teamlogo/8634_small.png'
        ],
        'likes': 128,
        'comments': 12,
      },
      {
        'author': 'Daw Ei Ei Tun',
        'location': 'Mandalay, Mandalay Region',
        'timeAgo': '5h ago',
        'content': 'Tomato harvest is 🥳 this season. Good yield with proper care!',
        'images': [
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea',
          'https://images.unsplash.com/photo-1582284540020-8acdf03844e4',
          'https://images.unsplash.com/photo-1592924357228-91a4daadcfea',
          'https://images.unsplash.com/photo-1582284540020-8acdf03844e4'
        ],
        'likes': 96,
        'comments': 8,
      }
    ];

    void navigateToCreatePost() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CreatePostScreen()),
      );
    }

    return AppBackground(
      child: SafeArea(
        child: Column(
            children: [
        // Top Action Bar (Search Input + Post Button)
        Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // Search Bar (နှိပ်ပါက Create Post သို့ သွားမည်)
            Expanded(
              child: GestureDetector(
                onTap: navigateToCreatePost,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: const [
                      SizedBox(width: 10),
                      Text(
                        "What's on your mind?",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Post Button
            ElevatedButton.icon(
              onPressed: navigateToCreatePost,
              icon: const Icon(Icons.add_circle_outline, size: 18, color: Colors.white),
              label: const Text("Post", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00796B), // App Primary Theme Color
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),

    // News Feed Posts List
              Expanded(
                child: ListView.builder(
                  itemCount: posts.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    return PostCard(postData: posts[index]);
                  },
                ),
              ),
            ],
        ),
      ),
    );
  }
}