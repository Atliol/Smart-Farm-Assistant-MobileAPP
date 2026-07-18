import 'task_model.dart';

class FarmCalendarModel {
  String id;
  String cropName;
  DateTime startDate;
  int totalDays;
  List<TaskModel> tasks;
  String? imagePath;

  FarmCalendarModel({
    required this.id,
    required this.cropName,
    required this.startDate,
    required this.totalDays,
    required this.tasks,
    this.imagePath,
  });

  // 💡 Hive ထဲကနေ ပြန်ဖတ်တဲ့အခါ သုံးမယ့် fromMap
  factory FarmCalendarModel.fromMap(Map<dynamic, dynamic> map) {
    return FarmCalendarModel(
      id: map['id']?.toString() ?? '',
      cropName: map['cropName']?.toString() ?? '',
      startDate: map['startDate'] != null
          ? DateTime.parse(map['startDate'].toString())
          : DateTime.now(),
      totalDays: map['totalDays'] is int ? map['totalDays'] : int.tryParse(map['totalDays']?.toString() ?? '0') ?? 0,
      tasks: (map['tasks'] as List<dynamic>?)
          ?.map((e) => TaskModel.fromMap(Map<dynamic, dynamic>.from(e as Map)))
          .toList() ??
          [],
      imagePath: map['imagePath']?.toString(),
    );
  }

  // 💡 Hive ထဲကို သိမ်းတဲ့အခါ ပြောင်းလဲမယ့် toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cropName': cropName,
      'startDate': startDate.toIso8601String(),
      'totalDays': totalDays,
      'tasks': tasks.map((t) => t.toMap()).toList(),
      'imagePath': imagePath,
    };
  }
}