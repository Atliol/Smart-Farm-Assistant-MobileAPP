import 'package:flutter/material.dart';
import 'package:uni_project/screens/main_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:uni_project/services/database_service.dart';
import 'firebase_options.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uni_project/services/hive_db_service.dart';

// 💡 နာမည်တူနေလို့ Flutter မရောအောင် 'as' သုံးပြီး နာမည်ခွဲပေးလိုက်ခြင်း
import 'package:uni_project/services/notification_service.dart' as online_notif;
import 'package:uni_project/services/notifications_service.dart' as local_notif;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ၁။ Offline Database (Hive) နှိုးခြင်း
    await DatabaseService.initHive();

    // 💡 မှတ်ချက်။ ။ ကျွန်တော်တို့သည် toMap()/fromMap() စနစ်ကို သုံးနေသည့်အတွက်
    // Adapter များ register လုပ်ရန် မလိုပါ။ ထို့ကြောင့် အဆိုပါ Code အပိုင်းကို ဖယ်ရှားလိုက်ပါသည်။

    // ၂။ Box ကို ဖွင့်လှစ်ခြင်း
    await HiveDbService.init();

    // ၃။ Notification နှင့် Firebase နှိုးခြင်း
    await local_notif.NotificationService.init();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

  } catch (e) {
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