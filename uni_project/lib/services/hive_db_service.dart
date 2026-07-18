import 'package:hive/hive.dart';
import '../models/farm_calendar_model.dart';

class HiveDbService {
  static const String boxName = 'farm_calendars';

  static Future<void> init() async {
    await Hive.openBox<dynamic>(boxName);
  }

  static List<FarmCalendarModel> getAllCalendars() {
    try {
      final box = Hive.box<dynamic>(boxName);
      return box.values.map((value) {
        if (value is FarmCalendarModel) {
          return value;
        }

        if (value is Map) {
          return FarmCalendarModel.fromMap(Map<dynamic, dynamic>.from(value));
        }

        return FarmCalendarModel(
          id: value?.toString() ?? '',
          cropName: '',
          startDate: DateTime.now(),
          totalDays: 0,
          tasks: [],
        );
      }).toList();
    } catch (e) {
      print('Error getting calendars: $e');
      return [];
    }
  }

  static Future<void> saveCalendar(FarmCalendarModel calendar) async {
    try {
      final box = Hive.box<dynamic>(boxName);
      await box.put(calendar.id, calendar.toMap());
      print('HiveDbService: ပြက္ခဒိန်ကို အောင်မြင်စွာ သိမ်းဆည်းပြီးပါပြီ။');
    } catch (e) {
      print('HiveDbService Error saving calendar: $e');
    }
  }
}