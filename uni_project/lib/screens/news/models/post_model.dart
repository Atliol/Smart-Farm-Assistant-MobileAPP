import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String authorName;
  final String title;
  final String content;
  final String? imageUrl; // 💡 ဓာတ်ပုံ URL သိမ်းရန် Variable (ပုံမပါရင် null ဖြစ်နိုင်ပါတယ်)
  final int commentsCount;
  final List<dynamic> likedBy;
  final Timestamp? createdAt;

  PostModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.authorName,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.commentsCount,
    required this.likedBy,
    this.createdAt,
  });

  // 💡 Firebase (Firestore) ကလာတဲ့ Data ကို PostModel Object ပြောင်းပေးသည့် နေရာ
  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PostModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      authorName: data['authorName'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'], // 👈 Firestore ထဲက imageUrl ကို ဖတ်ယူခြင်း
      commentsCount: data['commentsCount'] ?? 0,
      likedBy: data['likedBy'] ?? [],
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  // 💡 PostModel Object ကနေ Firestore ထဲ ဒေတာပြန်သိမ်းချင်ရင် သုံးနိုင်မည့် မက်သတ် (Optional)
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'authorName': authorName,
      'title': title,
      'content': content,
      'imageUrl': imageUrl, // 👈 ပုံရှိရင် URL သိမ်းပြီး၊ မရှိရင် null အနေနဲ့ သိမ်းပါမယ်
      'commentsCount': commentsCount,
      'likedBy': likedBy,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}