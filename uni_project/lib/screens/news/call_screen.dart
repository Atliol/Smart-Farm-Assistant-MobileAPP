import 'dart:async';
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import '../news/services/agora_service.dart';
import '../news/services/call_service.dart';

class CallScreen extends StatefulWidget {
  final String callDocId;
  final String channelId;
  final String receiverId;
  final String receiverName;
  final bool isVideoCall;

  const CallScreen({
    super.key,
    required this.callDocId,
    required this.channelId,
    required this.receiverId,
    required this.receiverName,
    required this.isVideoCall,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final AgoraService _agoraService = AgoraService();
  final CallService _callService = CallService();
  final AudioPlayer _dialTonePlayer = AudioPlayer(); // 🎵 Dialing Tone အတွက် Player

  int? _remoteUid;
  bool _localUserJoined = false;
  bool _isMuted = false;

  StreamSubscription? _callStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initCallSession();
  }

  Future<void> _initCallSession() async {
    // 🎵 ၁။ ဖုန်းစခေါ်တာနဲ့ "တီး... တီး..." သံကို Loop ပတ်ပြီး စဖွင့်ပါမယ်
    try {
      await _dialTonePlayer.setReleaseMode(ReleaseMode.loop);
      await _dialTonePlayer.play(AssetSource('audio/dialing_tone.mp3'));
    } catch (audioError) {
      debugPrint("🎵 Audio Player Error: $audioError");
    }

    // ၂။ Firestore မှာ Call Status ကို Listen လုပ်မယ်
    _callStreamSubscription = _callService.streamCallStatus(widget.callDocId).listen((doc) async {
      if (doc.exists && doc.data() != null) {
        var data = doc.data() as Map<String, dynamic>;
        
        // 🛠️ တစ်ဖက်လူက ဖုန်းကိုင်လိုက်ရင် (connected) "တီး... တီး..." သံကို ရပ်လိုက်မယ်
        if (data['status'] == 'connected') {
          await _stopDialTone();
        }
        
        // တစ်ဖက်လူက ဖုန်းချလိုက်ရင် (ended) UI ကနေ ဆင်းမယ်
        if (data['status'] == 'ended' && mounted) {
          _leaveAndPopUI();
        }
      } else if (!doc.exists && mounted) {
        _leaveAndPopUI();
      }
    });

    try {
      // ၃။ Agora Engine ကို Initialize လုပ်ခြင်း
      await _agoraService.initialize(
        isVideoCall: widget.isVideoCall,
        onUserJoined: (uid) async {
          setState(() => _remoteUid = uid);
          await _stopDialTone(); // 🛠️ တစ်ဖက်လူ Stream ထဲ ဝင်လာရင်လည်း အသံ သေချာပေါက်ရပ်မယ်
        },
        onUserOffline: (uid) async {
          setState(() => _remoteUid = null);
          _endCallAndLeave();
        },
      );

      // ၄။ Channel သို့ Join ခြင်း
      await _agoraService.joinChannel(
        channelId: widget.channelId,
        isVideoCall: widget.isVideoCall,
        token: '', // Testing mode
      );

      setState(() {
        _localUserJoined = true;
      });
    } catch (e) {
      debugPrint("Agora Session Init Error: $e");
      _endCallAndLeave();
    }
  }

  // 🎵 Dial Tone ကို ပိတ်ပေးမယ့် Utility Function
  Future<void> _stopDialTone() async {
    try {
      await _dialTonePlayer.stop();
    } catch (e) {
      debugPrint("Error stopping audio: $e");
    }
  }

  // Database ကနေ ဖုန်းကျသွားတဲ့အခါ သုံးမယ့် သန့်ရှင်းရေး Function
  void _leaveAndPopUI() async {
    await _stopDialTone();
    _callStreamSubscription?.cancel();
    await _agoraService.leaveChannel();
    if (mounted) Navigator.pop(context);
  }

  // ကိုယ်တိုင် ဖုန်းချခလုတ်နှိပ်သည့်အခါ သုံးမည့် Function
  Future<void> _endCallAndLeave() async {
    await _stopDialTone(); // 🎵 အသံ အရင်ပိတ်မယ်
    _callStreamSubscription?.cancel();
    await _agoraService.leaveChannel();
    await _callService.endCall(widget.callDocId);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _dialTonePlayer.dispose(); // 🛠️ Memory leak မဖြစ်အောင် Player ကို လုံးဝဖျက်ပစ်မယ်
    _callStreamSubscription?.cancel();
    _agoraService.leaveChannel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(child: _renderView()),
          
          // User Name Display
          Positioned(
            top: 60,
            left: 20,
            child: Text(
              widget.receiverName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Control Actions Panel
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Mic Mute Button
                CircleAvatar(
                  radius: 28,
                  backgroundColor: _isMuted ? Colors.white : Colors.white24,
                  child: IconButton(
                    icon: Icon(_isMuted ? Icons.mic_off : Icons.mic, color: _isMuted ? Colors.black : Colors.white),
                    onPressed: () {
                      setState(() => _isMuted = !_isMuted);
                      _agoraService.toggleMute(_isMuted);
                    },
                  ),
                ),
                // End Call Button
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.red,
                  child: IconButton(
                    iconSize: 32,
                    icon: const Icon(Icons.call_end, color: Colors.white),
                    onPressed: _endCallAndLeave,
                  ),
                ),
                // Switch Camera (Video Call ဖြစ်မှသာ ပြသမည်)
                if (widget.isVideoCall)
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.white24,
                    child: IconButton(
                      icon: const Icon(Icons.switch_camera, color: Colors.white),
                      onPressed: () => _agoraService.switchCamera(),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _renderView() {
    if (!widget.isVideoCall) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 100, color: Colors.white54),
            const SizedBox(height: 16),
            Text(
              _remoteUid != null ? "Connected" : "Voice Calling...",
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
          ],
        ),
      );
    }

    if (_localUserJoined && _remoteUid != null && _agoraService.engine != null) {
      return Stack(
        children: [
          AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: _agoraService.engine!,
              canvas: VideoCanvas(uid: _remoteUid),
              connection: RtcConnection(channelId: widget.channelId),
            ),
          ),
          Positioned(
            right: 16,
            top: 60,
            width: 120,
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: AgoraVideoView(
                controller: VideoViewController(
                  rtcEngine: _agoraService.engine!,
                  canvas: const VideoCanvas(uid: 0),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (_localUserJoined && _agoraService.engine != null) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _agoraService.engine!,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }
  }
}