import 'package:flutter/material.dart';

import '../../../constants/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(15).copyWith(
            bottomRight: isUser ? Radius.zero : const Radius.circular(15),
            bottomLeft: isUser ? const Radius.circular(15) : Radius.zero,
          ),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Text(
          text,
          style: isUser ? TextStyle(fontSize: 15, color: Colors.white) : TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
    );
  }
}