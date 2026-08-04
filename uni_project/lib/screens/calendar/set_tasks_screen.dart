import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../constants/app_colors.dart';
import '../../models/farm_calendar_model.dart';
import '../../models/task_model.dart';
import '../../services/hive_db_service.dart'; // 💡 HiveDbService ကို သုံးနိုင်ရန် Import ထည့်ပေးလိုက်ပါသည်
import '../../services/notifications_service.dart';
import 'calendar_dashboard_screen.dart';

class SetTasksScreen extends StatefulWidget {
  final FarmCalendarModel calendar;
  final String category; // စိုက်ပျိုးရေး သို့မဟုတ် မွေးမြူရေး

  const SetTasksScreen({
    super.key,
    required this.calendar,
    required this.category,
  });

  @override
  State<SetTasksScreen> createState() => _SetTasksScreenState();
}

class _SetTasksScreenState extends State<SetTasksScreen> {
  late List<TaskModel> _taskList;

  @override
  void initState() {
    super.initState();
    _taskList = List.from(widget.calendar.tasks);
    _taskList.sort((a, b) => a.targetDay.compareTo(b.targetDay));
  }

  IconData _getDynamicIcon(String text) {
    if (widget.category == 'မွေးမြူရေး') {
      if (text.contains('အစာ') || text.contains('ကျွေး')) return Icons.pets;
      if (text.contains('ဆေး') || text.contains('ကာကွယ်')) return Icons.vaccines;
      if (text.contains('သန့်ရှင်း') || text.contains('ခြံ')) return Icons.clean_hands;
      if (text.contains('ရောင်း') || text.contains('ဥ')) return Icons.shopping_basket;
      return Icons.flutter_dash;
    } else {
      if (text.contains('ထွန်') || text.contains('မြေ')) return Icons.agriculture;
      if (text.contains('စပါး') || text.contains('ရိတ်')) return Icons.grass;
      if (text.contains('မြေဩဇာ') || text.contains('ဆေး')) return Icons.science;
      return Icons.eco;
    }
  }

  void _showTaskDialog({int? index}) async {
    final isEdit = index != null;
    final task = isEdit ? _taskList[index] : null;

    final nameController = TextEditingController(text: task?.taskName ?? '');

    DateTime selectedTaskDate = task != null
        ? DateTime.fromMillisecondsSinceEpoch(task.targetDay)
        : DateTime.now();
    TimeOfDay selectedTaskTime = task != null
        ? TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(task.targetDay))
        : const TimeOfDay(hour: 8, minute: 0);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(isEdit ? 'လုပ်ငန်းစဉ်ပြင်ဆင်ရန်' : 'လုပ်ငန်းစဉ်အသစ်ထည့်ရန်',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              content: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.65,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'လုပ်ငန်းစဉ် / သတိပေးချက် ခေါင်းစဉ်',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('သတိပေးမည့် ရက်စွဲရွေးချယ်ရန်', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedTaskDate,
                            firstDate: DateTime.now().subtract(const Duration(days: 365)),
                            lastDate: DateTime(2035),
                          );
                          if (picked != null) {
                            setDialogState(() => selectedTaskDate = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${selectedTaskDate.day}/${selectedTaskDate.month}/${selectedTaskDate.year}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const Icon(Icons.calendar_month, color: Colors.blue),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text('သတိပေးမည့် အချိန်ရွေးချယ်ရန်', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: selectedTaskTime,
                          );
                          if (picked != null) {
                            setDialogState(() => selectedTaskTime = picked);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(selectedTaskTime.format(context), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              const Icon(Icons.access_time, color: Colors.blue),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.notification_important, color: Colors.orange.shade700, size: 16),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'အောက်ပါရက်စွဲနှင့် အချိန်တွင် Alert မြည်ပေးပါမည်။',
                              style: TextStyle(fontSize: 13, color: Colors.orange.shade700),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('ပယ်ဖျက်', style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary),
                  onPressed: () {
                    if (nameController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('လုပ်ငန်းစဉ်အမည်ကို ဖြည့်ပေးပါ')),
                      );
                      return;
                    }

                    setState(() {
                      final DateTime combinedDateTime = DateTime(
                        selectedTaskDate.year,
                        selectedTaskDate.month,
                        selectedTaskDate.day,
                        selectedTaskTime.hour,
                        selectedTaskTime.minute,
                      );
                      final int dateTimestamp = combinedDateTime.millisecondsSinceEpoch;

                      if (isEdit) {
                        _taskList[index] = TaskModel(
                          id: task!.id,
                          taskName: nameController.text.trim(),
                          targetDay: dateTimestamp,
                          isCompleted: task.isCompleted,
                        );
                      } else {
                        _taskList.add(TaskModel(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          taskName: nameController.text.trim(),
                          targetDay: dateTimestamp,
                          isCompleted: false,
                        ));
                      }
                      _taskList.sort((a, b) => a.targetDay.compareTo(b.targetDay));
                    });
                    Navigator.pop(context);
                  },
                  child: Text(isEdit ? 'သိမ်းဆည်းမည်' : 'ထည့်သွင်းမည်', style: const TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('${widget.category} လုပ်ငန်းစဉ်များ သတ်မှတ်ရန်', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _taskList.isEmpty
          ? Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            'သတ်မှတ်ထားသော သတိပေးချက် လုပ်ငန်းစဉ်များ မရှိသေးပါ။\nအောက်ခြေရှိ (+) ခလုတ်ကိုနှိပ်ပြီး မိမိစိတ်ကြိုက် ရက်စွဲများဖြင့် Alert လုပ်ငန်းစဉ်များ ထည့်သွင်းနိုင်ပါတယ်၊၊',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 15, height: 1.5),
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _taskList.length,
        itemBuilder: (context, index) {
          final task = _taskList[index];
          final taskDate = DateTime.fromMillisecondsSinceEpoch(task.targetDay);
          final dateStr = "${taskDate.day}/${taskDate.month}/${taskDate.year}";

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(color: themeColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    dateStr,
                    style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 12),
                Icon(_getDynamicIcon(task.taskName), color: themeColor.withOpacity(0.7)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task.taskName,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blueAccent, size: 22),
                  onPressed: () => _showTaskDialog(index: index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 22),
                  onPressed: () {
                    setState(() => _taskList.removeAt(index));
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: themeColor,
        onPressed: () => _showTaskDialog(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: themeColor,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () async {
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);

              widget.calendar.tasks = _taskList;
              widget.calendar.totalDays = _taskList.isNotEmpty ? _taskList.length : 1;

              final finalCalendar = FarmCalendarModel(
                id: widget.calendar.id,
                cropName: widget.calendar.cropName,
                startDate: widget.calendar.startDate,
                totalDays: widget.calendar.totalDays,
                tasks: widget.calendar.tasks,
                imagePath: widget.calendar.imagePath,
              );

              if (mounted) {
                await _saveCalendarWithNotifications(finalCalendar);
                if (!mounted) return;
                navigator.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const CalendarDashboardScreen()),
                  (route) => false,
                );
                if (!mounted) return;
                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('လုပ်ငန်းစဉ်ပြက္ခဒိန်ကို အောင်မြင်စွာ သိမ်းဆည်းပြီးပါပြီ၊၊'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            child: const Text('လုပ်ငန်းစဉ်အားလုံး သိမ်းဆည်းမည်', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Future<void> _saveCalendarWithNotifications(FarmCalendarModel calendar) async {
    try {
      await HiveDbService.saveCalendar(calendar);
    } catch (_) {
      final box = Hive.box<dynamic>(HiveDbService.boxName);
      await box.put(calendar.id, calendar.toMap());
    }

    for (final task in calendar.tasks) {
      final int notificationId = NotificationService.getNotificationId(task.id);
      await NotificationService.cancelAlert(notificationId);
      if (!task.isCompleted) {
        await NotificationService.scheduleAlert(
          id: notificationId,
          crop: calendar.cropName,
          task: task.taskName,
          targetTimestamp: task.targetDay,
        );
      }
    }
  }
}
