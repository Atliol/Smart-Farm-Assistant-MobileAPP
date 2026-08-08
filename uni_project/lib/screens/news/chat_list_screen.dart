import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final String _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
  
  bool _isSearching = false;
  String _searchQuery = "";
  final TextEditingController _searchController = TextEditingController();

  ImageProvider? _getProfileImage(String? base64String) {
    if (base64String != null && base64String.isNotEmpty) {
      try {
        if (!base64String.startsWith('blob:')) {
          return MemoryImage(base64Decode(base64String));
        }
      } catch (e) {
        print("Invalid base64 string: $e");
      }
    }
    return null;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1e1e1e),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
           
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 12.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black87, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _isSearching
                          ? TextField(
                              controller: _searchController,
                              autofocus: true,
                              decoration: const InputDecoration(
                                hintText: "ရှာဖွေရန်...",
                                border: InputBorder.none,
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                              style: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value.trim().toLowerCase();
                                });
                              },
                            )
                          : const Text(
                              "Messages",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Colors.black87,
                              ),
                            ),
                    ),
                    IconButton(
                      icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.black87, size: 26),
                      onPressed: () {
                        setState(() {
                          if (_isSearching) {
                            _isSearching = false;
                            _searchQuery = "";
                            _searchController.clear();
                          } else {
                            _isSearching = true;
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              if (!_isSearching) _buildRealTimeActiveUsers(),
              
              if (!_isSearching) const SizedBox(height: 10),

              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('chats')
                      .where('participants', arrayContains: _currentUserId)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(child: Text("အချက်အလက်ဆွဲရယူရာတွင် အမှားအယွင်းရှိနေပါသည်ဗျာ။"));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          "စကားပြောခန်းများ မရှိသေးပါ၊၊\nပရိုဖိုင်မှတစ်ဆင့် Message ပို့နိုင်ပါတယ်ဗျာ။",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, height: 1.5),
                        ),
                      );
                    }

                    List<QueryDocumentSnapshot> rooms = List.from(snapshot.data!.docs);
                    rooms.sort((a, b) {
                      var aData = a.data() as Map<String, dynamic>;
                      var bData = b.data() as Map<String, dynamic>;
                      Timestamp? aTime = aData['lastUpdated'] as Timestamp?;
                      Timestamp? bTime = bData['lastUpdated'] as Timestamp?;
                      if (aTime == null || bTime == null) return 0;
                      return bTime.compareTo(aTime);
                    });

                    return ListView.separated(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: rooms.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 0.5,
                        indent: 86,
                        color: Colors.black12,
                      ),
                      itemBuilder: (context, index) {
                        var roomData = rooms[index].data() as Map<String, dynamic>;
                        List participants = roomData['participants'] ?? [];
                        
                        String targetUserId = participants.firstWhere(
                          (id) => id != _currentUserId,
                          orElse: () => '',
                        );

                        if (targetUserId.isEmpty) return const SizedBox.shrink();

                        return FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('users').doc(targetUserId).get(),
                          builder: (context, userSnapshot) {
                            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                              return const SizedBox.shrink();
                            }

                            var userData = userSnapshot.data!.data() as Map<String, dynamic>;
                            String targetName = userData['displayName'] ?? (userData['name'] ?? 'အသုံးပြုသူ');
                            String? targetPhoto = userData['photoUrl'];
                            String lastMessage = roomData['lastMessage'] ?? 'စာတို ပေးပို့ထားပါသည်';
                            bool isOnline = userData['isOnline'] ?? false;

                            if (_isSearching && _searchQuery.isNotEmpty) {
                              if (!targetName.toLowerCase().contains(_searchQuery)) {
                                return const SizedBox.shrink();
                              }
                            }

                            String displayTime = "ယခုလေးတင်";
                            Timestamp? lastUpdated = roomData['lastUpdated'] as Timestamp?;
                            if (lastUpdated != null) {
                              final diff = DateTime.now().difference(lastUpdated.toDate());
                              if (diff.inMinutes < 1) {
                                  displayTime = "ယခုတင်";
                              } else if (diff.inMinutes < 60) {
                                displayTime = "${diff.inMinutes} မိနစ်";
                              } else if (diff.inHours < 24) {
                                displayTime = "${diff.inHours} နာရီ";
                              } else {
                                displayTime = "${diff.inDays} ရက်";
                              }
                            }
                            
                            bool isUnread = false;
                            if(roomData['lastSenderId'] != _currentUserId && roomData['isRead'] == false) {
                              isUnread = true;
                            }

                            return ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                              // 🛠️ ဒီနေရာမှာ ဒေါင်လိုက် List ရဲ့ leading ကို Stack နဲ့ ပြင်ဆင်ပြီး Ring လိုင်း ထည့်ပေးလိုက်ပါတယ်
                              leading: Stack(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2.5), // Ring နဲ့ ပုံကြား အကွာအဝေး
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      // အွန်လိုင်းဖြစ်နေရင် အစိမ်းရောင် Ring ပတ်မယ်၊ မဖြစ်ရင် transparent ဖြစ်နေမယ်
                                      border: Border.all(
                                        color: isOnline ? const Color(0xff4caf50) : Colors.transparent,
                                        width: 2,
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 26,
                                      backgroundColor: targetPhoto == null ? const Color(0xff1a237e) : Colors.grey.shade200,
                                      backgroundImage: _getProfileImage(targetPhoto),
                                      child: _getProfileImage(targetPhoto) == null
                                          ? Text(
                                              targetName.isNotEmpty ? targetName[0] : 'က',
                                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                                            )
                                          : null,
                                    ),
                                  ),
                                  if (isOnline)
                                    Positioned(
                                      right: 2,
                                      bottom: 2,
                                      child: Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          color: const Color(0xff2e7d32),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              title: Text(
                                targetName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  lastMessage,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isUnread ? Colors.black87 : Colors.grey.shade600,
                                    fontSize: 15,
                                    fontWeight: isUnread ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    displayTime,
                                    style: TextStyle(
                                      color: isUnread ? const Color(0xff0d47a1) : Colors.grey.shade600,
                                      fontSize: 13,
                                      fontWeight: isUnread ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (isUnread)
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff0d47a1),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                ],
                              ),
                              onTap: () {
                                FirebaseFirestore.instance
                                    .collection('chats')
                                    .doc(rooms[index].id)
                                    .update({'isRead': true});

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatRoomScreen(
                                      receiverId: targetUserId,
                                      receiverName: targetName,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
Widget _buildRealTimeActiveUsers() {
  return StreamBuilder<QuerySnapshot>(
    // 1. users collection ထဲက user အားလုံးကို ယူမယ် (online ဖြစ်ဖြစ် offline ဖြစ်ဖြစ်)
    stream: FirebaseFirestore.instance
        .collection('users')
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const SizedBox(
          height: 115,
          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
        );
      }

      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
        return const SizedBox.shrink(); // User လုံးဝမရှိရင် ဘာမှမပြဘူး
      }

      // လက်ရှိ Login ဝင်ထားတဲ့ User ကို ဖယ်ထုတ်ပြီး ကျန်တဲ့သူတွေကို List လုပ်မယ်
      List<QueryDocumentSnapshot> allUsers = snapshot.data!.docs
          .where((doc) => doc.id != _currentUserId)
          .toList();

      if (allUsers.isEmpty) {
        return const SizedBox.shrink(); // ကိုယ်တစ်ယောက်ပဲရှိရင် ဘာမှမပြဘူး
      }

      return SizedBox(
        height: 115,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          itemCount: allUsers.length,
          itemBuilder: (context, index) {
            var userData = allUsers[index].data() as Map<String, dynamic>;
            String name = userData['displayName'] ?? (userData['name'] ?? 'အသုံးပြုသူ');
            String? photoUrl = userData['photoUrl'];
            String userId = allUsers[index].id;
            
            // 2. User ရဲ့ Online Status ကို စစ်ဆေးမယ် (မပါရင် false လို့ ယူဆမယ်)
            bool isUserOnline = userData['isOnline'] == true;

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatRoomScreen(
                      receiverId: userId,
                      receiverName: name,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            // 3. Online ဖြစ်ရင် အစိမ်းရောင် Ring ပြပြီး၊ Offline ဖြစ်ရင် Ring ဖျောက်ထားမယ် (သို့မဟုတ် transparent ပေးမယ်)
                            border: Border.all(
                              color: isUserOnline ? const Color(0xff4caf50) : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: CircleAvatar(
                            radius: 28,
                            backgroundColor: photoUrl == null ? const Color(0xff1a237e) : Colors.grey.shade200,
                            backgroundImage: _getProfileImage(photoUrl),
                            child: _getProfileImage(photoUrl) == null
                                ? Text(
                                    name.isNotEmpty ? name[0] : 'က',
                                    style: const TextStyle(
                                      color: Colors.white, 
                                      fontSize: 20, 
                                      fontWeight: FontWeight.bold
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        // 4. အစိမ်းရောင် အစက်လေး (Dot) ကိုပါ Ring နဲ့အတူ တွဲပြီး ပေါ်/မပေါ် လုပ်ချင်ရင်-
                        if (isUserOnline)
                          Positioned(
                            right: 4,
                            bottom: 4,
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: const Color(0xff2e7d32),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(height: 6),
                    SizedBox(
                      width: 70,
                      child: Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14, 
                          fontWeight: FontWeight.w500,
                          color: Color(0xff5d4037),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      );
    },
  );
}
}