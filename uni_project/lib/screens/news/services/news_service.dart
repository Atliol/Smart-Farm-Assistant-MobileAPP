import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post_model.dart';
import '../models/user_profile_model.dart';
// 💡 သင့် models folder ထဲက profile model ဖိုင်နာမည်အတိုင်း အောက်မှာ ပြင်ပေးပါဦးဗျာ (နမူနာ user_model.dart လို့ ထားပေးပါတယ်)


class NewsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ... သင့်ရဲ့ အခြားသော ရေးထားပြီးသား code များ ...

  // 💡 ပြင်ဆင်လိုက်သည့်နေရာ: ဒေတာကို Map အနေနဲ့ပဲ Direct Return ပြန်ခိုင်းလိုက်တာကြောင့် Model ရှာမတွေ့တဲ့ Error လုံးဝ ကင်းစင်သွားပါလိမ့်မယ် ✨
  Future<Map<String, dynamic>?> getProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
      return null;
    } catch (e) {
      print("Error getting profile: $e");
      return null;
    }
  }
}