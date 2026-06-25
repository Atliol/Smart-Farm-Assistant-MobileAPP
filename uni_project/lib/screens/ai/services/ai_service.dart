import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // ⚠️ လုံခြုံရေးအရ ဤ API Key အား GitHub ပေါ်မတင်မီ အလွတ်ပြန်ပြောင်းရန် သတိပြုပါ
  static const String _apiKey = "AQ.Ab8RN6ImBD_FJnCbXn_9eYfXPT4FQddcPhpahA0ISvE_zH3M0w";

  // late final နေရာတွင် တစ်ခါတည်း Initialize လုပ်ရန် final ဟုပဲ ပြောင်းလဲလိုက်သည်
  final GenerativeModel _model;

  GeminiService() : _model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: _apiKey,
  );

  Future<String> askQuestion(String message) async {
    try {
      final content = [Content.text(message)];
      final response = await _model.generateContent(content);

      if (response.text != null) {
        return response.text!;
      } else {
        return "တောင်းပန်ပါတယ်၊ အဖြေမရှာဖွေနိုင်ပါဘူး။";
      }
    } catch (e) {
      return "Error ဖြစ်သွားပါတယ်: $e";
    }
  }
}