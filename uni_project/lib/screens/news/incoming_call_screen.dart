import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/call_model.dart';
import 'services/call_service.dart';
import 'call_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class IncomingCallScreen extends StatefulWidget {
  final CallModel call;
  const IncomingCallScreen({super.key, required this.call});

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  final CallService _callService = CallService();
  final AudioPlayer _ringtonePlayer = AudioPlayer(); // 🎵 Ringtone အတွက် Player ဆောက်ခြင်း
  StreamSubscription? _incomingStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initIncomingSession();
  }

  Future<void> _initIncomingSession() async {
    // 🎵 ၁။ ဖုန်းဝင်လာတာနဲ့ Ringtone သံကို Loop ပတ်ပြီး စဖွင့်ပါမယ်
    try {
      await _ringtonePlayer.setReleaseMode(ReleaseMode.loop);
      await _ringtonePlayer.play(AssetSource('audio/ringtone.mp3'));
    } catch (e) {
      debugPrint("🎵 Audio Player Error: $e");
    }

    // ၂။ တစ်ဖက်က ဖုန်းပြန်ချလိုက်ရင် ဒီဘက်က auto ပိတ်သွားအောင် stream စောင့်ကြည့်မယ်
    _incomingStreamSubscription = FirebaseFirestore.instance
        .collection('calls')
        .doc(widget.call.callId)
        .snapshots()
        .listen((doc) async {
          if (!doc.exists && mounted) {
            await _stopRingtone(); // 🎵 အသံအရင်ပိတ်မယ်
            if (mounted) Navigator.pop(context);
          }
        });
  }

  // 🎵 Ringtone ကို ရပ်ပေးမယ့် Utility Function
  Future<void> _stopRingtone() async {
    try {
      await _ringtonePlayer.stop();
    } catch (e) {
      debugPrint("Error stopping ringtone: $e");
    }
  }

  @override
  void dispose() {
    _ringtonePlayer.dispose(); // 🛠️ Memory leak မဖြစ်အောင် Player ကို အပြီးသတ်ဖျက်ပစ်မယ်
    _incomingStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.call.isVideoCall ? "Incoming Video Call..." : "Incoming Voice Call...",
              style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 40),
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.white24,
              backgroundImage: widget.call.callerPic.isNotEmpty 
                  ? NetworkImage(widget.call.callerPic) 
                  : null,
              child: widget.call.callerPic.isEmpty 
                  ? const Icon(Icons.person, size: 60, color: Colors.white) 
                  : null,
            ),
            const SizedBox(height: 20),
            Text(
              widget.call.callerName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 100),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // ဖုန်းငြင်းရန် (Decline Button)
                IconButton(
                  iconSize: 64,
                  icon: const Icon(Icons.call_end, color: Colors.red),
                  onPressed: () async {
                    await _stopRingtone(); // 🎵 ဖုန်းငြင်းလိုက်တာနဲ့ အသံချက်ချင်းပိတ်မယ်
                    _incomingStreamSubscription?.cancel();
                    await _callService.endCall(widget.call.callId);
                  },
                ),
                // ဖုန်းလက်ခံရန် (Accept Button)
                IconButton(
                  iconSize: 64,
                  icon: Icon(widget.call.isVideoCall ? Icons.videocam : Icons.call, color: Colors.green),
                  onPressed: () async {
                    await _stopRingtone(); // 🎵 ဖုန်းကိုင်လိုက်တာနဲ့ အသံချက်ချင်းပိတ်မယ်
                    _incomingStreamSubscription?.cancel();
                    
                    final navigatorContext = context;
                    await _callService.acceptCall(widget.call.callId);
                    
                    if (!navigatorContext.mounted) return;
                    Navigator.pushReplacement(
                      navigatorContext,
                      MaterialPageRoute(
                        builder: (context) => CallScreen(
                          callDocId: widget.call.callId,
                          channelId: widget.call.channelId,
                          receiverId: widget.call.callerId,
                          receiverName: widget.call.callerName,
                          isVideoCall: widget.call.isVideoCall,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}