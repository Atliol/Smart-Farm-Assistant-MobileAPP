import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> initNotification() async {
    // Android Initialization Setting
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Initialization Setting
    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  // 💡 အပေါ်ကနေ Banner ပုံစံ ကျလာစေမည့် Notification ပြသခြင်း Function
  static Future<void> showTopNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    // 🔥 အဓိကအကျဆုံးအပိုင်း - Android မှာ အပေါ်ကနေ ကျလာစေရန် Channel ဆက်တင် ပြင်ဆင်ခြင်း
    const AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
      'high_importance_channel', // Channel ID
      'High Importance Notifications', // Channel Name
      channelDescription: 'This channel is used for important notifications.',
      importance: Importance.max,   // 💡 အမြင့်ဆုံးအဆင့် သတ်မှတ်ချက် (အပေါ်ကကျလာစေရန်)
      priority: Priority.high,       // 💡 အရေးကြီးအဆင့် သတ်မှတ်ချက် (အပေါ်ကကျလာစေရန်)
      showWhen: true,
      playSound: true,
    );

    // iOS အတွက် အပေါ်ကကျလာစေရန် ဆက်တင်
    const DarwinNotificationDetails iosNotificationDetails =
    DarwinNotificationDetails(
      presentAlert: true,  // 💡 Banner ပြသမည်
      presentBadge: true,  // 💡 Badge ပြသမည်
      presentSound: true,  // 💡 အသံမြည်မည်
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );

    // Notification ကို စတင်ပြသခြင်း
    await _notificationsPlugin.show(
      id,
      title,
      body,
      notificationDetails,
    );
  }
}