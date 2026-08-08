import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

const String agoraAppId = "ba1d817bc8f641d29036198cbc46ec81"; 
const String? agoraToken = null; 

class CallScreen extends StatefulWidget {
  final String channelId;    
  final String receiverName;
  final bool isVideoCall;    

  const CallScreen({
    super.key, 
    required this.channelId, 
    required this.receiverName, 
    required this.isVideoCall,
  });

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  int? _remoteUid; 
  bool _localUserJoined = false;
  bool _muted = false;
  bool _speakerOn = false; // Speaker status tracking
  late RtcEngine _engine;
  bool _isEngineInitialized = false;

  @override
  void initState() {
    super.initState();
    initAgora();
  }

  Future<void> initAgora() async {
    // 🎙️ Call အမျိုးအစားအလိုက် လိုအပ်တဲ့ Permission ကိုပဲ တောင်းခံခြင်း
    if (widget.isVideoCall) {
      await [Permission.microphone, Permission.camera].request();
    } else {
      await Permission.microphone.request();
    }

    // 🔧 Agora Engine ကို ဖန်တီးပြီး ပြင်ဆင်ခြင်း
    _engine = createAgoraRtcEngine();
    
    // One-to-One Call ဖြစ်တဲ့အတွက် channelProfileCommunication ကို အသုံးပြုရပါမည်
    await _engine.initialize(const RtcEngineContext(
      appId: agoraAppId,
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    // 📡 Event Handler များ သတ်မှတ်ခြင်း
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("Local user ${connection.localUid} joined");
          if (mounted) {
            setState(() {
              _localUserJoined = true;
            });
          }
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("Remote user $remoteUid joined");
          if (mounted) {
            setState(() {
              _remoteUid = remoteUid;
            });
          }
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("Remote user $remoteUid left channel");
          if (mounted) {
            setState(() {
              _remoteUid = null;
            });
            Navigator.pop(context); 
          }
        },
      ),
    );

    // 📹 Video သို့မဟုတ် 📞 Audio စနစ်ကို Call Type အပေါ်မူတည်ပြီး ဖွင့်ပေးခြင်း
    if (widget.isVideoCall) {
      await _engine.enableVideo();
      await _engine.startPreview();
      _speakerOn = true; // Video Call ဆိုလျှင် Speakerphone တခါတည်းဖွင့်မည်
    } else {
      await _engine.enableAudio();
      _speakerOn = false; // Voice Call ဆိုလျှင် နားနှင့်ကပ်ပြောရမည့် Earpiece အတိုင်းသွားမည်
    }

    // Speaker phone အခြေအနေကို Engine ထံ သတ်မှတ်ပေးခြင်း
    await _engine.setEnableSpeakerphone(_speakerOn);

    // 🚀 Channel ထဲသို့ ဝင်ရောက်ခြင်း
    await _engine.joinChannel(
      token: agoraToken ?? '',
      channelId: widget.channelId,
      uid: 0, 
      options: ChannelMediaOptions(
        // Communication Profile တွင် clientRole ကို ထည့်သွင်းရန် မလိုအပ်ပါ
        publishCameraTrack: widget.isVideoCall,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
        autoSubscribeVideo: widget.isVideoCall,
      ),
    );

    if (mounted) {
      setState(() {
        _isEngineInitialized = true;
      });
    }
  }

  @override
  void dispose() {
    _disposeAgora();
    super.dispose();
  }

  Future<void> _disposeAgora() async {
    try {
      if (widget.isVideoCall) {
        await _engine.stopPreview();
      }
      await _engine.leaveChannel();
      await _engine.release();
    } catch (e) {
      debugPrint("Agora release error: $e");
    }
  }

  void _onToggleMute() {
    setState(() {
      _muted = !_muted;
    });
    _engine.muteLocalAudioStream(_muted);
  }

  void _onToggleSpeaker() {
    setState(() {
      _speakerOn = !_speakerOn;
    });
    _engine.setEnableSpeakerphone(_speakerOn);
  }

  void _onCallEnd() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // Engine အလုပ်လုပ်ရန် ပြင်ဆင်နေစဉ် ခဏစောင့်ခိုင်းသည့် UI ပြသခြင်း
    if (!_isEngineInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff1f2f6), 
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            
            // 👤 Receiver Name
            Text(
              widget.receiverName,
              style: const TextStyle(
                color: Color(0xff1c2b70), 
                fontSize: 26, 
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // 🟢 Status or Timer
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 4,
                  backgroundColor: _remoteUid == null ? Colors.orange : Colors.green,
                ),
                const SizedBox(width: 8),
                Text(
                  _remoteUid == null ? "ခေါ်ဆိုနေပါသည်..." : "00:01", // ဒုတိယမြောက်လူဝင်လာလျှင် အသံချိတ်ဆက်မှုရပြီဖြစ်ကြောင်း ပြသရန်
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ],
            ),
            
            const SizedBox(height: 30),

            // 📺 View Area (Video Or Custom Oval Design for Voice Call)
            Expanded(
              child: _viewRows(),
            ),

            const SizedBox(height: 20),

            // 🎛️ 2x3 Grid Buttons Control Panel
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildControlButton(
                        icon: _muted ? Icons.mic_off : Icons.mic,
                        label: "Mute",
                        isActive: _muted,
                        onTap: _onToggleMute,
                      ),
                      _buildControlButton(
                        icon: Icons.dialpad,
                        label: "Keypad",
                        onTap: () {},
                      ),
                      _buildControlButton(
                        icon: _speakerOn ? Icons.volume_up : Icons.volume_down,
                        label: "Speaker",
                        isActive: _speakerOn,
                        onTap: _onToggleSpeaker,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildControlButton(
                        icon: Icons.person_add_alt_1,
                        label: "Add call",
                        onTap: () {},
                      ),
                      _buildControlButton(
                        icon: Icons.videocam,
                        label: "Video call",
                        isActive: widget.isVideoCall,
                        onTap: () {},
                      ),
                      _buildControlButton(
                        icon: Icons.pause_circle_outline,
                        label: "Hold",
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // 🔴 End Call Button
            InkWell(
              onTap: _onCallEnd,
              customBorder: const CircleBorder(),
              child: Container(
                width: 75,
                height: 75,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffb81c1c), 
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ],
                ),
                child: const Icon(
                  Icons.call_end,
                  color: Colors.white,
                  size: 36,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  // 📺 View Render Widget
  Widget _viewRows() {
    if (!widget.isVideoCall) {
      // 📞 Voice Call UI Design
      return Center(
        child: Container(
          width: 260,
          height: 380,
          decoration: BoxDecoration(
            color: const Color(0xffe4e7f2), 
            borderRadius: BorderRadius.circular(130), 
          ),
          child: Center(
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  )
                ],
                image: const DecorationImage(
                  image: NetworkImage("https://picsum.photos/200"), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      );
    }

    // 📹 Video Call View Area
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Remote Video View (FullScreen Inside Container)
            Center(
              child: _remoteUid != null
                  ? AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: _engine,
                        canvas: VideoCanvas(uid: _remoteUid),
                        connection: RtcConnection(channelId: widget.channelId),
                      ),
                    )
                  : const Center(
                      child: Text(
                        'တစ်ဖက်လူကို စောင့်ဆိုင်းနေပါသည်...',
                        style: TextStyle(color: Color(0xff1c2b70), fontSize: 16),
                      ),
                    ),
            ),
            // Local Preview (Pip Window)
            if (_localUserJoined)
              Positioned(
                right: 16,
                top: 16,
                width: 100,
                height: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _engine,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // 🎛️ UI Helper for Controls
  Widget _buildControlButton({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? const Color(0xff1c2b70) : Colors.white,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                )
              ],
            ),
            child: Icon(
              icon,
              color: isActive ? Colors.white : const Color(0xff4a4a4a),
              size: 26,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xff555555),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}