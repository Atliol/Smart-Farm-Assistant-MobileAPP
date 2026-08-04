import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzdata.initializeTimeZones();
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(initSettings);

    // Request runtime permissions using permission_handler for supported platforms only
    try {
      if (!kIsWeb &&
          (defaultTargetPlatform == TargetPlatform.android ||
              defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS)) {
        if (await Permission.notification.isDenied) {
          await Permission.notification.request();
        }
      }
    } catch (e) {
      // If the permission_handler plugin is not available on the current platform
      // or any error occurs, ignore and continue. This prevents MissingPluginException
      // from crashing the app on unsupported platforms (web, windows, linux).
      print('Permission request skipped or failed: $e');
    }

    final AndroidFlutterLocalNotificationsPlugin? androidPlugin =
        _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    // Create Android notification channel for API >= 26
    try {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        'farm_channel',
        'Farm Calendar Alerts',
        description: 'Channel for farm calendar reminders',
        importance: Importance.max,
        playSound: true,
      );
      await androidPlugin?.createNotificationChannel(channel);
    } catch (e) {
      print('Android channel creation skipped or failed: $e');
    }

    // Request exact alarm permission if needed
    await androidPlugin?.requestExactAlarmsPermission();

    // For older iOS/macOS APIs the plugin also exposes platform methods
    final iosPlugin = _plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    await iosPlugin?.requestPermissions(alert: true, badge: true, sound: true);
  }

  static int getNotificationId(String taskId) {
    return taskId.hashCode & 0x7FFFFFFF;
  }

  static Future<void> scheduleAlert({
    required int id,
    required String crop,
    required String task,
    required int targetTimestamp,
  }) async {
    final DateTime alertTime = DateTime.fromMillisecondsSinceEpoch(targetTimestamp);

    if (alertTime.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      id,
      '🌾 Farm Reminder ($crop)',
      'ယနေ့ $task လုပ်ဆောင်ရန် အချိန်ရောက်ပါပြီ။',
      tz.TZDateTime.from(alertTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'farm_channel', 'Farm Calendar Alerts',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> cancelAlert(int id) async {
    await _plugin.cancel(id);
  }

  static Future<void> cancelAllAlerts() async {
    await _plugin.cancelAll();
  }
}