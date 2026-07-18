import 'package:flutter/material.dart';
import '../../models/task_model.dart';

class TaskDetailScreen extends StatelessWidget {
  final TaskModel task;
  final String cropName; // သီးနှံ သို့မဟုတ် မွေးမြူရေးလုပ်ငန်းအမည်

  const TaskDetailScreen({
    super.key,
    required this.task,
    required this.cropName
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;

    // 💡 targetDay (Timestamp) မှ ပြက္ခဒိန်ရက်စွဲ (DateTime) သို့ ပြန်ပြောင်းခြင်း
    final taskDate = DateTime.fromMillisecondsSinceEpoch(task.targetDay);
    final dateStr = "${taskDate.day}/${taskDate.month}/${taskDate.year}";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('လုပ်ငန်းစဉ် အသေးစိတ်', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: themeColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💡 လုပ်ငန်းစဉ် ကတ်ပြားပုံစံ Display
            Container(
              height: 160,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: themeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: themeColor.withOpacity(0.2))
              ),
              child: Icon(Icons.event_note, size: 70, color: themeColor),
            ),
            const SizedBox(height: 24),

            // 💡 ရက်စွဲ နှင့် လုပ်ငန်းစဉ်အမည်
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                      color: themeColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text(
                      dateStr,
                      style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 14)
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                      task.taskName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, height: 1.3)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 💡 စိုက်ပျိုးရေး/မွေးမြူရေး လုပ်ငန်းခေါင်းစဉ် ပြသရန်
            const Text('လုပ်ငန်းစဉ်အမျိုးအစား / အမည်', style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(cropName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),

            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.alarm, color: Colors.orange, size: 20),
                SizedBox(width: 6),
                Text('အထက်ပါရက်စွဲတွင် သတိပေးချက် (Alert) မြည်ပါမည်၊၊', style: TextStyle(fontSize: 13, color: Colors.orange, fontWeight: FontWeight.w500)),
              ],
            ),

            const Spacer(),

            // 💡 လုပ်ငန်းပြီးစီးကြောင်း အတည်ပြုရန် ခလုတ်များ
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                onPressed: () {
                  // 💡 ပြီးစီးကြောင်း အမှန်ခြစ်ပေးပြီး မျက်နှာပြင်မှ ပြန်ထွက်ကာ True ပါးလိုက်ခြင်း
                  task.isCompleted = true;
                  Navigator.pop(context, true);
                },
                child: const Text('လုပ်ဆောင်ပြီးစီးပါပြီ ✓', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.redAccent),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
                ),
                onPressed: () {
                  // မလုပ်ရသေးပါက false ဟု သတ်မှတ်ပြီး ပြန်ထွက်ခြင်း
                  task.isCompleted = false;
                  Navigator.pop(context, false);
                },
                child: const Text('မလုပ်ဆောင်ရသေးပါ ✕', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}