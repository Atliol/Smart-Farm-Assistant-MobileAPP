import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String uid;
  final String name;
  final String email;
  final String? profilePic;

  UserProfileModel({required this.uid, required this.name, required this.email, this.profilePic});

  factory UserProfileModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserProfileModel(
      uid: doc.id,
      name: data['name'] ?? data['userName'] ?? 'အသုံးပြုသူ',
      email: data['email'] ?? '',
      profilePic: data['profilePic'] ?? data['imageUrl'],
    );
  }
}