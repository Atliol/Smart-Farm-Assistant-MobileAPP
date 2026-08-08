class CallModel {
  final String callId;
  final String callerId;
  final String callerName;
  final String receiverId;
  final String receiverName;
  final String channelId;
  final String status; // 'dialing', 'ringing', 'connected', 'ended'
  final bool isVideoCall;

  CallModel({
    required this.callId,
    required this.callerId,
    required this.callerName,
    required this.receiverId,
    required this.receiverName,
    required this.channelId,
    required this.status,
    required this.isVideoCall,
  });

  Map<String, dynamic> toMap() {
    return {
      'callId': callId,
      'callerId': callerId,
      'callerName': callerName,
      'receiverId': receiverId,
      'receiverName': receiverName,
      'channelId': channelId,
      'status': status,
      'isVideoCall': isVideoCall,
    };
  }

  factory CallModel.fromMap(Map<String, dynamic> map) {
    return CallModel(
      callId: map['callId'] ?? '',
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? '',
      receiverId: map['receiverId'] ?? '',
      receiverName: map['receiverName'] ?? '',
      channelId: map['channelId'] ?? '',
      status: map['status'] ?? 'dialing',
      isVideoCall: map['isVideoCall'] ?? false,
    );
  }
}