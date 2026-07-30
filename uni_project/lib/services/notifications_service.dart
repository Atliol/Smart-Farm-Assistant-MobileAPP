import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzData.initializeTimeZones();
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    await _plugin.initialize(const InitializationSettings(android: androidSettings));
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
    final DateTime targetDate = DateTime.fromMillisecondsSinceEpoch(targetTimestamp);
    final DateTime alertTime = DateTime(targetDate.year, targetDate.month, targetDate.day, 8, 0);

    if (alertTime.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      id,
      '🌾 Farm Reminder ($crop)',
      'ယနေ့ ${task} လုပ်ဆောင်ရန် အချိန်ရောက်ပါပြီ။',
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