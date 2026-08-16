import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post_model.dart';
import 'post_card.dart';
import '../profile_screen.dart';
import 'package:uni_project/screens/news/create_post_screen.dart';
import 'package:uni_project/screens/news/noti_screen.dart';
import 'package:uni_project/services/notification_service.dart';
import '../chat_list_screen.dart';

class NewsFeedView extends StatefulWidget {
  const NewsFeedView({super.key});

  @override
  State<NewsFeedView> createState() => _NewsFeedViewState();
}

class _NewsFeedViewState extends State<NewsFeedView> {

  // Base64 String သန့်စင်ပြီး စိတ်ချရသော MemoryImage ထုတ်ပေးရန်
  ImageProvider? _getAvatarImage(String? base64Str) {
    if (base64Str == null || base64Str.isEmpty || base64Str.startsWith('blob:')) return null;
    try {
      return MemoryImage(base64Decode(base64Str));
    } catch (e) {
      return null;
    }
  }

  // Pull to Refresh ပြုလုပ်သည့်အခါ ခေါ်ယူမည့် Function
  Future<void> _onRefresh() async {
    // UI အသစ်ပြန်ဖြစ်စေရန် Rebuild လုပ်ပေးခြင်း
    setState(() {});
    // Refresh Indicator ပြသချိန် Smooth ဖြစ်စေရန် အနည်းငယ် စောင့်ပေးခြင်း
    await Future.delayed(const Duration(milliseconds: 600));
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
          // ချက်တင်/မက်ဆင်ဂျာ အိုင်ကွန်
          IconButton(
            icon: const Icon(Icons.chat_bubble_rounded, size: 24, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ChatListScreen()),
              );
            },
          ),

          // 🔔 Noti Icon (Badge ပါဝင်သော Stack)
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              int unreadCount = 0;
              if (snapshot.hasData) {
                unreadCount = snapshot.data!.docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  return !((data['isRead'] ?? false) as bool) &&
                      CloudNotificationService.shouldShowToUser(data, currentUserId);
                }).length;
              }

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

          // ပရိုဖိုင်ပုံစံလေး (ညာဘက်အစွန်ဆုံး)
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
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          // Post နည်းနေရင်လည်း Pull to Refresh အမြဲ အလုပ်လုပ်စေရန် ထည့်ပေးထားပါသည်
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // ၁။ Facebook စတိုင် အပေါ်ဆုံးက ပို့စ်တင်ရန်နေရာ Box
            SliverToBoxAdapter(
              child: Container(
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
                            MaterialPageRoute(builder: (context) => const CreatePostScreen()),
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
            ),

            // ၂။ ပို့စ်များအားလုံးကို Firestore Stream မှ ရယူပြီး တင်ပြပေးသည့် Slivers
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text("ပို့စ်များ မရှိသေးပါ၊၊")),
                  );
                }

                final docs = snapshot.data!.docs;

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      var post = PostModel.fromFirestore(docs[index]);
                      return PostCard(post: post);
                    },
                    childCount: docs.length,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}