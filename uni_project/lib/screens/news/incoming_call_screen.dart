import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/call_model.dart';
import 'services/call_service.dart';
import 'call_screen.dart';

class IncomingCallScreen extends StatelessWidget {
  final CallModel call;
  final CallService _callService = CallService();

  IncomingCallScreen({super.key, required this.call});

  @override
  Widget build(BuildContext context) {
    // တစ်ဖက်က ဖုန်းပြန်ချသွားရင် ဤ UI ပိတ်သွားအောင် StreamBuilder ဖြင့် စောင့်ကြည့်ခြင်း
    return StreamBuilder<DocumentSnapshot>(
      stream: _callService.listenToCall(call.receiverId),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data!.exists) {
          var data = snapshot.data!.data() as Map<String, dynamic>;
          
          // status က ended ဖြစ်သွားရင် (သို့) တစ်ဖက်လူက ဖုန်းချလိုက်ရင် UI ကို ပိတ်မယ်
          if (data['status'] == 'ended') {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            });
          }
        }

        return Scaffold(
          backgroundColor: const Color(0xff0a196c),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("ဖုန်းခေါ်ဆိုမှု ဝင်လာနေပါသည်...", style: TextStyle(color: Colors.white70, fontSize: 16)),
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white24,
                child: Text(call.callerName.isNotEmpty ? call.callerName[0] : "?", style: const TextStyle(color: Colors.white, fontSize: 32)),
              ),
              const SizedBox(height: 16),
              Text(call.callerName, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(call.isVideoCall ? "Video Call..." : "Audio Call...", style: const TextStyle(color: Colors.white60)),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // 🔴 ဖုန်းငြင်းပယ်ရန်ခလုတ် (Decline)
                  FloatingActionButton(
                    heroTag: "decline_btn",
                    backgroundColor: Colors.red,
                    onPressed: () async {
                      await _callService.endCall(call.receiverId);
                      if (context.mounted) Navigator.pop(context);
                    },
                    child: const Icon(Icons.call_end, color: Colors.white),
                  ),
                  
                  // 🟢 ဖုန်းလက်ခံရန်ခလုတ် (Accept)
                  FloatingActionButton(
                    heroTag: "accept_btn",
                    backgroundColor: Colors.green,
                    onPressed: () async {
                      await _callService.answerCall(call.receiverId);
                      
                      if (context.mounted) {
                        // 🛠️ ဒီနေရာမှာ ကွင်းပိတ် ဆီမီကော်လံ (;) မှားနေတာကို ပြင်ဆင်ထားပါတယ်
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CallScreen(
                              channelId: call.channelId,
                              receiverName: call.callerName,
                              isVideoCall: call.isVideoCall,
                            ),
                          ),
                        ); // <-- ဒီနေရာမှာ ဖြစ်ရပါမယ်
                      }
                    },
                    child: const Icon(Icons.call, color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}