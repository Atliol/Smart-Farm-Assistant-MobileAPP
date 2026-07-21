import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uni_project/constants/app_colors.dart';
import '../../models/farm_calendar_model.dart';
import '../../models/task_model.dart';
import '../../services/hive_db_service.dart';
import 'create_calendar_screen.dart';
import 'task_detail_screen.dart';

class CalendarDashboardScreen extends StatefulWidget {
  const CalendarDashboardScreen({super.key});

  @override
  State<CalendarDashboardScreen> createState() => _CalendarDashboardScreenState();
}

class _CalendarDashboardScreenState extends State<CalendarDashboardScreen> {
  List<FarmCalendarModel> _calendars = [];
  FarmCalendarModel? _activeCalendar;
  int _elapsedDays = 0; // စတင်ကတည်းက ကြာမြင့်ခဲ့သော ရက်ပေါင်း

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _calendars = HiveDbService.getAllCalendars();
      if (_calendars.isNotEmpty) {
        _activeCalendar = _calendars.last;
        _updateElapsedDays();
      } else {
        _activeCalendar = null;
      }
    });
  }

  void _updateElapsedDays() {
    if (_activeCalendar != null) {
      final today = DateTime.now();
      final start = _activeCalendar!.startDate;
      // စတင်သည့်ရက်စွဲမှ ယနေ့အထိ ခြားနားချက် (ရက်ပေါင်း) ကို တွက်ချက်သည်
      final difference = DateTime(today.year, today.month, today.day)
          .difference(DateTime(start.year, start.month, start.day))
          .inDays;
      _elapsedDays = difference >= 0 ? difference : 0;
    }
  }

  // 💡 စိုက်ပျိုးရေးနှင့် မွေးမြူရေး နှစ်ခုလုံးအတွက် Dynamic Icons စနစ်
  IconData _getDynamicIcon(String text) {
    final lowerText = text.toLowerCase();
    // မွေးမြူရေး ဆိုင်ရာများ
    if (lowerText.contains('ကြက်') || lowerText.contains('ငှက်')) return Icons.flutter_dash;
    if (lowerText.contains('နွား') || lowerText.contains('ဝက်') || lowerText.contains('ဆိတ်')) return Icons.pets;
    if (lowerText.contains('ငါး') || lowerText.contains('ပုစွန်') || lowerText.contains('ကန်')) return Icons.water;
    if (lowerText.contains('အစာ') || lowerText.contains('ကျွေး')) return Icons.set_meal;

    // စိုက်ပျိုးရေး ဆိုင်ရာများ
    if (lowerText.contains('ထွန်') || lowerText.contains('မြေ')) return Icons.agriculture;
    if (lowerText.contains('စပါး') || lowerText.contains('ရိတ်')) return Icons.grass;
    if (lowerText.contains('ပဲ') || lowerText.contains('ပျိုး') || lowerText.contains('စိုက်')) return Icons.yard;
    if (lowerText.contains('မြေဩဇာ') || lowerText.contains('ဆေး')) return Icons.science;
    if (lowerText.contains('ရိတ်သိမ်း') || lowerText.contains('ဆွတ်') || lowerText.contains('ခူး')) return Icons.content_cut;

    return Icons.assignment; // Default Icon
  }

  // 💡 Timestamp မှ ရက်စွဲစာသား ပြောင်းလဲပေးသည့် Helper
  String _formatTimestamp(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${date.day}/${date.month}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;

    // 💡 ယနေ့ လုပ်ဆောင်ရမည့် Task များ (ယနေ့ရက်စွဲနှင့် တူညီသော Task များ)
    List<TaskModel> todayTasks = [];
    // 💡 လာမည့် လုပ်ဆောင်ရမည့် Task များ (ယနေ့ထက် ကျော်လွန်သော ရက်စွဲရှိ Task များ)
    List<TaskModel> upcomingTasks = [];

    if (_activeCalendar != null) {
      for (var task in _activeCalendar!.tasks) {
        final taskDate = DateTime.fromMillisecondsSinceEpoch(task.targetDay);
        final taskMidnight = DateTime(taskDate.year, taskDate.month, taskDate.day).millisecondsSinceEpoch;

        if (taskMidnight == todayMidnight) {
          todayTasks.add(task);
        } else if (taskMidnight > todayMidnight) {
          upcomingTasks.add(task);
        }
      }
      // ရက်စွဲအလိုက် ငယ်စဉ်ကြီးလိုက် စီထားပေးခြင်း
      upcomingTasks.sort((a, b) => a.targetDay.compareTo(b.targetDay));
    }

    // 💡 Progress Bar စနစ်သစ်: (ပြီးစီးပြီးသား လုပ်ငန်းစဉ် / လုပ်ငန်းစဉ်စုစုပေါင်း)
    double progressValue = 0.0;
    int completedCount = 0;
    if (_activeCalendar != null && _activeCalendar!.tasks.isNotEmpty) {
      completedCount = _activeCalendar!.tasks.where((t) => t.isCompleted).length;
      progressValue = completedCount / _activeCalendar!.tasks.length;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('လယ်ယာနှင့် မွေးမြူရေး လက်ထောက်', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        actions: [
          if (_calendars.length > 1)
            DropdownButton<String>(
              dropdownColor: themeColor,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              underline: const SizedBox(),
              value: _activeCalendar?.id,
              items: _calendars.map((cal) {
                return DropdownMenuItem<String>(
                  value: cal.id,
                  child: Text(cal.cropName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _activeCalendar = _calendars.firstWhere((c) => c.id == value);
                  _updateElapsedDays();
                });
              },
            ),
          IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.white),
              onPressed: () {}
          ),
        ],
      ),
      body: _activeCalendar == null
          ? Center(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateCalendarScreen())
          ).then((_) => _loadData()),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text('ပြက္ခဒိန်အသစ် ဆောက်ရန်', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💡 Main Dashboard Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: themeColor.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
                gradient: _activeCalendar!.imagePath == null
                    ? LinearGradient(colors: [themeColor, themeColor.withBlue(40)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                    : null,
                image: _activeCalendar!.imagePath != null
                    ? DecorationImage(
                  image: FileImage(File(_activeCalendar!.imagePath!)),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.55), BlendMode.srcOver),
                )
                    : null,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'စတင်ရက် - ${DateFormat('dd/MM/yyyy').format(_activeCalendar!.startDate)}',
                          style: const TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 4),
                        Text(
                            _activeCalendar!.cropName,
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)
                        ),
                        const SizedBox(height: 6),
                        Text(
                            'ကြာမြင့်ရက်: $_elapsedDays ရက်မြောက်',
                            style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)
                        ),
                        const SizedBox(height: 4),
                        Text(
                            'ယနေ့ရက်စွဲ: ${DateFormat('dd MMM yyyy').format(DateTime.now())}',
                            style: const TextStyle(color: Colors.white70, fontSize: 13)
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white.withOpacity(0.25),
                    child: Icon(_getDynamicIcon(_activeCalendar!.cropName), size: 36, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 💡 Section 1: ယနေ့ လုပ်ငန်းစဉ်များ
            const Text('ယနေ့လုပ်ငန်းစဉ်', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),

            todayTasks.isNotEmpty
                ? ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: todayTasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final task = todayTasks[index];
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: task.isCompleted ? Colors.green.shade200 : Colors.grey.shade200),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 8)],
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: task.isCompleted ? Colors.green.shade50 : themeColor.withOpacity(0.1),
                        child: Icon(
                            task.isCompleted ? Icons.check_circle : _getDynamicIcon(task.taskName),
                            color: task.isCompleted ? Colors.green : themeColor
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                task.taskName,
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                                    color: task.isCompleted ? Colors.grey : Colors.black87
                                )
                            ),
                            Text('ရက်စွဲ: ${_formatTimestamp(task.targetDay)} ⏰ 08:00 AM', style: const TextStyle(color: Colors.grey, fontSize: 13)),
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task, cropName: _activeCalendar!.cropName))
                          ).then((_) => _loadData());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                              color: task.isCompleted ? Colors.green.shade100 : themeColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Text(
                              task.isCompleted ? 'ပြီးစီး' : 'လုပ်ဆောင်ရန်',
                              style: TextStyle(color: task.isCompleted ? Colors.green.shade800 : themeColor, fontWeight: FontWeight.bold, fontSize: 13)
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            )
                : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Center(
                child: Text(
                  '📅 ယနေ့အတွက် လုပ်ငန်းစဉ် မရှိပါ။',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 💡 Section 2: လာမည့် လုပ်ငန်းစဉ်များ
            const Text('လာမည့်လုပ်ငန်းများ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 10),

            upcomingTasks.isNotEmpty
                ? ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: upcomingTasks.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final task = upcomingTasks[index];
                return ListTile(
                  tileColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade100),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue.shade50,
                    child: Icon(_getDynamicIcon(task.taskName), color: Colors.blue, size: 20),
                  ),
                  title: Text(
                      task.taskName,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          color: task.isCompleted ? Colors.grey : Colors.black87
                      )
                  ),
                  subtitle: Text('သတ်မှတ်ရက် - ${_formatTimestamp(task.targetDay)}'),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => TaskDetailScreen(task: task, cropName: _activeCalendar!.cropName))
                    ).then((_) => _loadData());
                  },
                );
              },
            )
                : Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Center(
                child: Text(
                  '📅 ရှေ့လာမည့် လုပ်ငန်းစဉ်များ မရှိသေးပါ။',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 💡 Section 3: လုပ်ငန်းပြီးစီးမှု အဆင့် (Progress Bar)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('လုပ်ငန်းပြီးစီးမှု အခြေအနေ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                Text(
                  '${(progressValue * 100).toStringAsFixed(0)}% ($completedCount/${_activeCalendar!.tasks.length})',
                  style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 13),
                )
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progressValue.clamp(0.0, 1.0),
              backgroundColor: Colors.grey.shade200,
              color: themeColor,
              minHeight: 10,
              borderRadius: BorderRadius.circular(5),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}