import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 💡 Notification ပို့ရန် အဓိကဖန်ရှင်
  static Future<void> sendNotification({
    required String receiverId, // ဘယ်သူ့ဆီ ပို့မှာလဲ (ပို့စ်ပိုင်ရှင် ID)
    required String type,       // 'post_like', 'image_like', 'post_comment', 'image_comment'
    required String postId,
    String? additionalText,     // ကွန်မန့်စာသား စသည်ဖြင့်
  }) async {
    // 💡 Local variable အဖြစ် ပြောင်းယူလိုက်ခြင်းဖြင့် Null Safety Promotion ရသွားပါမည်
    final User? currentUser = FirebaseAuth.instance.currentUser;

    // မိမိကိုယ်တိုင် လုပ်ဆောင်ချက်ဆိုလျှင် သို့မဟုတ် User Login မဝင်ထားလျှင် Noti မပို့ပါ
    if (currentUser == null || currentUser.uid == receiverId) return;

    try {
      await _db.collection('notifications').add({
        'senderId': currentUser.uid,
        'senderName': currentUser.displayName ?? "အသုံးပြုသူ",
        'receiverId': receiverId,
        'type': type,
        'postId': postId,
        'additionalText': additionalText,
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Notification Send Error: $e");
    }
  }
}