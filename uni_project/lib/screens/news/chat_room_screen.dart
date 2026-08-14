import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uni_project/screens/news/models/call_model.dart';
import 'package:uni_project/screens/news/services/call_service.dart';
import 'package:uni_project/screens/news/services/push_notification_service.dart';
import 'dart:async';
import 'services/social_service.dart';
import 'models/chat_model.dart';
import 'call_screen.dart';
import 'profile_screen.dart';

class ChatRoomScreen extends StatefulWidget {
  final String receiverId;
  final String receiverName;

  const ChatRoomScreen({
    super.key,
    required this.receiverId,
    required this.receiverName,
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final _messageController = TextEditingController();
  final SocialService _socialService = SocialService();
  final CallService _callService = CallService();
  String get _currentUserId => FirebaseAuth.instance.currentUser?.uid ?? '';
  final ImagePicker _picker = ImagePicker();

  ImageProvider? _getImageFromBase64(String? base64String) {    if (base64String != null && base64String.isNotEmpty) {
    try {
      if (!base64String.startsWith('blob:')) {
        return MemoryImage(base64Decode(base64String));
      }
    } catch (e) {
      debugPrint("Invalid base64 string: $e");
    }
  }
  return null;
  }

  Future<void> _startCall({required bool isVideo}) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('သင် Login မထားပါ။ ဖုန်းခေါ်ဆိုမရပါ။')),
        );
      }
      return;
    }

    final String roomId = _socialService.getChatRoomId(
      _currentUserId,
      widget.receiverId,
    );
    final String callId = DateTime.now().millisecondsSinceEpoch.toString();
    final call = CallModel(
      callId: callId,
      callerId: currentUser.uid,
      callerName: currentUser.displayName ?? 'Caller',
      callerPic: currentUser.photoURL ?? '',
      channelId: callId,
      hasDialed: true,
      isAccepted: false,
      isVideoCall: isVideo,
      receiverId: widget.receiverId,
      status: 'dialing',
      timestamp: Timestamp.now(),
    );

    final success = await _callService.makeCall(call: call);
    if (!success) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ဖုန်းခေါ်ဆိုမှု ဖန်တီးခြင်း မအောင်မြင်ပါ။'),
          ),
        );
      }
      return;
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(
            callDocId: widget.receiverId,
            channelId: callId,
            receiverName: widget.receiverName,
            receiverId: widget.receiverId,
            isVideoCall: isVideo,
          ),
        ),
      );
    }
  }

  void _send() {
    if (_messageController.text.trim().isNotEmpty) {
      _socialService.sendMessage(
        _currentUserId,
        widget.receiverId,
        _messageController.text.trim(),
      );
      _messageController.clear();
    }
  }

  Future<void> _pickAndSendImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 40,
        maxWidth: 800,
      );

      if (pickedFile == null) return;

      File file = File(pickedFile.path);
      List<int> imageBytes = await file.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      String roomId = _socialService.getChatRoomId(
        _currentUserId,
        widget.receiverId,
      );

      await FirebaseFirestore.instance
          .collection('chats')
          .doc(roomId)
          .collection('messages')
          .add({
        'senderId': _currentUserId,
        'receiverId': widget.receiverId,
        'message': base64Image,
        'type': 'image',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Error converting or uploading image: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ပုံပို့ခြင်း မအောင်မြင်ပါ: $e')),
        );
      }
    }
  }

  // 🛠️ စာသားပြင်ဆင်ရန်အတွက် Dialog Method
  Future<void> _editMessage(
      String messageId,
      String oldMessage,
      String roomId,
      ) async {
    final editController = TextEditingController(text: oldMessage);
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('စာသား ပြင်ဆင်ရန်'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(hintText: "စာသားအသစ် ထည့်ပါ..."),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              if (editController.text.trim().isNotEmpty) {
                final currentDialog = dialogContext;
                await FirebaseFirestore.instance
                    .collection('chats')
                    .doc(roomId)
                    .collection('messages')
                    .doc(messageId)
                    .update({'message': editController.text.trim()});
                if (currentDialog.mounted) Navigator.pop(currentDialog);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // 🗑️ စာသားဖျက်ရန်အတွက် Dialog Method
  Future<void> _deleteMessage(String messageId, String roomId) async {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('မက်ဆေ့ခ်ျ ဖျက်ရန်'),
        content: const Text('ဤမက်ဆေ့ခ်ျအား အပြီးတိုင် ဖျက်ဆီးလိုပါသလား?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () async {
              final currentDialog = dialogContext;
              await FirebaseFirestore.instance
                  .collection('chats')
                  .doc(roomId)
                  .collection('messages')
                  .doc(messageId)
                  .delete();
              if (currentDialog.mounted) Navigator.pop(currentDialog);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 📱 Long Press Options Dialog
  void _showMessageOptions(
      String messageId,
      String currentMessage,
      String messageType,
      bool isMe,
      String roomId,
      ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isMe && messageType == 'text')
                ListTile(
                  leading: const Icon(Icons.edit, color: Colors.blue),
                  title: const Text('ပြင်ဆင်ရန် (Edit)'),
                  onTap: () {
                    Navigator.pop(dialogContext);
                    _editMessage(messageId, currentMessage, roomId);
                  },
                ),
              if (isMe)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('ဖျက်ရန် (Delete)'),
                  onTap: () {
                    Navigator.pop(dialogContext);
                    _deleteMessage(messageId, roomId);
                  },
                ),
              if (!isMe)
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                    horizontal: 16.0,
                  ),
                  child: Text(
                    'ဤမက်ဆေ့ခ်ျအား ပြင်ဆင်/ဖျက်ဆီးခွင့်မရှိပါ',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String roomId = _socialService.getChatRoomId(
      _currentUserId,
      widget.receiverId,
    );

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.receiverId)
          .snapshots(),
      builder: (context, userSnapshot) {
        String? receiverPhotoUrl;
        bool isOnline = false;

        if (userSnapshot.hasData && userSnapshot.data!.exists) {
          var userData = userSnapshot.data!.data() as Map<String, dynamic>;
          receiverPhotoUrl = userData['photoUrl'];
          isOnline = userData['isOnline'] ?? false;
        }

        return Scaffold(
          backgroundColor: const Color(0xfff7f8fa),
          appBar: AppBar(
            backgroundColor: const Color(0xfff7f8fa),
            elevation: 0,
            leadingWidth: 40,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xff1a237e),
                size: 26,
              ),
              onPressed: () => Navigator.pop(context),
            ),
            title: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(userId: widget.receiverId),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 2.0,
                ),
                child: Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: receiverPhotoUrl == null
                              ? const Color(0xff1a237e)
                              : Colors.grey.shade200,
                          backgroundImage: _getImageFromBase64(
                            receiverPhotoUrl,
                          ),
                          child: receiverPhotoUrl == null
                              ? Text(
                            widget.receiverName.isNotEmpty
                                ? widget.receiverName[0]
                                : 'က',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                              : null,
                        ),
                        if (isOnline)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: const Color(0xff4caf50),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.receiverName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff1a237e),
                            ),
                          ),
                          Text(
                            isOnline ? "ယခု အသုံးပြုနေသည်" : "အော့ဖ်လိုင်း",
                            style: TextStyle(
                              fontSize: 12,
                              color: isOnline
                                  ? const Color(0xff4caf50)
                                  : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.phone, color: Color(0xff1a237e)),
                onPressed: () => _startCall(isVideo: false),
              ),
              IconButton(
                icon: const Icon(Icons.videocam, color: Color(0xff1a237e)),
                onPressed: () => _startCall(isVideo: true),
              ),
              IconButton(
                icon: const Icon(Icons.info, color: Color(0xff1a237e)),
                onPressed: () {},
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xffeceff1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Today",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .doc(roomId)
                      .collection('messages')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    var docs = snapshot.data!.docs;

                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        var doc = docs[index];
                        MessageModel msg = MessageModel.fromFirestore(doc);
                        bool isMe = msg.senderId == _currentUserId;

                        var rawData = doc.data() as Map<String, dynamic>;
                        String messageType = rawData['type'] ?? 'text';

                        return GestureDetector(
                          onLongPress: () => _showMessageOptions(
                            doc.id, // Firestore document ID ကို တိုက်ရိုက်ပေးပို့ပါတယ်
                            msg.message,
                            messageType,
                            isMe,
                            roomId,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 6.0),
                            child: Row(
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (!isMe) ...[
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: receiverPhotoUrl == null
                                        ? const Color(0xff1a237e)
                                        : Colors.grey.shade200,
                                    backgroundImage: _getImageFromBase64(
                                      receiverPhotoUrl,
                                    ),
                                    child: receiverPhotoUrl == null
                                        ? Text(
                                      widget.receiverName.isNotEmpty
                                          ? widget.receiverName[0]
                                          : 'က',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                        : null,
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                Flexible(
                                  child: Column(
                                    crossAxisAlignment: isMe
                                        ? CrossAxisAlignment.end
                                        : CrossAxisAlignment.start,
                                    children: [
                                      messageType == 'image'
                                          ? Container(
                                        constraints: const BoxConstraints(
                                          maxWidth: 240,
                                          maxHeight: 240,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(16),
                                          border: Border.all(
                                            color: Colors.grey.shade300,
                                          ),
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          child: Image.memory(
                                            base64Decode(msg.message),
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (
                                                context,
                                                error,
                                                stackTrace,
                                                ) => const Icon(
                                              Icons.broken_image,
                                              size: 50,
                                            ),
                                          ),
                                        ),
                                      )
                                          : Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isMe
                                              ? const Color(0xff0a196c)
                                              : Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft:
                                            const Radius.circular(16),
                                            topRight:
                                            const Radius.circular(16),
                                            bottomLeft: Radius.circular(
                                              isMe ? 16 : 4,
                                            ),
                                            bottomRight: Radius.circular(
                                              isMe ? 4 : 16,
                                            ),
                                          ),
                                          boxShadow: [
                                            const BoxShadow(
                                              color: Color.fromRGBO(0, 0, 0, 0.03),
                                              blurRadius: 4,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          msg.message,
                                          style: TextStyle(
                                            color: isMe
                                                ? Colors.white
                                                : Colors.black87,
                                            fontSize: 15,
                                            height: 1.3,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Builder(
                                            builder: (context) {
                                              String formattedTime = "";
                                              if (rawData['timestamp'] !=
                                                  null) {
                                                Timestamp timestamp =
                                                rawData['timestamp']
                                                as Timestamp;
                                                DateTime dateTime = timestamp
                                                    .toDate();
                                                formattedTime = DateFormat(
                                                  'hh:mm a',
                                                ).format(dateTime);
                                              } else {
                                                formattedTime = DateFormat(
                                                  'hh:mm a',
                                                ).format(DateTime.now());
                                              }

                                              return Text(
                                                formattedTime,
                                                style: TextStyle(
                                                  color: Colors.grey.shade500,
                                                  fontSize: 11,
                                                ),
                                              );
                                            },
                                          ),
                                          if (isMe) ...[
                                            const SizedBox(width: 4),
                                            Icon(
                                              Icons.done_all_rounded,
                                              size: 14,
                                              color: Colors.blue.shade400,
                                            ),
                                          ],
                                        ],
                                      ),
                                    ],
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
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: 12,
                  right: 12,
                  bottom: 16,
                  top: 8,
                ),
                color: const Color(0xfff7f8fa),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle,
                        color: Color(0xff455a64),
                        size: 28,
                      ),
                      onPressed: () {},
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xfff0f2f5),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.grey.shade300,
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                onSubmitted: (_) => _send(),
                                decoration: const InputDecoration(
                                  hintText: "Message...",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.camera_alt,
                                color: Colors.grey,
                                size: 22,
                              ),
                              onPressed: () =>
                                  _pickAndSendImage(ImageSource.camera),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 22,
                              ),
                              onPressed: () =>
                                  _pickAndSendImage(ImageSource.gallery),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _send,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: const BoxDecoration(
                          color: Color(0xff0a196c),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}