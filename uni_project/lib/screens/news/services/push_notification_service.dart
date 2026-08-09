import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('FCM background message: ${message.messageId}');
}

class PushNotificationService {
  static Function(Map<String, dynamic>)? onNotificationOpened;
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? _currentToken;

  static const Map<String, dynamic> _serviceAccountCredentials = {
    "type": "service_account",
    "project_id": "smartfarmassistant",
    "private_key_id": "9f7ede1e3010bdc1dde0b0cbac038673b0837b86",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC0UiUdqpJAQYMu\nNLk14ODLRk1qBlDks64mxCEL2JUF2PCsqhauBc8a4R2SdyEaTJF0XI0hqCcRDwSF\nVcFs+BDvBNAV1KbW8zxnDgjmHEKOnJrE/O+QaHdgqUbcdI6q96/RlitybaghoM8u\nuDTUVBwi0Saos70yIVEGP/Dlhqb9tX2cuAEP3Y0Dg6p/QfLUbadrrsnk2DgEM80n\ntmedfXCS+Cq14CmEueufdVwdclhdsks8bj6ijmqOV7IwGmz/hRxDvPc+QSIRBaU5\n/gBqLAW16iLqLrSS5eOwaO9i4TCDPuUMXkeAzRtBG6VqV5enhfOoCkxRK0VAbh7/\nwMAexgZvAgMBAAECggEABauzqRwtH0IwKurTjEM3Lo1Wb+gk8RxJdMSkOWglP5rT\n7somjnB2U+USdgGzE82moV8rvQw5tkqfnMXWoGOovKuNE7KtUIMzuhXx57Kp0SxR\nnbJKomL2ph6MsPAlcHD7oX60fRO/vtb8zP5UAv1mKR4kthd48rOjhavLGpzCcaYO\n+kVhcSjBcIjikqUzwvlri0yc8sx3yn2yzEABuS6ewvjy7+D1vFm3R3OykMpbRtR5\nW+dndzgVIsz8crrZmiOogku++tV3z1B6MC2Jwe7xPAY2LJaK6Z1XIieIKw/2pR8N\nYf7YZ6u9j0bT9y2etV6vQYYjRtQoDqSbh4q0NjImYQKBgQDaZ/yDFzbJyqmaqPiZ\n7Uk2xH1DB73QwRNmnlynLXX6LwU86Lx51yRsQAejk9iH+xhZjs6i4WvaAqLMp9R1\ntnfTGihAgRaeuxAfN7SjQ0BC4zpSUONkVJ/Zb73J4BFk82dYMQKk/x3N9qb+meZ9\n767jn+cR3w5BKu3h8uZVS98ufwKBgQDTW/BRT/KU2uhVNJdNNIDpy1HKggEdfFPJ\nybdpF+ulZJsfYhTz9LN6gfZZ86/qUnwcHJLkltXB/xWAlWcW1h+2eWrR/lJOE3hh\nSP83tK8AMAnX88FgXwi1+ckKm4NxAEqB65nwcoNNabV1v/kgTXdXjT5UyGL2Eq+K\nqfOpr/QQEQKBgQCsBFSkZwc23dDBSC4tBe+xHAbQYWuF3FvMahPtc+fEuX31oBS6\nHdHJFJEvq8VSLFjcSJbFQKgyV/sjF1hFsgYkFSj4zPMk545mF/jE0bXuOIt5w82k\n+uW/WrvvIPRyPyb5FfjQPUKbMpYKVupr6/ghvZI/yB+xAf/EAwyYx54rPwKBgFmx\nAztORO/8MWmvBqHhrO8Js+zO3HBJyTixXB7B4uLt3ZIkyiV4aw2KxyMG8VjrpfU7\n/u34QD+x4ssNG5EqTozd24G/fefaBVSraHqYN0dKG3ND4oTl70lh9XmF4vJ6ICQf\n+dR6k9OvDy0nyS13EjTaIGBUJQKtjUa3tkoE+/oxAoGAZDFL2nrkHUHSwl6bS60s\n8F3oHCkNi/C77hmSy7RVCnicjVw2cgF9HdFIVe25IpJgbt2H1d3D3xfKEbdxzqCg\nMte2NRzHxWgrfS5gjruSyqjZUIF68QiHm7JGTzEFenirugahTA3dAKxuhHB3YgK1\nmAIbb2R+FdvrntxAE/rKRqs=\n-----END PRIVATE KEY-----\n",
    "client_email": "firebase-adminsdk-fbsvc@smartfarmassistant.iam.gserviceaccount.com",
    "client_id": "102905975843802337079",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40smartfarmassistant.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  static const List<String> _scopes = [
    'https://www.googleapis.com/auth/cloud-platform',
  ];

  Future<void> initNotification() async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _requestPermission();
    await _initializeLocalNotifications();

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpened);

    _currentToken = await _messaging.getToken();
    if (_currentToken != null) {
      await _saveTokenToFirestore(_currentToken!);
    }

    _messaging.onTokenRefresh.listen((token) async {
      _currentToken = token;
      await _saveTokenToFirestore(token);
    });

    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null && _currentToken != null) {
        await _saveTokenToFirestore(_currentToken!);
      }
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationOpened(initialMessage);
    }
  }

  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    debugPrint('FCM permission status: ${settings.authorizationStatus}');
  }

  Future<void> _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

    // 🛠️ ပြင်ဆင်ချက် ၁ - version သစ်များတွင် initializationSettings ဟူသော Named Parameter မရှိပါ။ 
    // Positional Argument အဖြစ် ရှေ့ဆုံးက တိုက်ရိုက်ထည့်ရပါမည်။
    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        debugPrint('Local notification tapped: ${response.payload}');
        if (onNotificationOpened != null && response.payload != null) {
          try {
            Map<String, dynamic> data = jsonDecode(response.payload!);
            onNotificationOpened!(data);
          } catch (e) {
            debugPrint('Error parsing notification payload: $e');
          }
        }
      },
    );

    if (Platform.isAndroid) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'call_channel',
        'Call Notifications',
        description: 'Incoming call notifications and high-priority alerts.',
        importance: Importance.max,
      );

      await _localNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    }
  }

  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Foreground FCM message received: ${message.messageId}');
    await _showLocalNotification(message);
  }

  Future<void> _handleNotificationOpened(RemoteMessage message) async {
    debugPrint('Notification opened: ${message.messageId}');
    if (onNotificationOpened != null) {
      onNotificationOpened!(message.data);
    }
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final data = message.data;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'call_channel',
      'Call Notifications',
      channelDescription: 'Incoming call notifications and high-priority alerts.',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(presentSound: true);
    final NotificationDetails platformDetails = NotificationDetails(android: androidDetails, iOS: iosDetails);

    // 🛠️ ပြင်ဆင်ချက် ၂ - .show() Method တွင် Named Parameter ပုံစံမဟုတ်ဘဲ 
    // Positional arguments (id, title, body, notificationDetails) ပုံစံအတိုင်း တည့်တည့်ထည့်ရပါမည်။
    await _localNotificationsPlugin.show(
      id: message.hashCode,
      title: notification?.title ?? data['title'] ?? 'Incoming Call',
      body: notification?.body ?? data['body'] ?? 'You have an incoming call.',
      notificationDetails: platformDetails,
      payload: jsonEncode(data),
    );
  }

  Future<void> _saveTokenToFirestore(String token) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'fcmToken': token,
        'lastFcmTokenUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint('Saved FCM token for user: ${user.uid}');
    } catch (e) {
      debugPrint('Failed to save FCM token: $e');
    }
  }

  static Future<String> _getAccessToken() async {
    final accountCredentials = auth.ServiceAccountCredentials.fromJson(_serviceAccountCredentials);
    final client = await auth.clientViaServiceAccount(accountCredentials, _scopes);
    final accessToken = client.credentials.accessToken.data;
    client.close();
    return accessToken;
  }

  // 🛠️ ပြင်ဆင်ချက် ၃ - chat_room_screen.dart ဘက်မှ callerId ထည့်ပေးလိုက်မှုကို လက်ခံနိုင်ရန် 
  // 'required String callerId' ကို Parameter အဖြစ် ထပ်မံဖြည့်စွက်ပေးလိုက်ပါသည်။
  static Future<void> sendCallNotification({
    required String callerId, 
    required String receiverId,
    required String receiverToken,
    required String channelId,
    required String callerName,
    required String callType,
    required String callId,
  }) async {
    if (receiverToken.isEmpty) return;

    try {
      final projectId = _serviceAccountCredentials['project_id'] as String;
      final url = 'https://fcm.googleapis.com/v1/projects/$projectId/messages:send';
      final accessToken = await _getAccessToken();

      final payload = {
        'message': {
          'token': receiverToken,
          'notification': {
            'title': 'Incoming Call',
            'body': '$callerName ထံမှ ဖုန်းခေါ်ဆိုနေပါသည်...',
          },
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'type': 'call',
            'callId': callId,
            'callerId': callerId,
            'receiverId': receiverId,
            'channelId': channelId,
            'callerName': callerName,
            'callType': callType,
          },
          'android': {
            'priority': 'high',
            'notification': {
              'sound': 'default',
              'channel_id': 'call_channel',
              'visibility': 'public',
            },
          },
          'apns': {
            'headers': {'apns-priority': '10'},
            'payload': {
              'aps': {'sound': 'default', 'badge': 1},
            },
          },
        },
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ Call notification successfully sent');
      } else {
        debugPrint('❌ Failed to send call notification: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error sending call notification: $e');
    }
  }
}