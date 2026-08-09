import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  RtcEngine? _engine;
  RtcEngine? get engine => _engine;

  static const String appId = 'ba1d817bc8f641d29036198cbc46ec81';

  Future<void> initialize({
    required bool isVideoCall, // 🛠️ Fixed: Named parameter အဖြစ် သေချာသတ်မှတ်ပြီး required လုပ်လိုက်ပါတယ်
    required Function(int uid) onUserJoined,
    required Function(int uid) onUserOffline,
  }) async {
    try {
      if (isVideoCall) {
        final permissions = await [
          Permission.microphone,
          Permission.camera,
        ].request();

        final micGranted = permissions[Permission.microphone]?.isGranted ?? false;
        final cameraGranted = permissions[Permission.camera]?.isGranted ?? false;

        if (!micGranted || !cameraGranted) {
          throw Exception('Microphone နှင့် Camera permission လိုအပ်ပါသည်။');
        }
      } else {
        final microphonePermission = await Permission.microphone.request();
        if (!microphonePermission.isGranted) {
          throw Exception('Microphone permission လိုအပ်ပါသည်။');
        }
      }

      if (_engine != null) {
        await leaveChannel();
      }

      _engine = createAgoraRtcEngine();
      
      // 🛠️ Fixed: Channel Profile ကို Engine Context မှာ စနစ်တကျ သတ်မှတ်ပေးလိုက်ပါတယ်
      await _engine!.initialize(
        const RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileCommunication, // Call သီးသန့် Profile
        ),
      );

      // 🛠️ Fixed: Client Role ကို Broadcaster (ထုတ်လွှင့်သူ) အဖြစ် သတ်မှတ်ပေးလိုက်ပါတယ် (ပုံနှင့်အသံ ထွက်စေရန်)
      await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

      debugPrint('✅ Agora engine initialized');

      _engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint('✅ Joined Agora channel: ${connection.channelId}');
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint('👤 Remote user joined: $remoteUid');
            onUserJoined(remoteUid);
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            debugPrint('📴 Remote user left: $remoteUid, Reason: $reason');
            onUserOffline(remoteUid);
          },
          onError: (ErrorCodeType errorCode, String message) {
            debugPrint('❌ Agora Error: $errorCode - $message');
          },
          // 🛠️ Debug ပိုမိုလွယ်ကူစေရန် အသံ Stream အခြေအနေကို Listen လုပ်ခြင်း
          onRemoteAudioStateChanged: (connection, remoteUid, state, reason, elapsed) {
            debugPrint('🎙️ Remote Audio State for User $remoteUid: $state');
          },
        ),
      );

      await _engine!.enableAudio();

      if (isVideoCall) {
        await _engine!.enableVideo();
        await _engine!.startPreview();
        debugPrint('📹 Video enabled');
      } else {
        debugPrint('🎙️ Audio call initialized');
      }
    } catch (e) {
      debugPrint('❌ Agora initialization error: $e');
      rethrow;
    }
  }

  Future<void> joinChannel({
    required String channelId,
    String token = '',
    int uid = 0,
    bool isVideoCall = true,
  }) async {
    if (_engine == null) {
      throw Exception('Agora Engine is not initialized.');
    }

    try {
      await _engine!.joinChannel(
        token: token,
        channelId: channelId,
        uid: uid,
        options: ChannelMediaOptions(
          // 🛠️ Fixed: အပေါ်က Engine initialize မှာ profile ထည့်ပြီးပြီဖြစ်လို့ ဒီကောင်ကို ဖြုတ်လိုက်ပါတယ်
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          publishMicrophoneTrack: true,
          publishCameraTrack: isVideoCall,
          autoSubscribeAudio: true,      // တစ်ဖက်လူအသံကို အလိုအလျောက် နားထောင်မည်
          autoSubscribeVideo: isVideoCall, // တစ်ဖက်လူဗီဒီယိုကို အလိုအလျောက် ရယူမည်
        ),
      );
      debugPrint('📡 Joining Agora channel: $channelId');
    } catch (e) {
      debugPrint('❌ Error joining Agora channel: $e');
      rethrow;
    }
  }

  Future<void> toggleMute(bool isMuted) async {
    if (_engine == null) return;
    try {
      await _engine!.muteLocalAudioStream(isMuted);
    } catch (e) {
      debugPrint('❌ Error changing microphone: $e');
    }
  }

  Future<void> switchCamera() async {
    if (_engine == null) return;
    try {
      await _engine!.switchCamera();
    } catch (e) {
      debugPrint('❌ Error switching camera: $e');
    }
  }

  Future<void> leaveChannel() async {
    if (_engine == null) return;
    try {
      try {
        await _engine!.stopPreview();
      } catch (_) {}
      await _engine!.leaveChannel();
      await _engine!.release();
      _engine = null;
      debugPrint('📴 Left and cleaned Agora channel');
    } catch (e) {
      debugPrint('❌ Agora release error: $e');
      _engine = null;
    }
  }
}