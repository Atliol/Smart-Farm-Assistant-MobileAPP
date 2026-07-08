import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post_model.dart';
import 'post_card.dart';
import '../profile_screen.dart';
import 'package:uni_project/screens/news/create_post_screen.dart';
import 'package:uni_project/screens/news/noti_screen.dart'; // 💡 NotiScreen ကို Import လုပ်လိုက်ပါသည်

class NewsFeedView extends StatefulWidget {
  const NewsFeedView({super.key});

  @override
  State<NewsFeedView> createState() => _NewsFeedViewState();
}

class _NewsFeedViewState extends State<NewsFeedView> {

  // 💡 အကူ Logic: Base64 String သန့်စင်ပြီး စိတ်ချရသော MemoryImage ထုတ်ပေးရန်
  ImageProvider? _getAvatarImage(String? base64Str) {
    if (base64Str == null || base64Str.isEmpty || base64Str.startsWith('blob:')) return null;
    try {
      return MemoryImage(base64Decode(base64Str));
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Newsfeed", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // 💡 🔔 Facebook စတိုင် မဖတ်ရသေးသော Noti အရေအတွက်ပြပေးမည့် Badge ပါဝင်သော Noti Icon
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .where('receiverId', isEqualTo: currentUserId)
                .where('isRead', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              int unreadCount = snapshot.hasData ? snapshot.data!.docs.length : 0;

              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_rounded, size: 26, color: Colors.black87),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotiScreen()),
                      );
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 6,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          "$unreadCount",
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                ],
              );
            },
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen(userId: currentUserId)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance.collection('users').doc(currentUserId).snapshots(),
                builder: (context, userSnapshot) {
                  String? userBase64;
                  if (userSnapshot.hasData && userSnapshot.data!.exists) {
                    var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                    userBase64 = userData?['photoUrl'];
                  }

                  final imgProvider = _getAvatarImage(userBase64);
                  return CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: imgProvider,
                    child: imgProvider == null
                        ? const Icon(Icons.person, size: 18, color: Colors.grey)
                        : null,
                  );
                },
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Facebook စတိုင် အပေါ်ဆုံးက ပို့စ်တင်ရန်နေရာ Box
          Container(
            color: Colors.white,
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen(userId: currentUserId)),
                    );
                  },
                  // 💡 ပြင်ဆင်လိုက်သည့်နေရာ: "ဘာတွေတွေးနေလဲ" ဘေးက မိမိကိုယ်ပိုင် ပရိုဖိုင်ပုံလေး ✨
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').doc(currentUserId).snapshots(),
                    builder: (context, userSnapshot) {
                      String? userBase64;
                      if (userSnapshot.hasData && userSnapshot.data!.exists) {
                        var userData = userSnapshot.data!.data() as Map<String, dynamic>?;
                        userBase64 = userData?['photoUrl'];
                      }

                      final imgProvider = _getAvatarImage(userBase64);
                      return CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: imgProvider,
                        child: imgProvider == null
                            ? const Icon(Icons.person, color: Colors.grey, size: 22)
                            : null,
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreatePostScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey.shade50,
                      ),
                      child: Text(
                        " ဘာတွေတွေးနေလဲ။",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ပို့စ်များအားလုံးကို StreamBuilder ဖြင့် Real-time ဆွဲပြမည့်နေရာ
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("ပို့စ်များ မရှိသေးပါ၊၊"));
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var post = PostModel.fromFirestore(snapshot.data!.docs[index]);
                    return PostCard(post: post);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}