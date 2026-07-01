import 'package:flutter/material.dart';

import '../image_viewer_screen.dart';

class PostCard extends StatelessWidget {
  final Map<String, dynamic> postData;

  const PostCard({super.key, required this.postData});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author Header info
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postData['author'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(
                      "${postData['location']} • ${postData['timeAgo']}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Post Content text
          Text(
            postData['content'],
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 12),

          // Post Double Images Grid Layout
          _buildImageGrid(context, List<String>.from(postData['images'] ?? [])),
          const SizedBox(height: 12),

          // Bottom Feed Actions (Like, Comment, Share)
          Divider(color: Colors.grey.shade200, height: 1),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildActionButton(Icons.thumb_up_off_alt_rounded, "${postData['likes']}", () {}),
              _buildActionButton(Icons.chat_bubble_outline_rounded, "${postData['comments']}", () {}),
              _buildActionButton(Icons.share_outlined, "Share", () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey.shade700),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 13, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
    );
  }

  // 🛠️ Facebook Style Image Grid တည်ဆောက်ပေးသည့် Function အသစ်
  Widget _buildImageGrid(BuildContext context, List<String> images) {
    if (images.isEmpty) return const SizedBox.shrink();

    // ပုံတစ်ပုံတည်းရှိလျှင်
    if (images.length == 1) {
      return GestureDetector(
        onTap: () => _openImageViewer(context, images, 0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(height: 200, color: Colors.grey[200], child: const Icon(Icons.image)),
        ),
      );
    }

    // ပုံနှစ်ပုံရှိလျှင် ဘေးချင်းယှဉ်ပြမည်
    if (images.length == 2) {
      return Row(
        children: images.asMap().entries.map((entry) {
          int idx = entry.key;
          return Expanded(
            child: GestureDetector(
              onTap: () => _openImageViewer(context, images, idx),
              child: Padding(
                padding: EdgeInsets.only(left: idx == 0 ? 0 : 4, right: idx == 0 ? 4 : 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(height: 150, color: Colors.grey[200], child: const Icon(Icons.image)),
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    // ၄ ပုံနှင့်အထက်ရှိလျှင် 2x2 Grid ဖြင့်ပြပြီး စတုတ္ထပုံတွင် "+" စာသားတင်မည်
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(), // ListView အတွင်း ဖြစ်၍ Scroll ပိတ်ထားမည်
      itemCount: 4, // အများဆုံး ၄ ကွက်သာပြမည်
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.2,
      ),
      itemBuilder: (context, index) {
        // စတုတ္ထမြောက် အကွက်ဖြစ်ပြီး ပုံအရေအတွက် ၄ ပုံထက် ကျော်လွန်နေပါက
        if (index == 3 && images.length > 4) {
          int remaining = images.length - 3;
          return GestureDetector(
            onTap: () => _openImageViewer(context, images, index),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(color: Colors.grey[300], child: const Icon(Icons.image)),
                ),
                // မှောင်မှောင်လေးဖြင့် Overlay အုပ်ပြီး "+" စာသားပြခြင်း
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "+$remaining",
                      style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        // ကျန်သည့် ပုံမှန်အကွက်များ
        return GestureDetector(
          onTap: () => _openImageViewer(context, images, index),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(color: Colors.grey[200], child: const Icon(Icons.image)),
          ),
        );
      },
    );
  }

  // 💡 Fullscreen ဆီသို သွားမည့် လမ်းကြောင်း Function
  void _openImageViewer(BuildContext context, List<String> images, int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageViewerScreen(images: images, initialIndex: initialIndex),
      ),
    );
  }
}