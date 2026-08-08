import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // User ID နှစ်ခုကို အက္خရာစဉ်အလိုက် စီပြီး တစ်မူထူးခြားတဲ့ Chat Room ID ထုတ်ပေးခြင်း
  String getChatRoomId(String userA, String userB) {
    return userA.compareTo(userB) < 0 ? "${userA}_$userB" : "${userB}_$userA";
  }

  // 1. စာတိုပေးပို့ခြင်း (Send Message)
  Future<void> sendMessage(String senderId, String receiverId, String messageText) async {
    String roomId = getChatRoomId(senderId, receiverId);

    // Message Data
    Map<String, dynamic> messageData = {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': messageText,
      'timestamp': FieldValue.serverTimestamp(),
    };

    WriteBatch batch = _db.batch();

    // Messages sub-collection ထဲ စာအသစ်ထည့်မယ်
    DocumentReference msgRef = _db.collection('chats').doc(roomId).collection('messages').doc();
    batch.set(msgRef, messageData);

    // Chat Room ရဲ့ နောက်ဆုံးစာ (Last Message) ကို Update လုပ်မယ် (Messenger List မှာ ပြဖို)
    DocumentReference roomRef = _db.collection('chats').doc(roomId);
    batch.set(roomRef, {
      'lastMessage': messageText,
      'lastSenderId': senderId,
      'participants': [senderId, receiverId],
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
  }

  // 2. စကားပြောခန်းထဲက စာများကို Real-time Stream ဖြင့် ဆွဲယူခြင်း
  Stream<QuerySnapshot> getMessages(String senderId, String receiverId) {
    String roomId = getChatRoomId(senderId, receiverId);
    return _db
        .collection('chats')
        .doc(roomId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}