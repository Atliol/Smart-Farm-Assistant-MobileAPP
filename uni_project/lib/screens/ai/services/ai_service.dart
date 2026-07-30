import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:openrouter/openrouter.dart';

class AIService {
  static const String _apiKey = String.fromEnvironment(
    'OPENROUTER_API_KEY',
    defaultValue: '',
  );

  static const String _model = 'google/gemini-2.0-flash-exp:free';

  final OpenRouterClient _client = OpenRouterClient(
    apiKey: _apiKey,
    defaultHeaders: {
      'HTTP-Referer': 'https://github.com/flutter_app',
      'X-Title': 'Agriculture AI App',
    },
  );

  Future<String> sendMessage({
    required String userMessage,
    required List<Map<String, dynamic>> chatHistory,
    Uint8List? imageBytes,
  }) async {
    if (_apiKey.isEmpty || _apiKey.startsWith('YOUR_')) {
      return 'OpenRouter API key မရှိသေးပါ။ အက်ပလီကေးရှင်းကို --dart-define=OPENROUTER_API_KEY=your_key နဲ့ run လုပ်ပေးပါ။';
    }

    try {
      final messages = <Message>[
        Message.system(
          'You are a helpful AI assistant for agriculture. Always respond in natural and clear Myanmar (Burmese) language only.',
        ),
      ];

      for (final chat in chatHistory) {
        final role = _parseRole(chat['role']?.toString());
        final content = chat['content'];

        if (content == null || content.toString().trim().isEmpty) {
          continue;
        }

        messages.add(Message(role: role, content: content.toString()));
      }

      messages.add(_buildUserMessage(userMessage, imageBytes));

      final request = ChatRequest(
        model: _model,
        messages: messages,
        temperature: 0.7,
      );

      final response = await _client.chatCompletion(request);
      final reply = _extractText(response);

      return reply.isEmpty ? 'တောင်းပန်ပါတယ်၊ အဖြေမရှာဖွေနိုင်ပါ။' : reply;
    } catch (e) {
      debugPrint('AIService Exception: $e');
      return 'အင်တာနက် ချိတ်ဆက်မှုကို စစ်ဆေးပေးပါဗျာ။';
    }
  }

  MessageRole _parseRole(String? role) {
    switch (role?.toLowerCase()) {
      case 'assistant':
        return MessageRole.assistant;
      case 'system':
        return MessageRole.system;
      default:
        return MessageRole.user;
    }
  }

  Message _buildUserMessage(String userMessage, Uint8List? imageBytes) {
    if (imageBytes == null) {
      return Message.user(userMessage.isEmpty
          ? 'ဒီပုံကို ကြည့်ပြီး အသေးစိတ် ရှင်းပြပေးပါ'
          : userMessage);
    }

    final mimeType = _detectMimeType(imageBytes);
    final base64Image = base64Encode(imageBytes);

    return Message(
      role: MessageRole.user,
      content: [
        {
          'type': 'text',
          'text': userMessage.isEmpty
              ? 'ဒီပုံကို ကြည့်ပြီး အသေးစိတ် ရှင်းပြပေးပါ'
              : userMessage,
        },
        {
          'type': 'image_url',
          'image_url': {
            'url': 'data:$mimeType;base64,$base64Image',
            'detail': 'auto',
          },
          'detail': 'auto',
        },
      ],
    );
  }

  String _extractText(ChatResponse response) {
    final message = response.message;
    if (message == null) {
      return response.content ?? '';
    }

    final content = message.content;
    if (content is String) {
      return content.replaceAll('</think>', '').trim();
    }

    if (content is List) {
      final parts = <String>[];
      for (final item in content) {
        if (item is TextContentItem) {
          parts.add(item.text);
        } else if (item is ImageContentItem) {
          // ignore image items
        } else if (item is Map<String, dynamic>) {
          final text = item['text']?.toString();
          if (text != null && text.trim().isNotEmpty) {
            parts.add(text.trim());
          }
        }
      }
      return parts.join('\n').replaceAll('</think>', '').trim();
    }

    return response.content?.replaceAll('</think>', '').trim() ?? '';
  }

  String _detectMimeType(Uint8List bytes) {
    if (bytes.length >= 8 && bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47) {
      return 'image/png';
    }

    if (bytes.length >= 3 && bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return 'image/jpeg';
    }

    return 'image/jpeg';
  }
}
