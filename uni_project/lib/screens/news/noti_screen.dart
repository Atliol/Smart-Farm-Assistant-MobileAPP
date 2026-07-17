import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotiScreen extends StatelessWidget {
  const NotiScreen({super.key});

  // 💡 Noti အမျိုးအစားအလိုက် Icon, Color နှင့် ပြသရမည့်စာသားကို RichText အတွက် Helper
  Map<String, dynamic> _getNotiDisplayDetails(String type, String senderName, String? additionalText) {
    String messageSuffix = "";
    IconData iconData = Icons.notifications_rounded;
    Color iconColor = Colors.grey;

    switch (type) {
      case 'post_like':
        messageSuffix = " က သင့်ပို့စ်ကို သဘောကျနှစ်သက်ခဲ့ပါတယ်။ 👍";
        iconData = Icons.thumb_up_rounded;
        iconColor = const Color(0xFF1877F2); // Facebook Blue
        break;
      case 'image_like':
        messageSuffix = " က သင့်ဓာတ်ပုံကို Like လုပ်ခဲ့ပါတယ်။ ❤️";
        iconData = Icons.favorite_rounded;
        iconColor = Colors.red;
        break;
      case 'post_comment':
        messageSuffix = " က သင့်ပို့စ်မှာ မှတ်ချက်ပေးခဲ့သည်- \"$additionalText\"";
        iconData = Icons.chat_bubble_rounded;
        iconColor = Colors.green;
        break;
      case 'image_comment':
        messageSuffix = " က သင့်ဓာတ်ပုံမှာ မှတ်ချက်ပေးခဲ့သည်- \"$additionalText\"";
        iconData = Icons.insert_comment_rounded;
        iconColor = Colors.teal;
        break;
      default:
        messageSuffix = " က သင့်ထံ အကြောင်းကြားစာ ပို့ခဲ့သည်။";
        iconData = Icons.notifications_rounded;
        iconColor = Colors.grey;
    }

    return {
      'messageSuffix': messageSuffix,
      'icon': iconData,
      'color': iconColor,
    };
  }

  // 💡 Firestore Timestamp ကို "Just now", "X mins ago" စသဖြင့် ပြောင်းပေးသည့် Logic
  String _convertToAgoText(dynamic ts) {
    try {
      if (ts == null) return "Just now";

      DateTime dateTime;

      // handle both Timestamp and plain DateTime stored in Firestore map
      if (ts is Timestamp) {
        dateTime = ts.toDate();
      } else if (ts is DateTime) {
        dateTime = ts;
      } else if (ts is Map) {
        final seconds = ts['_seconds'] ?? ts['seconds'];
        final nanos = ts['_nanoseconds'] ?? ts['nanoseconds'] ?? 0;
        if (seconds != null) {
          final int s = (seconds is num) ? seconds.toInt() : int.parse(seconds.toString());
          final int n = (nanos is num) ? nanos.toInt() : int.parse(nanos.toString());
          dateTime = DateTime.fromMillisecondsSinceEpoch(s * 1000 + (n ~/ 1000000));
        } else {
          return "Just now";
        }
      } else if (ts is int) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
      } else if (ts is String) {
        dateTime = DateTime.tryParse(ts) ?? DateTime.now();
      } else {
        return "Just now";
      }

      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays >= 7) {
        return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
      } else if (difference.inDays >= 1) {
        return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
      } else if (difference.inHours >= 1) {
        return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
      } else if (difference.inMinutes >= 1) {
        return "${difference.inMinutes} min${difference.inMinutes > 1 ? 's' : ''} ago";
      } else if (difference.inSeconds >= 1) {
        return "${difference.inSeconds} sec${difference.inSeconds > 1 ? 's' : ''} ago";
      } else {
        return "Just now";
      }
    } catch (e) {
      return "Just now";
    }
  }

  @override
  Widget build(BuildContext context) {
    final String currentUid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: Colors.white, // Newsfeed နဲ့ ဆင်တူအောင် အမည်းရောင်အစား အဖြူသုံးထားသည်
      appBar: AppBar(
        title: const Text(
            "Notifications",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black, letterSpacing: 0.5)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          // 💡 Noti အားလုံးကို ဖတ်ပြီးသားအဖြစ် သတ်မှတ်မည့် ခလုတ် (ဒီဇိုင်းပိုလှအောင် TextButton သုံးထားသည်)
          TextButton.icon(
            onPressed: () async {
              var snapshots = await FirebaseFirestore.instance
                  .collection('notifications')
                  .where('receiverId', isEqualTo: currentUid)
                  .where('isRead', isEqualTo: false)
                  .get();
              for (var doc in snapshots.docs) {
                doc.reference.update({'isRead': true});
              }
            },
            icon: const Icon(Icons.mark_chat_read_rounded, size: 18, color: Color(0xFF1877F2)),
            label: const Text(
                "Mark as read",
                style: TextStyle(color: Color(0xFF1877F2), fontWeight: FontWeight.bold, fontSize: 13)
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('receiverId', isEqualTo: currentUid)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notifications_none_rounded, size: 70, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("အကြောင်းကြားစာများ မရှိသေးပါ", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          var notiDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notiDocs.length,
            padding: const EdgeInsets.all(12), // Noti Item တွေ ဘေးမကပ်စေရန် Padding ထည့်သည်
            itemBuilder: (context, index) {
              var doc = notiDocs[index];
              var data = doc.data() as Map<String, dynamic>;
              bool isRead = data['isRead'] ?? false;
              String senderName = data['senderName'] ?? 'အသုံးပြုသူ';

              var details = _getNotiDisplayDetails(
                data['type'] ?? '',
                senderName,
                data['additionalText'],
              );

              return GestureDetector(
                onTap: () {
                  // နှိပ်လိုက်ရင် ဖတ်ပြီးသားအဖြစ် ပြောင်းမည်
                  doc.reference.update({'isRead': true});
                  // TODO: ဒီနေရာမှာ သက်ဆိုင်ရာ Post Screen ဆီသို့ Navigator.push ဖြင့် သွားရန် ကုဒ်ထည့်ပါ
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12), // Noti တစ်ခုချင်းစီကြားခြားရန်
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isRead ? Colors.grey.shade50 : Colors.blue.shade50.withAlpha(128), // 💡 မဖတ်ရသေးရင် အရောင်ဖျော့လေးပြမည်
                    borderRadius: BorderRadius.circular(16), // 💡 Modern Rounded UI
                    border: Border.all(color: isRead ? Colors.grey.shade200 : Colors.blue.shade100, width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 💡 Avatar Profile နှင့် အမျိုးအစား Icon
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300, width: 1)),
                            child: const CircleAvatar(
                              radius: 28,
                              backgroundColor: Colors.blueGrey,
                              child: Icon(Icons.person, color: Colors.white, size: 30),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: details['color'],
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: Icon(details['icon'], size: 14, color: Colors.white),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(width: 16),
                      // 💡 RichText ဖြင့် "နာမည်ကို အထူပြသခြင်း"
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              text: TextSpan(
                                style: TextStyle(color: Colors.black87, fontSize: 14, height: 1.3, fontWeight: isRead ? FontWeight.normal : FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: senderName, // 💡 "ဘယ်သူက" ဆိုတဲ့ နာမည်
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black), // 💡 Facebook Style Bold Name
                                  ),
                                  TextSpan(
                                    text: details['messageSuffix'], // 💡 ကျန်တဲ့စာသား (Like/Comment လုပ်ခဲ့သည် စသဖြင့်)
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _convertToAgoText(data['createdAt']), // 💡 "Just now", "5 mins ago" စသည်ဖြင့် အချိန်မှန်ပြမည်
                              style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      // 💡 မဖတ်ရသေးလျှင် အပြာရောင် Badge အစက်လေး
                      if (!isRead)
                        Container(
                          margin: const EdgeInsets.only(left: 12),
                          width: 10,
                          height: 10,
                          decoration: const BoxDecoration(color: Color(0xFF1877F2), shape: BoxShape.circle),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}