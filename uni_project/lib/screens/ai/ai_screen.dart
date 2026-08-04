import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uni_project/widgets/app_background.dart';

import '../../constants/app_colors.dart';
import 'services/ai_service.dart';
import 'widgets/chat_bubble.dart';
import 'widgets/suggestion_chip.dart';

class AiScreen extends StatefulWidget {
  const AiScreen({super.key});

  @override
  State<AiScreen> createState() => _AiScreenState();
}

class _AiScreenState extends State<AiScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final AIService _aiService = AIService();
  final ImagePicker _picker = ImagePicker();

  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

  Uint8List? _selectedImageBytes;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );
      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
        });
      }
    } catch (e) {
      debugPrint("Image Picker Error: $e");
    }
  }

  void _showImageSourceBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library, color: AppColors.primaryColor),
                title: const Text('ဓာတ်ပုံအယ်လ်ဘမ်မှ ရွေးရန်'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.primaryColor),
                title: const Text('ဓာတ်ပုံ ရိုက်ယူရန်'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getChatHistory() {
    List<Map<String, dynamic>> history = [];
    for (var msg in _messages) {
      history.add({
        "role": msg["isUser"] == true ? "user" : "assistant",
        "content": msg["text"].toString(),
      });
    }
    return history;
  }

  Future<void> _sendMessageToBackend(String text) async {
    if ((text.trim().isEmpty && _selectedImageBytes == null) || _isLoading) return;

    final userMessage = text.trim();
    final imageToSend = _selectedImageBytes;

    setState(() {
      _messages.add({
        "text": userMessage,
        "isUser": true,
        "imageBytes": imageToSend,
      });
      _isLoading = true;
      _selectedImageBytes = null;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final chatHistory = _getChatHistory();
      final aiReply = await _aiService.sendMessage(
        userMessage: userMessage,
        chatHistory: chatHistory,
        imageBytes: imageToSend,
      );

      setState(() {
        _messages.add({
          "text": aiReply,
          "isUser": false,
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({
          "text": "အကြောင်းပြန်ရာတွင် အမှားတစ်ခု ရှိနေပါသည်: $e",
          "isUser": false,
        });
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: AppBackground(
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: 1 + (_messages.isEmpty ? 4 : _messages.length) + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _buildHeader();
                    }

                    if (_messages.isEmpty) {
                      final suggestions = [
                        "စပါးရွက်တွေ ဝါနေရင် ဘာလုပ်ရမလဲ?",
                        "ပြောင်းဖူးစိုက်ပျိုးရေးအတွက် အကောင်းဆုံး မြေသြဇာက ဘာလဲ?",
                        "ပိုးမွှားတွေကို ဘယ်လို ကာကွယ်ရမလဲ?",
                        "စပျစ်ဘယ်လိုစိုက်ရမလဲ?",
                      ];
                      final chipIndex = index - 1;
                      return SuggestionChip(
                        text: suggestions[chipIndex],
                        onTap: () => _sendMessageToBackend(suggestions[chipIndex]),
                      );
                    }

                    final messageIndex = index - 1;
                    if (messageIndex < _messages.length) {
                      return ChatBubble(
                        text: _messages[messageIndex]["text"],
                        isUser: _messages[messageIndex]["isUser"],
                        imageBytes: _messages[messageIndex]["imageBytes"],
                      );
                    }

                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
                        ),
                      ),
                    );
                  },
                ),
              ),
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          const Icon(
            Icons.psychology,
            size: 65,
            color: AppColors.primaryColor,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "မင်္ဂလာပါ တောင်သူဦးကြီး!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "ဒီနေ့ ဘာများ ကူညီပေးရမလဲခင်ဗျာ?",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedImageBytes != null)
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              alignment: Alignment.centerLeft,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      _selectedImageBytes!,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedImageBytes = null;
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Row(
            children: [
              IconButton(
                onPressed: _showImageSourceBottomSheet,
                icon: const Icon(
                  Icons.camera_alt,
                  color: AppColors.primaryColor,
                  size: 30,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  enabled: !_isLoading,
                  decoration: InputDecoration(
                    hintText: "သိလိုသည်များကို မေးမြန်းပါ...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                  onSubmitted: (val) => _sendMessageToBackend(val),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => _sendMessageToBackend(_messageController.text),
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: _isLoading ? Colors.grey : AppColors.primaryColor,
                  child: const Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}