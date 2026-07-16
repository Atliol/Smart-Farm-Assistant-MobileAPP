import 'package:flutter/material.dart';
import 'package:uni_project/screens/main_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uni_project/services/database_service.dart';
import 'firebase_options.dart';

void main() async {
  // 💡 Flutter Framework ရဲ့ Engine ကို အရင်ဆုံး အဆင်သင့်ဖြစ်အောင် လုပ်ခြင်း
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // 💡 ၁။ အမြန်ဆုံး အလုပ်လုပ်သည့် Offline Database (Hive) ကို အရင်နှိုးပါမည်
    await DatabaseService.initHive();

    // 💡 ၂။ ထို့နောက်မှ Online Firebase Database ကို နှိုးပါမည်
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    // Database နှိုးစဉ် တစုံတရာ မှားယွင်းခဲ့ပါက Debug Console ၌ မြင်နိုင်ရန်
    print("Initialization Error: $e");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shwe Lel Yar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00796B),
          primary: const Color(0xFF00796B),
        ),
      ),
      home: const MainWrapper(),
    );
  }
}