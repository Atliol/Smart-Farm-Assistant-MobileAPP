import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String userName;
  final String authorName;
  final String title;
  final String content;
  final String? imageUrl;
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

  factory PostModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return PostModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? '',
      authorName: data['authorName'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'],
      commentsCount: data['commentsCount'] ?? 0,
      likedBy: data['likedBy'] ?? [],
      createdAt: data['createdAt'] as Timestamp?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'userName': userName,
      'authorName': authorName,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'commentsCount': commentsCount,
      'likedBy': likedBy,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}