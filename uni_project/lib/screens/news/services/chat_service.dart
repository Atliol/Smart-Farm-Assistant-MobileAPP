import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  
  String getChatRoomId(String userA, String userB) {
    return userA.compareTo(userB) < 0 ? "${userA}_$userB" : "${userB}_$userA";
  }

  
  Future<void> sendMessage(String senderId, String receiverId, String messageText) async {
    String roomId = getChatRoomId(senderId, receiverId);

    
    Map<String, dynamic> messageData = {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': messageText,
      'timestamp': FieldValue.serverTimestamp(),
    };

    WriteBatch batch = _db.batch();

    
    DocumentReference msgRef = _db.collection('chats').doc(roomId).collection('messages').doc();
    batch.set(msgRef, messageData);

    
    DocumentReference roomRef = _db.collection('chats').doc(roomId);
    batch.set(roomRef, {
      'lastMessage': messageText,
      'lastSenderId': senderId,
      'participants': [senderId, receiverId],
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    await batch.commit();
  }

  
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