import 'package:cloud_firestore/cloud_firestore.dart';

class CallModel {
  final String callId;
  final String callerId;
  final String callerName;
  final String callerPic;
  final String channelId;
  final bool hasDialed;
  final bool isAccepted;
  final bool isVideoCall;
  final String receiverId;
  final String status;
  final Timestamp timestamp;

  CallModel({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.callerPic,
    required this.channelId,
    required this.hasDialed,
    required this.isAccepted,
    required this.isVideoCall,
    required this.receiverId,
    required this.status,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'callId': callId,
      'callerId': callerId,
      'callerName': callerName,
      'callerPic': callerPic,
      'channelId': channelId,
      'hasDialed': hasDialed,
      'isAccepted': isAccepted,
      'isVideoCall': isVideoCall,
      'receiverId': receiverId,
      'status': status,
      'timestamp': timestamp,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callId: map['callId'] ?? '',
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? '',
      callerPic: map['callerPic'] ?? '',
      channelId: map['channelId'] ?? '',
      hasDialed: map['hasDialed'] ?? false,
      isAccepted: map['isAccepted'] ?? false,
      isVideoCall: map['isVideoCall'] ?? false,
      receiverId: map['receiverId'] ?? '',
      status: map['status'] ?? 'dialing',
      timestamp: map['timestamp'] ?? Timestamp.now(),
    );
  }
}