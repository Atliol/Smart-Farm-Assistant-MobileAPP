import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'models/post_model.dart';
import 'widgets/post_card.dart';
import 'package:uni_project/screens/main_wrapper.dart';
import 'services/social_service.dart'; 
import 'chat_room_screen.dart'; 

class ProfileScreen extends StatefulWidget {
  final String userId;

  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  final SocialService _socialService = SocialService(); 

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isEditing = false;

  String? _profileBase64String;
  int _postCount = 0; 

  User? get _currentUser => FirebaseAuth.instance.currentUser;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('users').doc(widget.userId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        _nameController.text = data['displayName'] ?? (data['name'] ?? '');
        _bioController.text = data['bio'] ?? '';
        _locationController.text = data['location'] ?? '';
        _profileBase64String = data['photoUrl'];
      } else {
        if (widget.userId == _currentUser?.uid) {
          _nameController.text = _currentUser!.displayName ?? '';
        } else {
          _nameController.text = 'အသုံးပြုသူ';
        }
      }

      QuerySnapshot postSnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: widget.userId)
          .get();
      
      setState(() {
        _postCount = postSnapshot.docs.length;
      });

    } catch (e) {
      print("Error loading profile or post count: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

      if (image != null) {
        setState(() => _isLoading = true);
        List<int> imageBytes = await image.readAsBytes();
        String base64Image = base64Encode(imageBytes);

        if (_currentUser != null) {
          await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).set({
            'photoUrl': base64Image,
          }, SetOptions(merge: true));

          setState(() {
            _profileBase64String = base64Image;
          });

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('ပရိုဖိုင်ပုံကို အောင်မြင်စွာ ပြောင်းလဲပြီးပါပြီဗျာ။')),
            );
          }
        }
      }
    } catch (e) {
      print("Error picking/converting image: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.trim().isEmpty || _currentUser == null) return;
    setState(() => _isSaving = true);
    try {
      await _currentUser?.updateDisplayName(_nameController.text.trim());
      await FirebaseFirestore.instance.collection('users').doc(_currentUser!.uid).set({
        'displayName': _nameController.text.trim(),
        'name': _nameController.text.trim(),
        'bio': _bioController.text.trim(),
        'location': _locationController.text.trim(),
      }, SetOptions(merge: true));
      setState(() => _isEditing = false);
    } catch (e) { print(e); }
    finally { setState(() => _isSaving = false); }
  }

  Future<void> _handleLogout() async {
    try {
      await FirebaseAuth.instance.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const MainWrapper(initialIndex: 4)),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) { print("Logout Error: $e"); }
  }

  ImageProvider? _getProfileImage() {
    if (_profileBase64String != null && _profileBase64String!.isNotEmpty) {
      try {
        if (!_profileBase64String!.startsWith('blob:')) {
          return MemoryImage(base64Decode(_profileBase64String!));
        }
      } catch (e) { print("Invalid base64 string: $e"); }
    }
    return null;
  }

  Widget _buildStatItem(String count, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isMyProfile = (_currentUser != null && widget.userId == _currentUser!.uid);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(
            _isEditing
                ? "ပရိုဖိုင် ပြင်ဆင်ရန်"
                : (isMyProfile ? "ကျွန်ုပ်၏ ကိုယ်ရေးအကျဉ်း" : "${_nameController.text} ၏ ပရိုဖိုင်"),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (isMyProfile) ...[
            IconButton(
              icon: Icon(_isEditing ? Icons.save : Icons.edit_note_rounded, size: 28),
              onPressed: _isEditing ? _saveProfile : () => setState(() => _isEditing = true),
            ),
            IconButton(
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("အကောင့်ထွက်ရန်"),
                    content: const Text("အကောင့်ထဲမှ သေချာပေါက် ထွက်လိုပါသလားဗျာ။"),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text("မထွက်တော့ပါ", style: TextStyle(color: Colors.grey))),
                      TextButton(onPressed: _handleLogout, child: const Text("ထွက်မည်", style: TextStyle(color: Colors.red))),
                    ],
                  ),
                );
              },
            ),
          ]
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 16),
            child: Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _getProfileImage(),
                        child: _getProfileImage() == null
                            ? const Icon(Icons.person_rounded, size: 55, color: Colors.grey)
                            : null,
                      ),
                      if (isMyProfile)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: _pickProfileImage,
                            child: const CircleAvatar(
                              radius: 15,
                              backgroundColor: Colors.teal,
                              child: Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (!_isEditing) ...[
                  Text(_nameController.text, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  if (_locationController.text.isNotEmpty)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.location_on, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Text(_locationController.text, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      ],
                    ),
                  if (_bioController.text.isNotEmpty) 
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), 
                      child: Text(_bioController.text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 15))
                    ),
                  
                  const SizedBox(height: 16),
                  
                  
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(child: _buildStatItem("$_postCount", "Posts")),
                        Container(height: 30, width: 1, color: Colors.grey.shade300), 
                        
                        
                        Expanded(
                          child: StreamBuilder<int>(
                            stream: _socialService.getCount(widget.userId, 'followers'),
                            builder: (context, snapshot) => _buildStatItem("${snapshot.data ?? 0}", "Friends"),
                          ),
                        ),
                        Container(height: 30, width: 1, color: Colors.grey.shade300), 
                        
                        
                        Expanded(
                          child: StreamBuilder<int>(
                            stream: _socialService.getCount(widget.userId, 'following'),
                            builder: (context, snapshot) => _buildStatItem("${snapshot.data ?? 0}", "Following"),
                          ),
                        ),
                      ],
                    ),
                  ),

                  
                  if (!isMyProfile && _currentUser != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        StreamBuilder<bool>(
                          stream: _socialService.isFollowing(_currentUser!.uid, widget.userId),
                          builder: (context, snapshot) {
                            bool isFollowing = snapshot.data ?? false;
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isFollowing ? Colors.grey.shade300 : Colors.blue.shade800,
                                foregroundColor: isFollowing ? Colors.black : Colors.white,
                                minimumSize: const Size(120, 38),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              onPressed: () => _socialService.toggleFollow(_currentUser!.uid, widget.userId, isFollowing),
                              child: Text(isFollowing ? "Unfollow" : "Follow"),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(120, 38),
                            side: BorderSide(color: Colors.blue.shade800),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatRoomScreen(
                                  receiverId: widget.userId,
                                  receiverName: _nameController.text,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.message_rounded, size: 18),
                          label: const Text("Message"),
                        ),
                      ],
                    ),
                  ],
                ] else ...[
                  TextField(controller: _nameController, decoration: const InputDecoration(labelText: "အမည်")),
                  TextField(controller: _locationController, decoration: const InputDecoration(labelText: "နေရပ်")),
                  TextField(controller: _bioController, decoration: const InputDecoration(labelText: "Bio")),
                  TextButton(onPressed: () => setState(() => _isEditing = false), child: const Text("Cancel")),
                ]
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 12, bottom: 4),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                    isMyProfile ? "ကျွန်ုပ်၏ ပို့စ်များနှင့် မျှဝေမှုများ" : "${_nameController.text} ၏ ပို့စ်များ",
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)
                ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('userId', isEqualTo: widget.userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator());
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) return const Center(child: Text("မျှဝေထားသော ပို့စ်များ မရှိသေးပါ၊၊"));

                var docs = snapshot.data!.docs;
                docs.sort((a, b) {
                  var aTime = (a.data() as Map)['createdAt'] as Timestamp?;
                  var bTime = (b.data() as Map)['createdAt'] as Timestamp?;
                  if (aTime == null) return 1;
                  if (bTime == null) return -1;
                  return bTime.compareTo(aTime);
                });

                List<PostModel> myTimelinePosts = docs.map((doc) => PostModel.fromFirestore(doc)).toList();

                return ListView.builder(
                  itemCount: myTimelinePosts.length,
                  itemBuilder: (context, index) => PostCard(post: myTimelinePosts[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}