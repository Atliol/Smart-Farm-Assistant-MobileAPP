import 'package:google_generative_ai/google_generative_ai.dart';

class GeminiService {
  // TODO: သင်ရလာတဲ့ API Key ကို ဒီနေရာမှာ ထည့်ပါ
  static const String _apiKey = "AQ.Ab8RN6ImBD_FJnCbXn_9eYfXPT4FQddcPhpahA0ISvE_zH3M0w";

  late final GenerativeModel _model;

  GeminiService() {
    // Gemini Model ကို ချိန်ညှိခြင်း (စာသားအမေးအဖြေအတွက် gemini-1.5-flash က အမြန်ဆုံးနဲ့ အသင့်တော်ဆုံးပါ)
    _model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _apiKey,
    );
  }

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
      return "Error ဖြစ်သွားပွားတယ်: $e";
    }
  }
}