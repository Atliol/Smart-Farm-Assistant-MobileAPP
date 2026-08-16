import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class AIService {
  // ============================================================
  // Node.js Backend URL
  // ============================================================

  static const String _baseUrl =
      'http://10.0.2.2:3000';

  // ============================================================
  // Send Message
  // ============================================================

  Future<String> sendMessage({
    required String userMessage,
    required List<Map<String, dynamic>> chatHistory,
    Uint8List? imageBytes,
  }) async {
    try {
      String? imageBase64;

      // ========================================================
      // Convert Image → Base64
      // ========================================================

      if (imageBytes != null) {
        imageBase64 = base64Encode(imageBytes);
      }

      // ========================================================
      // Request Body
      // ========================================================

      final Map<String, dynamic> requestBody = {
        'userMessage': userMessage,
        'chatHistory': chatHistory,
        'imageBase64': imageBase64,
      };

      // ========================================================
      // Send Request → Node.js
      // ========================================================

      final response = await http.post(
        Uri.parse('$_baseUrl/api/ai/chat'),

        headers: {
          'Content-Type': 'application/json',
        },

        body: jsonEncode(requestBody),
      );

      // ========================================================
      // Debug
      // ========================================================

      print('====================================');
      print('Backend Status: ${response.statusCode}');
      print('Backend Response: ${response.body}');
      print('====================================');

      // ========================================================
      // Success
      // ========================================================

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        if (data['success'] != true) {
          throw Exception(
            data['message'] ??
                'AI response မရရှိပါ။',
          );
        }

        final answer = data['answer'];

        if (answer == null) {
          throw Exception(
            'AI response content မရှိပါ။',
          );
        }

        return answer.toString().trim();
      }

      // ========================================================
      // Backend Error
      // ========================================================

      String errorMessage =
          'Backend Error (${response.statusCode})';

      try {
        final Map<String, dynamic> data =
        jsonDecode(
          utf8.decode(response.bodyBytes),
        );

        errorMessage =
            data['message']?.toString() ??
                errorMessage;
      } catch (_) {}

      throw Exception(errorMessage);
    } catch (e) {
      print('AI Service Error: $e');

      throw Exception(
        'AI ချိတ်ဆက်ရာတွင် အမှားရှိနေပါသည်။\n$e',
      );
    }
  }
}