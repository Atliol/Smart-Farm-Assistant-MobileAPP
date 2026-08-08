import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/call_model.dart';

class CallService {
  final CollectionReference _callCollection = FirebaseFirestore.instance.collection('calls');

  // ဖုန်းခေါ်ဝင်လာမှုကို စောင့်ကြည့်ရန် Stream (လက်ခံမည့်သူအတွက်)
  Stream<DocumentSnapshot> listenToCall(String userId) {
    return _callCollection.doc(userId).snapshots();
  }

  // ၁။ ဖုန်းစတင်ခေါ်ဆိုခြင်း (Make Call)
  Future<bool> makeCall(CallModel call) async {
    try {
      // Caller ရော Receiver ပါ Document တစ်ခုတည်းအောက်မှာ သိမ်းဆည်းရန် 
      // Receiver ရဲ့ UID ကို Document ID အဖြစ် သုံးပါမယ် (ဒါမှ Receiver ဘက်က နားစွင့်ရလွယ်ကူမယ်)
      await _callCollection.doc(call.receiverId).set(call.toMap());
      return true;
    } catch (e) {
      print("Error making call: $e");
      return false;
    }
  }

  // ၂။ ဖုန်းလက်ခံလိုက်ခြင်း (Answer Call)
  Future<void> answerCall(String receiverId) async {
    await _callCollection.doc(receiverId).update({'status': 'connected'});
  }

  // ၃။ ဖုန်းချလိုက်ခြင်း/ငြင်းပယ်လိုက်ခြင်း (End Call)
  Future<void> endCall(String receiverId) async {
    await _callCollection.doc(receiverId).update({'status': 'ended'});
    // ခေတ္တစောင့်ပြီး record ကို ဖျက်ထုတ်နိုင်သည်
    await _callCollection.doc(receiverId).delete();
  }
}