import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/call_model.dart';
import 'push_notification_service.dart';

class CallService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. Incoming Call များကို Listen လုပ်ရန်
  Stream<QuerySnapshot> listenToCall(String currentUserId) {
    return _firestore
        .collection('calls')
        .where('receiverId', isEqualTo: currentUserId)
        .where('status', isEqualTo: 'dialing')
        .snapshots();
  }

  // 2. ဖုန်းစခေါ်ချိန်တွင် Firestore သို့ သိမ်းပြီး FCM Notification ပါ တစ်ခါတည်း ပို့ရန်
  Future<bool> makeCall({required CallModel call}) async {
    try {
      // Document ID ကို ရောထွေးမှုမရှိစေရန် call.callId ကို သေချာသုံးထားပါတယ်
      await _firestore.collection('calls').doc(call.callId).set(call.toMap());

      // Target Receiver ရဲ့ FCM Token ကို Firestore ထဲက သွားယူမယ်
      DocumentSnapshot userDoc = 
          await _firestore.collection('users').doc(call.receiverId).get();

      if (userDoc.exists && userDoc.data() != null) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        String? receiverToken = userData['fcmToken'];

        if (receiverToken != null && receiverToken.isNotEmpty) {
          // http package သုံးပြီး FCM ဆီ notification တိုက်ရိုက်ပို့ခြင်း
          await PushNotificationService.sendCallNotification(
            callerId: call.callerId,
            receiverId: call.receiverId,
            receiverToken: receiverToken,
            channelId: call.channelId,
            callerName: call.callerName,
            callType: call.isVideoCall ? 'video' : 'voice',
            callId: call.callId,
          );
        }
      }
      return true;
    } catch (e) {
      print("Make Call Error: $e");
      return false;
    }
  }

  // 3. ဖုန်းလက်ခံလိုက်လျှင် Call Document ကို Update လုပ်ရန်
  Future<void> acceptCall(String callId) async {
    await _firestore.collection('calls').doc(callId).update({
      'isAccepted': true,
      'status': 'connected',
    });
  }

  // 4. ဖုန်းချလိုက်လျှင် Call Document ကို ဖျက်ရန်
  Future<void> endCall(String callId) async {
    await _firestore.collection('calls').doc(callId).delete();
  }

  // 5. Call Document ရဲ့ အပြောင်းအလဲကို Listen လုပ်ရန် Helper Stream
  Stream<DocumentSnapshot> streamCallStatus(String callId) {
    return _firestore.collection('calls').doc(callId).snapshots();
  }
}