import 'dart:async'; // 👈 StreamSubscription သုံးရန် ထည့်သွင်းထားပါသည်
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'package:uni_project/screens/main_wrapper.dart';
import 'package:uni_project/services/database_service.dart';
import 'package:uni_project/services/hive_db_service.dart';
import 'package:uni_project/services/tracker_db_service.dart';

// Video Call & Notification Services
import 'package:uni_project/screens/news/services/call_service.dart';
import 'package:uni_project/screens/news/services/push_notification_service.dart';
import 'package:uni_project/screens/news/incoming_call_screen.dart';
import 'package:uni_project/screens/news/models/call_model.dart';

// Global Context မပါဘဲ Navigator သုံးနိုင်ရန် Global Key ထည့်သွင်းခြင်း
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final Set<String> _incomingCallRoutes = <String>{};

void _routeIncomingCall(Map<String, dynamic> data) {
  if (data['type'] != 'call') return;

  final callId = data['callId'] as String? ?? '';
  if (callId.isEmpty || _incomingCallRoutes.contains(callId)) return;

  _incomingCallRoutes.add(callId);
  final call = CallModel(
    callId: callId,
    callerId: data['callerId'] as String? ?? '',
    callerName: data['callerName'] as String? ?? 'Caller',
    callerPic: data['callerPic'] as String? ?? '',
    channelId: data['channelId'] as String? ?? '',
    hasDialed: false,
    isAccepted: false,
    isVideoCall: (data['callType'] as String?) == 'video',
    receiverId: data['receiverId'] as String? ?? '',
    status: 'dialing',
    timestamp: Timestamp.now(),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    navigatorKey.currentState
        ?.push(MaterialPageRoute(builder: (context) => IncomingCallScreen(call: call)))
        .then((_) => _incomingCallRoutes.remove(callId));
  });
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // ၁။ Offline Database (Hive) နှိုးခြင်း
    await TrackerDbService.init();
    await DatabaseService.initHive();
    
    // ၂။ Box ကို ဖွင့်လှစ်ခြင်း
    await HiveDbService.init();

    // ၃။ Firebase တည်ဆောက်ခြင်း
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    PushNotificationService.onNotificationOpened = _routeIncomingCall;

    // ၄။ Push Notification (FCM Token) ရယူခြင်း
    await PushNotificationService().initNotification();

  } catch (e) {
    debugPrint("Initialization Error: $e");
    final String errorMsg = e.toString();
    runApp(ErrorApp(errorMessage: errorMsg));
    return;
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CallService _callService = CallService();
  
  // 📞 Stream Subscriptions များကို ထိန်းချုပ်ရန် variable များ
  StreamSubscription<User?>? _authStateSubscription;
  StreamSubscription<QuerySnapshot>? _callSubscription;

  @override
  void initState() {
    super.initState();
    // App စဖွင့်သည်နှင့် Incoming Call ရှိမရှိ Listen စတင်ပြုလုပ်မည်
    _setupCallListener();
  }

  void _setupCallListener() {
    // လက်ရှိ ရှိနေခဲ့သော subscription အဟောင်းများရှိပါက အရင်ပိတ်ပါ
    _authStateSubscription?.cancel();
    
    // FirebaseAuth တွင် Current User ရှိမှသာ Listen လုပ်မည်
    _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen((user) {
      // User က Logout လုပ်သွားလျှင် Call Listen လုပ်နေမှုကို ရပ်တန့်မည်
      if (user == null) {
        _callSubscription?.cancel();
        _callSubscription = null;
        return;
      }

      // User အသစ်ဝင်လာပါက Call အဟောင်း Listeners များကို ရှင်းထုတ်ပြီး အသစ်ပြန်စမည်
      _callSubscription?.cancel();
      
      // QuerySnapshot ကို လက်ခံရရှိမှာ ဖြစ်တဲ့အတွက် docs ထဲက data တွေကို ပတ်စစ်ပါမယ်
      _callSubscription = _callService.listenToCall(user.uid).listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            if (doc.exists && doc.data() != null) {
              final data = doc.data() as Map<String, dynamic>;
              final call = CallModel.fromMap(data);

              // 'dialing' status ဖြင့် Call အသစ် ရောက်လာပါက Incoming Call Screen သို့ ပို့ပေးမည်
              if (call.status == 'dialing') {
                _routeIncomingCall(data);
                break; // Screen ပွင့်သွားရင် Loop ကို ရပ်လိုက်မယ်
              }
            }
          }
        }
      });
    });
  }

  @override
  void dispose() {
    // 🧹 App State သေဆုံးသွားပါက Stream အားလုံးကို Cancel လုပ်ပြီး Memory ရှင်းလင်းခြင်း
    _authStateSubscription?.cancel();
    _callSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shwe Lel Yar',
      navigatorKey: navigatorKey, // Global Navigator Key ကို တပ်ဆင်ခြင်း
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00796B),
          primary: const Color(0xFF00796B),
        ),
      ),
      home: const MainWrapper(initialIndex: 0),
    );
  }
}

class ErrorApp extends StatelessWidget {
  final String errorMessage;
  const ErrorApp({super.key, required this.errorMessage});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Initialization Error',
      home: Scaffold(
        backgroundColor: Colors.red.shade700,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  'Initialization Error',
                  style: TextStyle(color: Colors.yellow, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(errorMessage, style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}