import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import '../../../constants/app_colors.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final Uint8List? imageBytes;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? AppColors.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(15).copyWith(
            bottomRight: isUser ? Radius.zero : const Radius.circular(15),
            bottomLeft: isUser ? const Radius.circular(15) : Radius.zero,
          ),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageBytes != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  imageBytes!,
                  fit: BoxFit.cover,
                ),
              ),
              if (text.isNotEmpty) const SizedBox(height: 8),
            ],
            if (text.isNotEmpty)
              isUser
                  ? Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white,
                  height: 1.4,
                ),
              )
                  : MarkdownBody(
                data: text,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  p: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  strong: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  listBullet: const TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                  ),
                  code: TextStyle(
                    backgroundColor: Colors.grey[300],
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}