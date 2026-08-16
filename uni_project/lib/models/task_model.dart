class TaskModel {
  String id;
  int targetDay;
  String taskName;
  String notes;
  bool isCompleted;

  TaskModel({
    required this.id,
    required this.targetDay,
    required this.taskName,
    this.notes = '',
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'targetDay': targetDay,
    'taskName': taskName,
    'notes': notes,
    'isCompleted': isCompleted,
  };

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