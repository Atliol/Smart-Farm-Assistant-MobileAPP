import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models/call_model.dart';
import 'services/call_service.dart';
import 'call_screen.dart';

class IncomingCallScreen extends StatefulWidget {
  final CallModel call;
  const IncomingCallScreen({super.key, required this.call});

  @override
  State<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends State<IncomingCallScreen> {
  final CallService _callService = CallService();
  final AudioPlayer _ringtonePlayer = AudioPlayer();
  StreamSubscription? _incomingStreamSubscription;

  @override
  void initState() {
    super.initState();
    _ringtonePlayer.setReleaseMode(ReleaseMode.loop);

    _incomingStreamSubscription = FirebaseFirestore.instance
        .collection('calls')
        .doc(widget.call.callId)
        .snapshots()
        .listen((doc) {
      if (!doc.exists && mounted) {
        _stopRingtone();
        Navigator.pop(context);
      }
    });

    _playRingtone();
  }

  Future<void> _playRingtone() async {
    try {
      await _ringtonePlayer.play(AssetSource('audio/ringtone.mp3'), volume: 1.0);
    } catch (e) {
      debugPrint('❌ Ringtone playback error: $e');
    }
  }

  Future<void> _stopRingtone() async {
    try {
      await _ringtonePlayer.stop();
    } catch (e) {
      debugPrint('❌ Stop ringtone error: $e');
    }
  }

  @override
  void dispose() {
    _incomingStreamSubscription?.cancel();
    _stopRingtone();
    _ringtonePlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ပုံထဲကလို နာမည်ပထမစာလုံးကို ယူဖို့ (ဥပမာ- Kyi Phyu ဆိုရင် 'K')
    final String initialLetter = widget.call.callerName.isNotEmpty
        ? widget.call.callerName[0].toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: const Color(0xFF009688), // ပုံထဲကလို Teal Color
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // အပေါ်၊ အလယ်၊ အောက် မျှပေးဖို့
            children: [
              // --- အပေါ်ပိုင်း စာသား ---
              Column(
                children: [
                  const Text(
                    "Incoming Call",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 100), // ပုံထဲကလို အလယ်ပိုင်းနဲ့ ကွာအောင်
                  const Text(
                    "ဖုန်းခေါ်ဆိုမှု ဝင်လာနေပါသည်...",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                      fontFamily: 'Pyidaungsu', // မြန်မာစာ font သုံးထားရင် ထည့်ပေးပါ
                    ),
                  ),
                ],
              ),

              // --- အလယ်ပိုင်း Profile Avatar & Name ---
              Column(
                children: [
                  // Outer soft circle effect
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      shape: BoxShape.circle,
                    ),
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      backgroundImage: widget.call.callerPic.isNotEmpty
                          ? NetworkImage(widget.call.callerPic)
                          : null,
                      child: widget.call.callerPic.isEmpty
                          ? Text(
                        initialLetter,
                        style: const TextStyle(
                            fontSize: 40,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.call.callerName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.blur_on, color: Colors.white54, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        widget.call.isVideoCall ? "Video Call..." : "Audio Call...",
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // --- အောက်ခြေ ဖုန်းလက်ခံ/ငြင်းရန် ခလုတ်များ ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Decline Button (ဖုန်းငြင်းရန်)
                  GestureDetector(
                    onTap: () async {
                      _incomingStreamSubscription?.cancel();
                      _stopRingtone();
                      await _callService.endCall(widget.call.callId);
                    },
                    child: const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.call_end, color: Colors.white, size: 32),
                    ),
                  ),

                  // Accept Button (ဖုန်းလက်ခံရန်)
                  GestureDetector(
                    onTap: () async {
                      _incomingStreamSubscription?.cancel();
                      _stopRingtone(); // ဖုန်းလက်ခံလိုက်ရင် ရင်တုန်းသံ ပိတ်မယ်
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
                    child: CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.green,
                      child: Icon(
                          widget.call.isVideoCall ? Icons.videocam : Icons.call,
                          color: Colors.white,
                          size: 32
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}