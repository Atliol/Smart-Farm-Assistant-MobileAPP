import 'dart:convert'; 
import 'dart:io';
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isPosting = false;
  User? get _currentUser => FirebaseAuth.instance.currentUser;

  
  List<XFile> _pickedImages = [];
  final ImagePicker _picker = ImagePicker();

  
  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage(
        imageQuality: 20, 
        maxWidth: 400,
        maxHeight: 400,
      );

      if (images.isNotEmpty) {
        setState(() {
          
          _pickedImages.addAll(images);
        });
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
  }

  Future<void> _submitPost() async {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    if (content.isEmpty && _pickedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("အကြောင်းအရာ သို့မဟုတ် ဓာတ်ပုံ တစ်ခုခု ထည့်သွင်းပေးပါ")));
      return;
    }

    if (_currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ပို့စ်တင်ရန် လော့ဂ်အင်ဝင်ပါ")));
      return;
    }

    setState(() => _isPosting = true);

    
    List<String> base64ImagesList = [];

    try {
      
      for (var pickedImg in _pickedImages) {
        List<int> imageBytes = await pickedImg.readAsBytes();
        String base64Str = 'data:image/jpeg;base64,${base64Encode(imageBytes)}';
        base64ImagesList.add(base64Str);
      }

      
      await FirebaseFirestore.instance.collection('posts').add({
        'userId': _currentUser!.uid,
        'userName': _currentUser!.displayName ?? "အသုံးပြုသူ",
        'authorName': _currentUser!.displayName ?? "အသုံးပြုသူname",
        'title': title,
        'content': content,
        
        'imageUrl': base64ImagesList.isNotEmpty ? base64ImagesList.first : null,
        'imageUrls': base64ImagesList, 
        'commentsCount': 0,
        'likedBy': [],
        
        'createdAt': Timestamp.now(),
        'createdAtServer': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("ပို့စ်တင်ခြင်း အောင်မြင်ပါသည် 🎉")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _isPosting = false);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("ပို့စ်အသစ် ဖန်တီးမည်", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          TextButton(
            onPressed: _isPosting ? null : _submitPost,
            child: Text(
              "မျှဝေမည်",
              style: TextStyle(
                  color: _isPosting ? Colors.grey : const Color(0xFF1877F2),
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  enabled: !_isPosting,
                  decoration: const InputDecoration(
                    hintText: "ခေါင်းစဉ် (မထည့်လည်းရပါသည်)",
                    border: InputBorder.none,
                    hintStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    children: [
                      TextField(
                        controller: _contentController,
                        enabled: !_isPosting,
                        maxLines: null,
                        decoration: const InputDecoration(
                          hintText: "ယနေ့ ဘာတွေ တွေးတောနေပါသလဲ...",
                          border: InputBorder.none,
                        ),
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),

                      
                      if (_pickedImages.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _pickedImages.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3, 
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemBuilder: (context, index) {
                            final imageFile = _pickedImages[index];
                            return Stack(
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey.shade300),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: kIsWeb
                                        ? Image.network(imageFile.path, fit: BoxFit.cover)
                                        : Image.file(File(imageFile.path), fit: BoxFit.cover),
                                  ),
                                ),
                                if (!_isPosting)
                                  Positioned(
                                    right: 2,
                                    top: 2,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _pickedImages.removeAt(index); 
                                        });
                                      },
                                      child: const CircleAvatar(
                                        radius: 10,
                                        backgroundColor: Colors.black54, 
                                        child: Icon(Icons.close, size: 12, color: Colors.white),
                                      ),
                                    ),
                                  )
                              ],
                            );
                          },
                        ),
                    ],
                  ),
                ),
                const Divider(),

                ListTile(
                  leading: const Icon(Icons.photo_library, color: Colors.green),
                  title: const Text("ဓာတ်ပုံများ ထည့်သွင်းရန်"),
                  onTap: _isPosting ? null : _pickImages,
                ),
              ],
            ),
          ),

          if (_isPosting)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(width: 16),
                        Text("ပို့စ်တင်နေပါသည်...", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}