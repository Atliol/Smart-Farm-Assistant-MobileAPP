import 'package:flutter/material.dart';

class CreatePostScreen extends StatelessWidget {
  const CreatePostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              // 💡 BACKEND ACTION: Post တင်မည့် API Request လုပ်ရန်
              Navigator.pop(context);
            },
            child: const Text('POST', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "မျှဝေလိုသည်များကို ရေးသားပါ...",
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
            ),
            const Spacer(),
            // ဓာတ်ပုံရွေးရန် ခလုတ်
            Card(
              elevation: 0,
              color: Colors.grey.shade100,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.green),
                title: const Text("ဓာတ်ပုံ သို့မဟုတ် ဗီဒီယို ထည့်သွင်းပါ"),
                onTap: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}