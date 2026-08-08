import 'package:cloud_firestore/cloud_firestore.dart';

class SocialService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 1. Follow / Unfollow စနစ် (အပြန်အလှန် Follow လုပ်ရင် Friend သဘောမျိုးဖြစ်သွားပါမယ်)
  Future<void> toggleFollow(String currentUserId, String targetUserId, bool isFollowing) async {
    WriteBatch batch = _db.batch();

    DocumentReference myFollowingRef = _db.collection('users').doc(currentUserId).collection('following').doc(targetUserId);
    DocumentReference targetFollowerRef = _db.collection('users').doc(targetUserId).collection('followers').doc(currentUserId);

    if (isFollowing) {
      batch.delete(myFollowingRef);
      batch.delete(targetFollowerRef);
    } else {
      batch.set(myFollowingRef, {'timestamp': FieldValue.serverTimestamp()});
      batch.set(targetFollowerRef, {'timestamp': FieldValue.serverTimestamp()});
    }
    await batch.commit();
  }

  // 2. ကိုယ်က သူ့ကို Follow လုပ်ထားသလား စစ်ဆေးရန်
  Stream<bool> isFollowing(String currentUserId, String targetUserId) {
    return _db.collection('users').doc(currentUserId).collection('following').doc(targetUserId).snapshots().map((doc) => doc.exists);
  }

  // 3. Followers / Following Count ရယူရန်
  Stream<int> getCount(String userId, String type) {
    return _db.collection('users').doc(userId).collection(type).snapshots().map((snap) => snap.docs.length);
  }

  // 4. Messenger စနစ်အတွက် Chat Room ID ထုတ်ပေးရန် (User ID ၂ ခုကို စီပေးခြင်း)
  String getChatRoomId(String userA, String userB) {
    return userA.compareTo(userB) < 0 ? "${userA}_$userB" : "${userB}_$userA";
  }

  // 5. Messenger မှာ စာပို့ရန်
  Future<void> sendMessage(String senderId, String receiverId, String text) async {
    if (text.trim().isEmpty) return;
    String roomId = getChatRoomId(senderId, receiverId);

    WriteBatch batch = _db.batch();
    DocumentReference msgRef = _db.collection('chats').doc(roomId).collection('messages').doc();
    
    batch.set(msgRef, {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
    });

    DocumentReference roomRef = _db.collection('chats').doc(roomId);
    batch.set(roomRef, {
      'lastMessage': text.trim(),
      'participants': [senderId, receiverId],
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
  }
}