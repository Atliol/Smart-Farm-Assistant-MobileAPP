import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ImageViewerScreen extends StatefulWidget {
  final String postId; // 💡 ဘယ်ပို့စ်ကလဲဆိုတာ သိရန် Post ID လိုအပ်ပါသည်
  final List<String> images;
  final int initialIndex;

  const ImageViewerScreen({
    super.key,
    required this.postId,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<ImageViewerScreen> createState() => _ImageViewerScreenState();
}

class _ImageViewerScreenState extends State<ImageViewerScreen> {
  late PageController _pageController;
  late int _currentIndex;
  double _dragOffset = 0.0;
  User? get _currentUser => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  Uint8List? _getByteImage(String base64String) {
    if (!base64String.contains(',')) return null;
    try {
      String pureBase64 = base64String.split(',')[1];
      return base64Decode(pureBase64);
    } catch (e) {
      return null;
    }
  }

  // 💡 ပုံတစ်ပုံချင်းစီအတွက် သီးသန့် Like လုပ်မည့် ဖန်ရှင်
  Future<void> _toggleImageLike(int imgIndex) async {
    if (_currentUser == null) return;
    String uid = _currentUser!.uid;
    String displayName = _currentUser!.displayName ?? "အသုံးပြုသူ";

    DocumentReference imgRef = FirebaseFirestore.instance
        .collection('posts')
        .doc(widget.postId)
        .collection('images_data')
        .doc('img_$imgIndex');

    try {
      DocumentSnapshot imgDoc = await imgRef.get();
      if (!imgDoc.exists) {
        // Doc မရှိသေးပါက အသစ်ဆောက်ပြီး Like ထည့်မည်
        await imgRef.set({
          'likedBy': [
            {'uid': uid, 'name': displayName}
          ]
        });
        return;
      }

      List<dynamic> likedBy = imgDoc.get('likedBy') is List ? imgDoc.get('likedBy') : [];
      bool isAlreadyLiked = likedBy.any((item) => item is Map && item['uid'] == uid);

      if (isAlreadyLiked) {
        var itemToRemove = likedBy.firstWhere((item) => item is Map && item['uid'] == uid);
        await imgRef.update({
          'likedBy': FieldValue.arrayRemove([itemToRemove])
        });
      } else {
        await imgRef.update({
          'likedBy': FieldValue.arrayUnion([
            {'uid': uid, 'name': displayName}
          ])
        });
      }
    } catch (e) {
      print("Image Like Error: $e");
    }
  }

  // 💡 ပုံတစ်ပုံချင်းစီအတွက် သီးသန့် Comment Sheet ခေါ်မည့် ဖန်ရှင်
  void _showImageCommentSheet(int imgIndex) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ImageCommentSheet(postId: widget.postId, imgIndex: imgIndex);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String imageDocId = 'img_$_currentIndex';

    return Scaffold(
      backgroundColor: Colors.black.withOpacity((1.0 - (_dragOffset.abs() / 300)).clamp(0.2, 1.0)),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "${_currentIndex + 1} / ${widget.images.length}",
          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          setState(() {
            _dragOffset += details.primaryDelta!;
          });
        },
        onVerticalDragEnd: (details) {
          if (_dragOffset > 100) {
            Navigator.pop(context);
          } else {
            setState(() {
              _dragOffset = 0.0;
            });
          }
        },
        child: Transform.translate(
          offset: Offset(0, _dragOffset),
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final byteImg = _getByteImage(widget.images[index]);
              if (byteImg == null) {
                return const Center(
                  child: Icon(Icons.broken_image, color: Colors.grey, size: 50),
                );
              }
              return Center(
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: Image.memory(
                    byteImg,
                    fit: BoxFit.contain,
                    width: double.infinity,
                  ),
                ),
              );
            },
          ),
        ),
      ),

      // 💡 Facebook Style Image Action Bar (Like & Comment)
      bottomNavigationBar: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('images_data')
            .doc(imageDocId)
            .snapshots(),
        builder: (context, snapshot) {
          List<dynamic> likedBy = [];
          if (snapshot.hasData && snapshot.data!.exists) {
            var data = snapshot.data!.data() as Map<String, dynamic>;
            likedBy = data['likedBy'] is List ? data['likedBy'] : [];
          }

          bool isLikedByMe = _currentUser != null &&
              likedBy.any((item) => item is Map && item['uid'] == _currentUser!.uid);

          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('posts')
                .doc(widget.postId)
                .collection('images_data')
                .doc(imageDocId)
                .collection('comments')
                .snapshots(),
            builder: (context, commentSnapshot) {
              int commentCount = commentSnapshot.hasData ? commentSnapshot.data!.docs.length : 0;

              return Container(
                color: Colors.black.withOpacity(0.6),
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: SafeArea(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // 👍 Like Button
                      TextButton.icon(
                        onPressed: () => _toggleImageLike(_currentIndex),
                        icon: Icon(
                          isLikedByMe ? Icons.thumb_up_rounded : Icons.thumb_up_off_alt_rounded,
                          color: isLikedByMe ? Colors.blue : Colors.white,
                        ),
                        label: Text(
                          likedBy.isEmpty ? "Like" : "${likedBy.length}",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      // 💬 Comment Button
                      TextButton.icon(
                        onPressed: () => _showImageCommentSheet(_currentIndex),
                        icon: const Icon(Icons.chat_bubble_outline_rounded, color: Colors.white),
                        label: Text(
                          commentCount == 0 ? "Comment" : "$commentCount",
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

// ==========================================
// 💡 ပုံတစ်ပုံချင်းစီအတွက် သီးသန့်သုံးမည့် Comment Sheet Widget
// ==========================================
class ImageCommentSheet extends StatefulWidget {
  final String postId;
  final int imgIndex;
  const ImageCommentSheet({super.key, required this.postId, required this.imgIndex});

  @override
  State<ImageCommentSheet> createState() => _ImageCommentSheetState();
}

class _ImageCommentSheetState extends State<ImageCommentSheet> {
  final TextEditingController _commentController = TextEditingController();
  User? get _currentUser => FirebaseAuth.instance.currentUser;

  Future<void> _sendComment() async {
    String text = _commentController.text.trim();
    if (text.isEmpty || _currentUser == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.postId)
          .collection('images_data')
          .doc('img_${widget.imgIndex}')
          .collection('comments')
          .add({
        'userId': _currentUser!.uid,
        'userName': _currentUser!.displayName ?? "အသုံးပြုသူ",
        'comment': text,
        'createdAt': FieldValue.serverTimestamp(),
      });
      _commentController.clear();
    } catch (e) {
      print("Comment Send Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("ဓာတ်ပုံပေါ်က မှတ်ချက်များ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const Divider(height: 1),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(widget.postId)
                    .collection('images_data')
                    .doc('img_${widget.imgIndex}')
                    .collection('comments')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                  var docs = snapshot.data!.docs;
                  if (docs.isEmpty) {
                    return const Center(child: Text("မှတ်ချက်မရှိသေးပါ၊ ပထမဆုံးရေးသူဖြစ်လိုက်ပါ ✍️"));
                  }
                  return ListView.builder(
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      var data = docs[index].data() as Map<String, dynamic>;
                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(data['userName'] ?? "အသုံးပြုသူ", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text(data['comment'] ?? ""),
                      );
                    },
                  );
                },
              ),
            ),
            const Divider(height: 1),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _commentController,
                        decoration: InputDecoration(
                          hintText: "မှတ်ချက်တစ်ခုခု ရေးရန်...",
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: _sendComment,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}