import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import '../models/post_model.dart';

class CommentSheet extends StatefulWidget {
  final PostModel post;
  const CommentSheet({super.key, required this.post});

  @override
  State<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends State<CommentSheet> {
  User? get _currentUser => FirebaseAuth.instance.currentUser;
  final TextEditingController _commentController = TextEditingController();
  final TextEditingController _replyController = TextEditingController();

  final ImagePicker _commentImagePicker = ImagePicker();
  String? _selectedCommentBase64;
  bool _isCommentImageLoading = false;

  String? _selectedReplyBase64;
  bool _isReplyImageLoading = false;

  String? _activeReplyTargetId;
  String? _replyToUserName;
  String? _activeMainCommentId;

  Uint8List? _getCommentByteImage(String? base64String) {
    if (base64String == null || base64String.isEmpty || base64String.startsWith('blob:')) return null;
    try {
      if (base64String.contains(',')) {
        return base64Decode(base64String.split(',')[1]);
      }
      return base64Decode(base64String);
    } catch (e) {
      return null;
    }
  }

  ImageProvider? _getAvatarImage(String? base64Str) {
    if (base64Str == null || base64Str.isEmpty || base64Str.startsWith('blob:')) return null;
    try {
      return MemoryImage(base64Decode(base64Str));
    } catch (e) {
      return null;
    }
  }

  Future<void> _pickCommentImage({bool isReply = false}) async {
    try {
      final XFile? image = await _commentImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 30);
      if (image != null) {
        setState(() {
          if (isReply) _isReplyImageLoading = true; else _isCommentImageLoading = true;
        });

        List<int> imageBytes = await image.readAsBytes();
        String prefix = "data:image/jpeg;base64,";
        String base64Str = base64Encode(imageBytes);

        setState(() {
          if (isReply) {
            _selectedReplyBase64 = "$prefix$base64Str";
          } else {
            _selectedCommentBase64 = "$prefix$base64Str";
          }
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    } finally {
      setState(() {
        if (isReply) _isReplyImageLoading = false; else _isCommentImageLoading = false;
      });
    }
  }

  Future<void> _sendComment() async {
    if (_currentUser == null) return;
    String commentText = _commentController.text.trim();
    if (commentText.isEmpty && _selectedCommentBase64 == null) return;

    String? imageToSend = _selectedCommentBase64;
    _commentController.clear();
    setState(() { _selectedCommentBase64 = null; });

    try {
      DocumentReference postRef = FirebaseFirestore.instance.collection('posts').doc(widget.post.id);
      await postRef.collection('comments').add({
        'userId': _currentUser!.uid,
        'userName': _currentUser!.displayName ?? "အသုံးပြုသူ",
        'comment': commentText,
        'commentImageUrl': imageToSend,
        'likedBy': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
      await postRef.update({'commentsCount': FieldValue.increment(1)});
    } catch (e) { print(e); }
  }

  Future<void> _sendReply(String commentId) async {
    if (_currentUser == null || _activeReplyTargetId == null) return;
    String replyText = _replyController.text.trim();
    if (replyText.isEmpty && _selectedReplyBase64 == null) return;

    String? imageToSend = _selectedReplyBase64;
    _replyController.clear();

    setState(() {
      _selectedReplyBase64 = null;
      _activeReplyTargetId = null;
      _activeMainCommentId = null;
      _replyToUserName = null;
    });

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.post.id)
          .collection('comments')
          .doc(commentId)
          .collection('replies')
          .add({
        'userId': _currentUser!.uid,
        'userName': _currentUser!.displayName ?? "အသုံးပြုသူ",
        'comment': replyText,
        'commentImageUrl': imageToSend,
        'likedBy': [],
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) { print(e); }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
              child: const Center(child: Text("မှတ်ချက်များ", style: TextStyle(fontWeight: FontWeight.bold))),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.post.id)
                    .collection('comments')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var commentDoc = snapshot.data!.docs[index];
                      var data = commentDoc.data() as Map<String, dynamic>;
                      String commentId = commentDoc.id;
                      String commenterId = data['userId'] ?? '';
                      String commenterName = data['userName'] ?? 'အသုံးပြုသူ';
                      Uint8List? commentImgBytes = _getCommentByteImage(data['commentImageUrl']);

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // --- MAIN COMMENT ROW ---
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance.collection('users').doc(commenterId).snapshots(),
                                  builder: (context, userSnap) {
                                    String? commenterBase64;
                                    if (userSnap.hasData && userSnap.data!.exists) {
                                      commenterBase64 = (userSnap.data!.data() as Map<String, dynamic>?)?['photoUrl'];
                                    }
                                    final avatarImg = _getAvatarImage(commenterBase64);
                                    return CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Colors.grey.shade200,
                                      backgroundImage: avatarImg,
                                      child: avatarImg == null ? const Icon(Icons.person, color: Colors.grey, size: 18) : null,
                                    );
                                  },
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(commenterName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                            if ((data['comment'] ?? '').toString().isNotEmpty)
                                              Padding(
                                                padding: const EdgeInsets.only(top: 2.0),
                                                child: Text(data['comment'] ?? '', style: const TextStyle(fontSize: 13)),
                                              ),
                                          ],
                                        ),
                                      ),
                                      if (commentImgBytes != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 6.0, left: 4.0),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Container(
                                              constraints: const BoxConstraints(maxHeight: 140),
                                              child: Image.memory(commentImgBytes, fit: BoxFit.contain),
                                            ),
                                          ),
                                        ),

                                      Padding(
                                        padding: const EdgeInsets.only(left: 4.0, top: 4.0),
                                        child: Row(
                                          children: [
                                            // 💡 <b>၁။ သီးသန့် LikeButton သုံးထား၍ Refresh ဖြစ်မသွားတော့ပါ</b>
                                            CommentLikeButton(
                                              postId: widget.post.id,
                                              commentId: commentId,
                                              currentUserId: _currentUser?.uid,
                                            ),
                                            const SizedBox(width: 16),
                                            GestureDetector(
                                              onTap: () => setState(() {
                                                _activeReplyTargetId = commentId;
                                                _activeMainCommentId = commentId;
                                                _replyToUserName = commenterName;
                                              }),
                                              child: const Text("Reply", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            // --- REPLIES STREAM ---
                            StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('posts')
                                  .doc(widget.post.id)
                                  .collection('comments')
                                  .doc(commentId)
                                  .collection('replies')
                                  .orderBy('createdAt', descending: false)
                                  .snapshots(),
                              builder: (context, replySnapshot) {
                                if (!replySnapshot.hasData || replySnapshot.data!.docs.isEmpty) return const SizedBox();
                                return Padding(
                                  padding: const EdgeInsets.only(left: 42.0, top: 4.0),
                                  child: Column(
                                    children: replySnapshot.data!.docs.map((replyDoc) {
                                      var rData = replyDoc.data() as Map<String, dynamic>;
                                      String replyId = replyDoc.id;
                                      String rUserId = rData['userId'] ?? '';
                                      String rUserName = rData['userName'] ?? 'အသုံးပြုသူ';
                                      Uint8List? rImgBytes = _getCommentByteImage(rData['commentImageUrl']);

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            StreamBuilder<DocumentSnapshot>(
                                              stream: FirebaseFirestore.instance.collection('users').doc(rUserId).snapshots(),
                                              builder: (context, rUserSnap) {
                                                String? rBase64;
                                                if (rUserSnap.hasData && rUserSnap.data!.exists) {
                                                  rBase64 = (rUserSnap.data!.data() as Map<String, dynamic>?)?['photoUrl'];
                                                }
                                                final rAvatar = _getAvatarImage(rBase64);
                                                return CircleAvatar(
                                                  radius: 12,
                                                  backgroundColor: Colors.grey.shade200,
                                                  backgroundImage: rAvatar,
                                                  child: rAvatar == null ? const Icon(Icons.person, color: Colors.grey, size: 14) : null,
                                                );
                                              },
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                                    decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(10)),
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(rUserName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                                                        if ((rData['comment'] ?? '').toString().isNotEmpty)
                                                          Text(rData['comment'] ?? '', style: const TextStyle(fontSize: 12)),
                                                      ],
                                                    ),
                                                  ),
                                                  if (rImgBytes != null)
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 4.0),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(6),
                                                        child: Container(
                                                          constraints: const BoxConstraints(maxHeight: 100),
                                                          child: Image.memory(rImgBytes, fit: BoxFit.contain),
                                                        ),
                                                      ),
                                                    ),

                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 4.0, top: 2.0),
                                                    child: Row(
                                                      children: [
                                                        // 💡 <b>၂။ သီးသန့် Reply LikeButton သုံးထား၍ Rebuild လုံးဝမဖြစ်ပါ</b>
                                                        ReplyLikeButton(
                                                          postId: widget.post.id,
                                                          commentId: commentId,
                                                          replyId: replyId,
                                                          currentUserId: _currentUser?.uid,
                                                        ),
                                                        const SizedBox(width: 14),
                                                        GestureDetector(
                                                          onTap: () => setState(() {
                                                            _activeReplyTargetId = replyId;
                                                            _activeMainCommentId = commentId;
                                                            _replyToUserName = rUserName;
                                                          }),
                                                          child: const Text("Reply", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                );
                              },
                            ),

                            if (_activeMainCommentId == commentId)
                              Padding(
                                padding: const EdgeInsets.only(left: 42.0, top: 8.0, bottom: 4.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_selectedReplyBase64 != null)
                                      Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(6),
                                            child: Image.memory(_getCommentByteImage(_selectedReplyBase64)!, height: 60, fit: BoxFit.cover),
                                          ),
                                          Positioned(
                                            top: 0, right: 0,
                                            child: GestureDetector(
                                              onTap: () => setState(() => _selectedReplyBase64 = null),
                                              child: const CircleAvatar(radius: 8, backgroundColor: Colors.black54, child: Icon(Icons.close, size: 10, color: Colors.white)),
                                            ),
                                          )
                                        ],
                                      ),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: _isReplyImageLoading
                                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                              : const Icon(Icons.camera_alt_rounded, size: 20, color: Colors.blueGrey),
                                          onPressed: () => _pickCommentImage(isReply: true),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            controller: _replyController,
                                            style: const TextStyle(fontSize: 13),
                                            decoration: InputDecoration(
                                                hintText: "Replying to @$_replyToUserName...",
                                                isDense: true,
                                                border: InputBorder.none
                                            ),
                                          ),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.send, size: 20, color: Colors.blue),
                                          onPressed: () => _sendReply(commentId),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.cancel_outlined, size: 20, color: Colors.grey),
                                          onPressed: () => setState(() {
                                            _activeReplyTargetId = null;
                                            _activeMainCommentId = null;
                                            _replyToUserName = null;
                                          }),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            if (_selectedCommentBase64 != null)
              Container(
                padding: const EdgeInsets.all(8), color: Colors.grey.shade50, alignment: Alignment.centerLeft,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(_getCommentByteImage(_selectedCommentBase64)!, height: 75, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 0, right: 0,
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedCommentBase64 = null),
                        child: const CircleAvatar(radius: 10, backgroundColor: Colors.black54, child: Icon(Icons.close, size: 12, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade200))),
              child: Row(
                children: [
                  IconButton(
                    icon: _isCommentImageLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.camera_alt_rounded, color: Colors.blueGrey),
                    onPressed: () => _pickCommentImage(),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: const InputDecoration(hintText: "မှတ်ချက်ရေးရန်...", border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _sendComment,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 💡 <b>[Component - ၃] Comment Like ခလုပ်အတွက် သီးသန့် Rebuild ပေးမည့် Widget</b>
class CommentLikeButton extends StatelessWidget {
  final String postId;
  final String commentId;
  final String? currentUserId;

  const CommentLikeButton({
    super.key,
    required this.postId,
    required this.commentId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId);

    return StreamBuilder<DocumentSnapshot>(
      stream: docRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text("Like", style: TextStyle(color: Colors.grey, fontSize: 12));
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;
        List<dynamic> likedBy = data['likedBy'] is List ? data['likedBy'] : [];
        bool isLiked = likedBy.contains(currentUserId);

        return GestureDetector(
          onTap: () async {
            if (currentUserId == null) return;
            if (isLiked) {
              await docRef.update({'likedBy': FieldValue.arrayRemove([currentUserId])});
            } else {
              await docRef.update({'likedBy': FieldValue.arrayUnion([currentUserId])});
            }
          },
          child: Row(
            children: [
              Text(
                isLiked ? "Liked" : "Like",
                style: TextStyle(
                  color: isLiked ? Colors.blue : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              if (likedBy.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text("${likedBy.length}", style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ]
            ],
          ),
        );
      },
    );
  }
}

// 💡 <b>[Component - ၄] Reply Like ခလုပ်အတွက် သီးသန့် Rebuild ပေးမည့် Widget</b>
class ReplyLikeButton extends StatelessWidget {
  final String postId;
  final String commentId;
  final String replyId;
  final String? currentUserId;

  const ReplyLikeButton({
    super.key,
    required this.postId,
    required this.commentId,
    required this.replyId,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final docRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('replies')
        .doc(replyId);

    return StreamBuilder<DocumentSnapshot>(
      stream: docRef.snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text("Like", style: TextStyle(color: Colors.grey, fontSize: 11));
        }

        var data = snapshot.data!.data() as Map<String, dynamic>;
        List<dynamic> likedBy = data['likedBy'] is List ? data['likedBy'] : [];
        bool isLiked = likedBy.contains(currentUserId);

        return GestureDetector(
          onTap: () async {
            if (currentUserId == null) return;
            if (isLiked) {
              await docRef.update({'likedBy': FieldValue.arrayRemove([currentUserId])});
            } else {
              await docRef.update({'likedBy': FieldValue.arrayUnion([currentUserId])});
            }
          },
          child: Row(
            children: [
              Text(
                isLiked ? "Liked" : "Like",
                style: TextStyle(
                  color: isLiked ? Colors.blue : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
              if (likedBy.isNotEmpty) ...[
                const SizedBox(width: 4),
                Text("${likedBy.length}", style: const TextStyle(fontSize: 10, color: Colors.grey)),
              ]
            ],
          ),
        );
      },
    );
  }
}