import 'package:flutter/material.dart';
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
  final GeminiService _geminiService = GeminiService();

  final List<Map<String, dynamic>> _messages = [];
  bool _isLoading = false;

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

  Future<void> _sendMessageToBackend(String text) async {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        "text": text,
        "isUser": true,
      });
      _isLoading = true;
    });

    _messageController.clear();
    _scrollToBottom();

    try {
      final aiReply = await _geminiService.askQuestion(text);

      setState(() {
        _messages.add({
          "text": aiReply,
          "isUser": false,
        });
      });
    } catch (e) {
      setState(() {
        _messages.add({
          "text": "Error: $e",
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
              // Header ပိုင်းနှင့် Chat List ပိုင်း
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: 1 + (_messages.isEmpty ? 4 : _messages.length) + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    // Index 0: Header (Farmer Profile & Welcome Text)
                    if (index == 0) {
                      return _buildHeader();
                    }

                    // မက်ဆေ့ခ်ျမရှိသေးရင် Suggestion Chips ပြမယ်
                    if (_messages.isEmpty) {
                      final suggestions = [
                        "Rice leaf turning yellow?",
                        "Best fertilizer for corn?",
                        "How to control insects?",
                        "Weather impact today?",
                      ];
                      final chipIndex = index - 1;
                      return SuggestionChip(
                        text: suggestions[chipIndex],
                        onTap: () => _sendMessageToBackend(suggestions[chipIndex]),
                      );
                    }

                    // မက်ဆေ့ခ်ျရှိရင် Chat Bubbles ပြမယ်
                    final messageIndex = index - 1;
                    if (messageIndex < _messages.length) {
                      return ChatBubble(
                        text: _messages[messageIndex]["text"],
                        isUser: _messages[messageIndex]["isUser"],
                      );
                    }

                    // Loading ပြစရာကျန်ရင် အောက်ဆုံးမှာ ပြမယ်
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

              // အောက်ခြေစာရိုက်သည့်အပိုင်း
              _buildInputArea(),
            ],
          ),
        ),
      ),
    );
  }

  // Header Widget ကို သီးသန့်ထုတ်ရေးထားခြင်းဖြစ်ပါတယ်
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
                "Hello Farmer!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "How can I help you today?",
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Input Area Widget
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
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              // TODO: Camera သို့မဟုတ် ပုံတင်မည့် Feature ထည့်ရန်
            },
            icon: const Icon(
              Icons.camera_alt,
              color: AppColors.primaryColor,
              size: 40,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Type your question...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              ),
              onSubmitted: _sendMessageToBackend,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => _sendMessageToBackend(_messageController.text),
            child: const CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.primaryColor,
              child: Icon(
                Icons.arrow_upward_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}