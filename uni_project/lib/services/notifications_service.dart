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

  static Future<void> scheduleAlert({
    required int id,
    required String crop,
    required String task,
    required DateTime startDate,
    required int targetDay,
  }) async {
    // Alert ရက်စွဲတွက်ချက်ခြင်း
    DateTime targetDate = startDate.add(Duration(days: targetDay - 1));
    DateTime alertTime = DateTime(targetDate.year, targetDate.month, targetDate.day, 8, 0); // မနက် ၈:၀၀ တိုင်းပေးရန်

    if (alertTime.isBefore(DateTime.now())) return;

    await _plugin.zonedSchedule(
      id,
      '🌾 Farm Reminder ($crop)',
      'ယနေ့ Day $targetDay: $task လုပ်ဆောင်ရန် အချိန်ရောက်ပါပြီ။',
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

  static Future<void> cancelAllAlerts() async {
    await _plugin.cancelAll();
  }
}