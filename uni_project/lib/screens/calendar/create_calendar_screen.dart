import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uni_project/constants/app_colors.dart';
import '../../models/farm_calendar_model.dart';
import 'set_tasks_screen.dart';

class CreateCalendarScreen extends StatefulWidget {
  const CreateCalendarScreen({super.key});

  @override
  State<CreateCalendarScreen> createState() => _CreateCalendarScreenState();
}

class _CreateCalendarScreenState extends State<CreateCalendarScreen> {
  final _titleController = TextEditingController();
  String _calendarCategory = 'စိုက်ပျိုးရေး'; // 💡 စိုက်ပျိုးရေး သို့မဟုတ် မွေးမြူရေး ရွေးရန်
  DateTime _startDate = DateTime.now();
  String? _pickedImagePath;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _pickedImagePath = image.path);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('ပြက္ခဒိန်အသစ်တည်ဆောက်', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💡 စိုက်ပျိုးရေး သို့မဟုတ် မွေးမြူရေး ရွေးချယ်ရန် Dropdown UI
            const Text('လုပ်ငန်းအမျိုးအစား', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300)
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _calendarCategory,
                  isExpanded: true,
                  items: <String>['စိုက်ပျိုးရေး', 'မွေးမြူရေး'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _calendarCategory = newValue;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 💡 ရွေးချယ်လိုက်တဲ့ အမျိုးအစားအလိုက် Hint Text ကို ပြောင်းလဲပေးခြင်း
            const Text('လုပ်ငန်းစဉ်အမည် / သီးနှံ / ကောင်ရေအမည်', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: _calendarCategory == 'စိုက်ပျိုးရေး'
                    ? 'ဥပမာ- စပါး၊ မတ်ပဲ၊ ခရမ်းချဉ်'
                    : 'ဥပမာ- ကြက်မွေးမြူရေး၊ နွားနို့လုပ်ငန်း၊ ငါးကန်',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 20),

            const Text('နောက်ခံပုံရွေးချယ်ရန် (မရွေးလည်းရပါသည်)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: double.infinity,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                  image: _pickedImagePath != null
                      ? DecorationImage(image: FileImage(File(_pickedImagePath!)), fit: BoxFit.cover)
                      : null,
                ),
                child: _pickedImagePath == null
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo, size: 40, color: Colors.grey.shade600),
                    const SizedBox(height: 8),
                    Text('ဒီနေရာကိုနှိပ်ပြီး ဓာတ်ပုံတင်ပါ', style: TextStyle(color: Colors.grey.shade600)),
                  ],
                )
                    : const SizedBox(),
              ),
            ),
            const SizedBox(height: 20),

            const Text('စတင်မည့်ရက်စွဲ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),
                );
                if (picked != null) setState(() => _startDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${_startDate.day}/${_startDate.month}/${_startDate.year}', style: const TextStyle(fontSize: 16)),
                    Icon(Icons.calendar_today, color: themeColor),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),

            // 💡 ရက်မြောက်နေ့ (Total Days) ဖြည့်ခိုင်းတဲ့အပိုင်းကို ဖြုတ်လိုက်ပြီး နောက်တစ်ဆင့်ကို တန်းသွားပါမယ်
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))
                ),
                onPressed: () {
                  if (_titleController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('လုပ်ငန်းစဉ် သို့မဟုတ် သီးနှံအမည်ကို ဖြည့်စွက်ပေးပါ၊၊'))
                    );
                    return;
                  }

                  // Calendar Model အသစ်တည်ဆောက်ခြင်း (Tasks ကို အလွတ်ဖြင့် အရင်ပို့ပါမည်)
                  final newCalendar = FarmCalendarModel(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    cropName: _titleController.text.trim(),
                    startDate: _startDate,
                    totalDays: 0, // Date တိုက်ရိုက်သုံးမည်ဖြစ်၍ 0 ဟု သတ်မှတ်ထားပါသည်
                    tasks: [],
                    imagePath: _pickedImagePath,
                  );

                  // 💡 SetTasksScreen သို့ သွားပြီး category ရော calendar ပါ ပါးလိုက်ပါတယ်
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SetTasksScreen(
                        calendar: newCalendar,
                        category: _calendarCategory,
                      ),
                    ),
                  );
                },
                child: const Text('နောက်တစ်ဆင့် (လုပ်ငန်းစဉ်နှင့် ရက်စွဲသတ်မှတ်ရန်) ➡️', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}