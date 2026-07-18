class TaskModel {
  String id;
  int targetDay;       // 💡 စနစ်သစ်: ပြက္ခဒိန်ရက်စွဲ၏ Milliseconds Timestamp (ဥပမာ - 1765893600000)
  String taskName;     // ဥပမာ - လယ်ထွန်၊ ပျိုးကျဲ၊ အစာကျွေး
  String notes;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.targetDay,
    required this.taskName,
    this.notes = '',
    this.isCompleted = false,
  });

  // 💡 Hive ထဲသို့ ဒေတာသိမ်းဆည်းရန် Map ပုံစံပြောင်းလဲခြင်း
  Map<String, dynamic> toMap() => {
    'id': id,
    'targetDay': targetDay,
    'taskName': taskName,
    'notes': notes,
    'isCompleted': isCompleted,
  };

  // 💡 Hive ထဲမှ ဒေတာပြန်ဖတ်ရာတွင် Type Error ကင်းဝေးစေရန် စိတ်ချရသော စနစ်ဖြင့် ပြန်ပြောင်းခြင်း
  factory TaskModel.fromMap(Map<dynamic, dynamic> map) => TaskModel(
    id: map['id']?.toString() ?? '',
    targetDay: map['targetDay'] is int
        ? map['targetDay']
        : int.tryParse(map['targetDay']?.toString() ?? '0') ?? 0,
    taskName: map['taskName']?.toString() ?? '',
    notes: map['notes']?.toString() ?? '',
    isCompleted: map['isCompleted'] is bool
        ? map['isCompleted']
        : (map['isCompleted']?.toString().toLowerCase() == 'true'),
  );
}