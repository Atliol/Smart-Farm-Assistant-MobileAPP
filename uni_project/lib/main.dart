import 'dart:async';
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

  // ၁။ Offline Database (Hive) များ စတင်နှိုးခြင်း (ဒီအဆင့် မပျက်စီးရပါ)
  try {
    await TrackerDbService.init();
    await DatabaseService.initHive();
    await HiveDbService.init();
  } catch (e) {
    debugPrint("Local DB Initialization Error: $e");
    // Local DB တောင် ပွင့်မရပါကမှ ErrorApp ပြမည်
    runApp(ErrorApp(errorMessage: "Local Storage Error: $e"));
    return;
  }

  // ၂။ Firebase နှင့် Push Notification (Internet မရှိလည်း App ပွင့်စေရန် သီးသန့် try-catch ထားခြင်း)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Cloud Firestore အတွက် Offline Persistence ကို စနစ်တကျ ဖွင့်ထားပေးခြင်း
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    PushNotificationService.onNotificationOpened = _routeIncomingCall;

    // Push Notification Service ကို သီးသန့် try-catch စစ်ခြင်း
    try {
      await PushNotificationService().initNotification();
    } catch (e) {
      debugPrint("Push Notification Init Failed (Possibly Offline): $e");
    }
  } catch (e) {
    // Firebase Initialize မဖြစ်သွားခဲ့ရင်တောင် (ဥပမာ အော့ဖ်လိုင်း ဖြစ်နေ၍) App ကို ပိတ်မသွားစေဘဲ Log သာ ထုတ်မည်
    debugPrint("Firebase Initialization Warning (Offline Mode Active): $e");
  }

  // အော့ဖ်လိုင်းဖြစ်နေလည်း မူလ App ကို ပုံမှန်အတိုင်း Run မည်
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
    _setupCallListener();
  }

  void _setupCallListener() {
    _authStateSubscription?.cancel();

    try {
      _authStateSubscription = FirebaseAuth.instance.authStateChanges().listen(
            (user) {
          if (user == null) {
            _callSubscription?.cancel();
            _callSubscription = null;
            return;
          }

          _callSubscription?.cancel();

          // Firestore Listener တွင် error handle လုပ်ရန် onError ထည့်သွင်းထားပါသည်
          _callSubscription = _callService.listenToCall(user.uid).listen(
                (snapshot) {
              if (snapshot.docs.isNotEmpty) {
                for (var doc in snapshot.docs) {
                  if (doc.exists && doc.data() != null) {
                    final data = doc.data() as Map<String, dynamic>;
                    final call = CallModel.fromMap(data);

                    if (call.status == 'dialing') {
                      _routeIncomingCall(data);
                      break;
                    }
                  }
                }
              }
            },
            onError: (error) {
              // Internet မရှိသည့်အခါ သို့မဟုတ် Connection ဖြတ်တောက်ချိန်တွင် တက်လာသည့် Error ကို ယာယီ ငြိမ်စေရန်
              debugPrint("Call Listener Error (Offline Mode): $error");
            },
          );
        },
        onError: (error) {
          debugPrint("Auth State Error: $error");
        },
      );
    } catch (e) {
      debugPrint("Error setting up Firebase listeners: $e");
    }
  }

  @override
  void dispose() {
    _authStateSubscription?.cancel();
    _callSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shwe Lel Yar',
      navigatorKey: navigatorKey,
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