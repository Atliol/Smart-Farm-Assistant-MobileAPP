import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/post_model.dart';
import '../services/news_service.dart';
import '../profile_screen.dart';
import 'comment_sheet.dart';
import '../image_viewer_screen.dart'; // 💡 ImageViewerScreen ထို့ကြောင့် Import ရှိပြီးသားဖြစ်ရမည်
import '../create_post_screen.dart';
import '../../../../services/notification_service.dart'; // 💡 Notification Service ကို Import လုပ်ပါ

class PostCard extends StatefulWidget {
  final PostModel post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  final TextEditingController _shareTitleController = TextEditingController();
  final TextEditingController _shareContentController = TextEditingController();
  final TextEditingController _reportController = TextEditingController();

  // 💡 Base64 စာသားကို Byte ပြောင်းပေးမည့် အကူဖန်ရှင်
  Uint8List? _getByteImage(String? base64String) {
    if (base64String == null || !base64String.contains(',')) return null;
    try {
      String pureBase64 = base64String.split(',')[1];
      return base64Decode(pureBase64);
    } catch (e) {
      print("Base64 Decode Error: $e");
      return null;
    }
  }

  // 💡 Grid ထဲက ပုံတစ်ပုံချင်းစီကို နှိပ်လျှင် ImageViewerScreen သို့ Post ID နှင့် Index အမှန်အတိုင်း သွားရန် ပြင်ဆင်ခြင်း
  Widget _buildGridImageItem(List<String> allImages, int index, double height) {
    final byteImg = _getByteImage(allImages[index]);
    if (byteImg == null) return const SizedBox();
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ImageViewerScreen(
              postId: widget.post.id, // 💡 Image Action Bar အတွက် Post ID ထည့်သွင်းပေးထားပါသည်
              images: allImages,
              initialIndex: index,
            ),
          ),
        );
      },
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Image.memory(
          byteImg,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // 💡 📸 ဓာတ်ပုံများကို Facebook Style Grid Layout ဖြင့် စနစ်တကျ ပြောင်းလဲပြင်ဆင်ပေးသည့် Widget
  Widget _buildPostImages(List<dynamic>? imageUrls, String? singleImageUrl) {
    List<String> images = [];

    if (imageUrls != null && imageUrls.isNotEmpty) {
      images = imageUrls.map((e) => e.toString()).toList();
    } else if (singleImageUrl != null && singleImageUrl.isNotEmpty) {
      images = [singleImageUrl];
    }

    if (images.isEmpty) return const SizedBox();

    int imageCount = images.length;

    // 1️⃣ ပုံ ၁ ပုံတည်းရှိလျှင် - နှိပ်လိုက်ပါက Full Screen ပွင့်မည်
    if (imageCount == 1) {
      final byteImg = _getByteImage(images[0]);
      if (byteImg == null) return const SizedBox();
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ImageViewerScreen(
                    postId: widget.post.id, // 💡 Image Action Bar အတွက် Post ID ထည့်သွင်းပေးထားပါသည်
                    images: images,
                    initialIndex: 0,
                  ),
                ),
              );
            },
            child: SizedBox(
              width: double.infinity,
              height: 240,
              child: Image.memory(
                byteImg,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      );
    }

    // 2️⃣ ပုံအများကြီးရှိလျှင် သုံးမည့် Grid Layout Builder (နှိပ်သည့် ပုံအလိုက် Full Screen ပွင့်မည်)
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            double height = 240; // Grid တစ်ခုလုံးစာ သတ်မှတ်အမြင့်

            if (imageCount == 2) {
              // 👥 ပုံ ၂ ပုံဆိုလျှင် ဘယ်/ညာ တစ်ဝက်စီပြမည်
              return Row(
                children: [
                  Expanded(child: _buildGridImageItem(images, 0, height)),
                  const SizedBox(width: 4),
                  Expanded(child: _buildGridImageItem(images, 1, height)),
                ],
              );
            } else if (imageCount == 3) {
              // 📐 ပုံ ၃ ပုံဆိုလျှင် ဘယ်ဘက်ပုံကြီးတစ်ပုံ၊ ညာဘက်ပုံသေးနှစ်ပုံပြမည်
              return SizedBox(
                height: height,
                child: Row(
                  children: [
                    Expanded(child: _buildGridImageItem(images, 0, height)),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Column(
                        children: [
                          Expanded(child: _buildGridImageItem(images, 1, double.infinity)),
                          const SizedBox(height: 4),
                          Expanded(child: _buildGridImageItem(images, 2, double.infinity)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // 🎴 ပုံ ၄ ပုံ သို့မဟုတ် ၎င်းထက်ကျော်ပါက 2x2 Grid ပုံစံပြပြီး နောက်ဆုံးပုံတွင် "+More" ပြမည်
              return SizedBox(
                height: height,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: _buildGridImageItem(images, 0, double.infinity)),
                          const SizedBox(width: 4),
                          Expanded(child: _buildGridImageItem(images, 1, double.infinity)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(child: _buildGridImageItem(images, 2, double.infinity)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Stack(
                              children: [
                                _buildGridImageItem(images, 3, double.infinity),
                                if (imageCount > 4)
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ImageViewerScreen(
                                            postId: widget.post.id, // 💡 Image Action Bar အတွက် Post ID ထည့်သွင်းပေးထားပါသည်
                                            images: images,
                                            initialIndex: 3,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      color: Colors.black.withOpacity(0.5),
                                      child: Center(
                                        child: Text(
                                          "+${imageCount - 3}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
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
            }
          },
        ),
      ),
    );
  }

  Future<void> _deletePost() async {
    try {
      await FirebaseFirestore.instance.collection('posts').doc(widget.post.id).delete();
      if (mounted) _showTopToast(context, "ပို့စ်ကို အောင်မြင်စွာ ဖျက်သိမ်းပြီးပါပြီ 🗑️");
    } catch (e) {
      print("Delete Error: $e");
    }
  }

  Future<void> _submitReport() async {
    if (_currentUser == null) return;
    String reason = _reportController.text.trim();
    if (reason.isEmpty) {
      _showTopToast(context, "တိုင်ကြားရသည့် အကြောင်းအရင်း ရေးပေးပါ");
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('reports').add({
        'postId': widget.post.id,
        'postOwnerId': widget.post.userId,
        'postContent': widget.post.content,
        'reportedByUid': _currentUser!.uid,
        'reportedByName': _currentUser!.displayName ?? "အသုံးပြုသူ",
        'reason': reason,
        'createdAt': FieldValue.serverTimestamp(),
      });

      _reportController.clear();
      if (mounted) {
        Navigator.pop(context);
        _showTopToast(context, "တိုင်ကြားချက်ကို လက်ခံရရှိပါပြီ 🙏");
      }
    } catch (e) {
      print("Report Error: $e");
    }
  }

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.report_problem, color: Colors.orange),
            SizedBox(width: 8),
            Text("ပို့စ်အား တိုင်ကြားမည်", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: TextField(
          controller: _reportController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "ဘာကြောင့် Report လုပ်ရလဲဆိုတာ ရေးပေးပါ...",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.orange),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("မလုပ်တော့ပါ", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: _submitReport,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text("တိုင်ကြားမည်", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPostMenu(bool isMyPost) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              if (isMyPost)
                ListTile(
                  leading: const Icon(Icons.delete_outline, color: Colors.red),
                  title: const Text("ပို့စ်အား ဖျက်သိမ်းမည်", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    _deletePost();
                  },
                )
              else
                ListTile(
                  leading: const Icon(Icons.report_gmailerrorred, color: Colors.orange),
                  title: const Text("ပို့စ်အား တိုင်ကြားမည် (Report)", style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    _showReportDialog();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  // 💡 Like ပေးလျှင် Noti ကျစေရန် ပြင်ဆင်ထားသည့် ဖန်ရှင်
  Future<void> _toggleLike() async {
    if (_currentUser == null) return;
    String uid = _currentUser!.uid;
    String displayName = _currentUser!.displayName ?? "အသုံးပြုသူ";
    DocumentReference postRef = FirebaseFirestore.instance.collection('posts').doc(widget.post.id);

    try {
      DocumentSnapshot postDoc = await postRef.get();
      if (!postDoc.exists) return;
      List<dynamic> likedBy = postDoc.get('likedBy') is List ? postDoc.get('likedBy') : [];
      String postOwnerId = postDoc.get('userId') ?? ""; // ပို့စ်ပိုင်ရှင် ID ကို ရယူခြင်း

      bool isAlreadyLiked = false;
      dynamic itemToRemove;
      for (var item in likedBy) {
        if (item is Map && item['uid'] == uid) { isAlreadyLiked = true; itemToRemove = item; break; }
        else if (item.toString() == uid || item.toString() == displayName) { isAlreadyLiked = true; itemToRemove = item; break; }
      }

      if (isAlreadyLiked) {
        await postRef.update({'likedBy': FieldValue.arrayRemove([itemToRemove])});
      } else {
        await postRef.update({'likedBy': FieldValue.arrayUnion([{'uid': uid, 'name': displayName}])});

        // 💡 👍 ပို့စ်ကို Like လုပ်လိုက်လျှင် ပို့စ်ပိုင်ရှင်ဆီသို့ Notification ပို့ပေးခြင်း
        await NotificationService.sendNotification(
          receiverId: postOwnerId,
          type: 'post_like',
          postId: widget.post.id,
        );
      }
    } catch (e) { print(e); }
  }

  Future<void> _sharePostWithThoughts() async {
    if (_currentUser == null) {
      _showTopToast(context, "Share ရန် လော့ဂ်အင်ဝင်ပါ");
      return;
    }

    String shareTitle = _shareTitleController.text.trim();
    String shareContent = _shareContentController.text.trim();

    try {
      await FirebaseFirestore.instance.collection('posts').add({
        'userId': _currentUser!.uid,
        'userName': _currentUser!.displayName ?? "အသုံးပြုသူ",
        'title': shareTitle,
        'content': shareContent,
        'imageUrl': widget.post.imageUrl,
        'commentsCount': 0,
        'likedBy': [],
        'createdAt': FieldValue.serverTimestamp(),
        'isShared': true,
        'originalPostId': widget.post.id,
        'originalPostOwner': widget.post.userName,
        'originalTitle': widget.post.title,
        'originalContent': widget.post.content,
      });

      _shareTitleController.clear();
      _shareContentController.clear();

      if (mounted) {
        Navigator.pop(context);
        _showTopToast(context, "မိမိ Timeline ပေါ်သို့ ရေးသားမျှဝေပြီးပါပြီ 🔄");
      }
    } catch (e) {
      print("Share Error: $e");
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

  void _showShareBottomSheet() {
    if (_currentUser == null) {
      _showTopToast(context, "Share ရန် လော့ဂ်အင်ဝင်ပါ");
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
                  child: const Center(child: Text("မိမိ Timeline သို့ မျှဝေမည်", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextField(
                        controller: _shareTitleController,
                        decoration: const InputDecoration(
                          hintText: "ခေါင်းစဉ် (မထည့်လည်းရပါသည်)",
                          border: InputBorder.none,
                          hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const Divider(),
                      TextField(
                        controller: _shareContentController,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "ဤပို့စ်အပေါ် သင့်အမြင်ကို ရေးသားပါ...",
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: 12),

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("@${widget.post.userName}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blueGrey)),
                            if (widget.post.title.isNotEmpty) Text(widget.post.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                            Text(widget.post.content, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      onPressed: _sharePostWithThoughts,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1877F2),
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: const Text("ယခုမျှဝေမည်", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCommentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        return CommentSheet(post: widget.post);
      },
    );
  }

  void _showTopToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 12,
        left: 16, right: 16,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: -100.0, end: 0.0),
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeOutBack,
            builder: (context, value, child) => Transform.translate(offset: Offset(0, value), child: child),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(color: const Color(0xFF2C2C2C), borderRadius: BorderRadius.circular(12)),
              child: Row(
                children: [
                  const Icon(Icons.info_rounded, color: Colors.tealAccent, size: 22),
                  const SizedBox(width: 12),
                  Expanded(child: Text(message, style: const TextStyle(color: Colors.white, fontSize: 14))),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').doc(widget.post.id).snapshots(),
      builder: (context, snapshot) {
        List<dynamic> likedBy = widget.post.likedBy;
        Map<String, dynamic>? rawData;

        if (snapshot.hasData && snapshot.data!.exists) {
          rawData = snapshot.data!.data() as Map<String, dynamic>;
          likedBy = rawData['likedBy'] is List ? rawData['likedBy'] : [];
        }

        bool isLikedByMe = false;
        if (_currentUser != null) {
          for (var item in likedBy) {
            if (item is Map && item['uid'] == _currentUser!.uid) { isLikedByMe = true; break; }
            if (item.toString() == _currentUser!.uid || item.toString() == _currentUser!.displayName) { isLikedByMe = true; break; }
          }
        }

        bool isSharedPost = rawData != null && rawData['isShared'] == true;
        String originalOwner = rawData?['originalPostOwner'] ?? "";
        String postOwnerId = rawData?['userId'] ?? widget.post.userId;
        bool isMyPost = _currentUser != null && postOwnerId == _currentUser!.uid;

        List<dynamic>? postImagesList;
        if (rawData != null && rawData['imageUrls'] is List) {
          postImagesList = rawData['imageUrls'] as List<dynamic>;
        }

        String? currentImgUrl = rawData?['imageUrl'] ?? widget.post.imageUrl;

        String likeText = "";
        if (likedBy.isNotEmpty) {
          var firstLikerElement = likedBy.first;
          String firstLiker = "အသုံးပြုသူ";
          if (firstLikerElement is Map) {
            firstLiker = firstLikerElement['name'] ?? "အသုံးပြုသူ";
          } else {
            firstLiker = firstLikerElement.toString();
          }

          if (likedBy.length == 1) {
            likeText = firstLiker;
          } else if (likedBy.length == 2) {
            likeText = "$firstLiker and ${likedBy.length - 1} other";
          } else {
            likeText = "$firstLiker and ${likedBy.length - 1} others";
          }
        }

        String origTitle = rawData?['originalTitle'] ?? widget.post.title;
        String origContent = rawData?['originalContent'] ?? widget.post.content;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(userId: postOwnerId)));
                        },
                        child: Row(
                          children: [
                            StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance.collection('users').doc(postOwnerId).snapshots(),
                              builder: (context, userSnapshot) {
                                String? userBase64;
                                if (userSnapshot.hasData && userSnapshot.data!.exists) {
                                  userBase64 = (userSnapshot.data!.data() as Map<String, dynamic>?)?['photoUrl'];
                                }
                                final imgProvider = _getAvatarImage(userBase64);
                                return CircleAvatar(
                                  radius: 18,
                                  backgroundColor: Colors.grey.shade200,
                                  backgroundImage: imgProvider,
                                  child: imgProvider == null ? const Icon(Icons.person, color: Colors.grey, size: 20) : null,
                                );
                              },
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isSharedPost ? "${rawData?['userName'] ?? widget.post.userName} က $originalOwner ၏ ပို့စ်ကို မျှဝေခဲ့သည်" : (rawData?['userName'] ?? widget.post.userName),
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black),
                                    softWrap: true,
                                  ),
                                  const Text("Just now • 🌐", style: TextStyle(color: Colors.grey, fontSize: 11)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    IconButton(icon: const Icon(Icons.more_vert, color: Colors.grey), onPressed: () => _showPostMenu(isMyPost)),
                  ],
                ),
                const SizedBox(height: 12),

                if (isSharedPost) ...[
                  if (rawData?['title'] != null && rawData!['title'].toString().isNotEmpty)
                    Text(rawData['title'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  if (rawData?['content'] != null && rawData!['content'].toString().isNotEmpty)
                    Padding(padding: const EdgeInsets.only(bottom: 8.0), child: Text(rawData['content'], style: const TextStyle(fontSize: 14))),
                  Container(
                    width: double.infinity, padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12), color: Colors.grey.shade50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(originalOwner, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.blueGrey)),
                        const SizedBox(height: 4),
                        if (origTitle.isNotEmpty) Text(origTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (origContent.isNotEmpty) Text(origContent, style: const TextStyle(fontSize: 14)),

                        Builder(
                          builder: (context) {
                            List<dynamic>? sharedImages;
                            if (rawData != null && rawData['originalImages'] is List) {
                              sharedImages = rawData['originalImages'] as List<dynamic>;
                            } else {
                              sharedImages = postImagesList;
                            }
                            return _buildPostImages(sharedImages, currentImgUrl);
                          },
                        ),
                      ],
                    ),
                  )
                ] else ...[
                  if (widget.post.title.isNotEmpty) Text(widget.post.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(widget.post.content, style: const TextStyle(fontSize: 14)),

                  _buildPostImages(postImagesList, currentImgUrl),
                ],

                const SizedBox(height: 10),
                if (likeText.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 4.0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4), decoration: const BoxDecoration(color: Color(0xFFE8F5E9), shape: BoxShape.circle),
                          child: const Icon(Icons.thumb_up_rounded, size: 13, color: Colors.green),
                        ),
                        const SizedBox(width: 6),
                        Text(likeText, style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],

                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      onPressed: _toggleLike,
                      icon: Icon(isLikedByMe ? Icons.thumb_up : Icons.thumb_up_outlined, color: isLikedByMe ? Colors.blue : Colors.grey),
                      label: const Text("Like"),
                    ),

                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(widget.post.id)
                          .collection('comments')
                          .snapshots(),
                      builder: (context, commentsSnapshot) {
                        if (!commentsSnapshot.hasData) {
                          return TextButton.icon(
                            onPressed: _showCommentSheet,
                            icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                            label: const Text("0 Comments"),
                          );
                        }

                        var mainComments = commentsSnapshot.data!.docs;
                        int totalCommentsAndRepliesCount = mainComments.length;

                        return FutureBuilder<List<int>>(
                          future: Future.wait(
                            mainComments.map((doc) async {
                              var replySnap = await doc.reference.collection('replies').get();
                              return replySnap.docs.length;
                            }),
                          ),
                          builder: (context, futureSnapshot) {
                            if (futureSnapshot.hasData) {
                              int repliesCount = futureSnapshot.data!.fold(0, (sum, count) => sum + count);
                              totalCommentsAndRepliesCount += repliesCount;
                            }

                            return TextButton.icon(
                              onPressed: _showCommentSheet,
                              icon: const Icon(Icons.chat_bubble_outline, color: Colors.grey),
                              label: Text("$totalCommentsAndRepliesCount Comments"),
                            );
                          },
                        );
                      },
                    ),

                    TextButton.icon(onPressed: _showShareBottomSheet, icon: const Icon(Icons.share, color: Colors.grey), label: const Text("Share")),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}