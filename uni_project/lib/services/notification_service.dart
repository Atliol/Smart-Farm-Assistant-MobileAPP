import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CloudNotificationService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// အသုံးပြုသူထံ အကြောင်းကြားစာ ပြသရန် သင့်တော်မှု ရှိ/မရှိ စစ်ဆေးသည့် ဖန်ရှင်
  static bool shouldShowToUser(Map<String, dynamic> notification, String currentUid) {
    if (currentUid.isEmpty) return false;

    final bool isAdminNotification = notification['isAdminNotification'] == true;
    final bool isBroadcast = notification['isBroadcast'] == true;
    final dynamic receiverValue = notification['receiverId'];
    final dynamic targetUserIdValue = notification['targetUserId'];
    final dynamic targetUsersValue = notification['targetUsers'];
    final dynamic receiverIdsValue = notification['receiverIds'];

    if (isAdminNotification || isBroadcast) {
      return true;
    }

    bool matchesUserId(String? userId) {
      if (userId == null || userId.trim().isEmpty) return false;
      final normalizedId = userId.trim().toLowerCase();
      final normalizedCurrentUid = currentUid.toLowerCase();
      return normalizedId == normalizedCurrentUid ||
          normalizedId == 'all' ||
          normalizedId == 'all_users' ||
          normalizedId == 'everyone';
    }

    if (receiverValue is String && matchesUserId(receiverValue)) {
      return true;
    }

    if (targetUserIdValue is String && matchesUserId(targetUserIdValue)) {
      return true;
    }

    if (targetUsersValue is List) {
      return targetUsersValue.any((user) => user?.toString().trim().toLowerCase() == currentUid.toLowerCase());
    }

    if (receiverIdsValue is List) {
      return receiverIdsValue.any((user) => user?.toString().trim().toLowerCase() == currentUid.toLowerCase());
    }

    return false;
  }

  /// Firestore ထဲသို့ အကြောင်းကြားစာ (Notification) ပို့ပေးသည့် ဖန်ရှင်
  static Future<void> sendNotification({
    required String receiverId, // ပို့စ်/ဓာတ်ပုံ ပိုင်ရှင်၏ UID
    required String type,       // 'post_like', 'image_like', 'post_comment', 'image_comment'
    required String postId,
    String? additionalText,     // ကွန်မန့်စာသား စသည်ဖြင့်
  }) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;

    // မိမိကိုယ်တိုင် ပြုလုပ်သော အက်ရှင် သို့မဟုတ် User Login မဝင်ထားလျှင် Noti မပို့ပါ
    if (currentUser == null || currentUser.uid == receiverId) return;

    try {
      await _db.collection('notifications').add({
        'senderId': currentUser.uid,
        'senderName': currentUser.displayName ?? "အသုံးပြုသူ",
        'senderPhotoUrl': currentUser.photoURL ?? "",
        'receiverId': receiverId,
        'type': type,
        'postId': postId,
        'additionalText': additionalText ?? "",
        'isRead': false,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Notification Send Error: $e");
    }
  }
}