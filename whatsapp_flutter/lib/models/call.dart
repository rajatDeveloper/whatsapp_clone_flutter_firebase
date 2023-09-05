import 'dart:convert';

class Call {
  final String callerId;
  final String callerName;
  final String callPic;
  final String recevierId;
  final String recevierName;
  final String recevierPic;
  final bool hasDialled;
  final String callId; 

  Call({
    required this.callerId,
    required this.callerName,
    required this.callPic,
    required this.recevierId,
    required this.recevierName,
    required this.recevierPic,
    required this.hasDialled,
    required this.callId,
  });

  Map<String, dynamic> toMap() {
    return {
      'callerId': callerId,
      'callerName': callerName,
      'callPic': callPic,
      'recevierId': recevierId,
      'recevierName': recevierName,
      'recevierPic': recevierPic,
      'hasDialled': hasDialled,
      'callId': callId,
    };
  }

  factory Call.fromMap(Map<String, dynamic> map) {
    return Call(
      callerId: map['callerId'] ?? '',
      callerName: map['callerName'] ?? '',
      callPic: map['callPic'] ?? '',
      recevierId: map['recevierId'] ?? '',
      recevierName: map['recevierName'] ?? '',
      recevierPic: map['recevierPic'] ?? '',
      hasDialled: map['hasDialled'] ?? false,
      callId: map['callId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Call.fromJson(String source) => Call.fromMap(json.decode(source));
}
