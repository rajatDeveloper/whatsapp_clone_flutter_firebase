import 'dart:convert';

import 'package:whatsapp_flutter/common/enums/messages_enum.dart';

class Message {
  final String senderId;
  final String recieverid;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  final String repiledMessage;
  final String repiledTo;
  final MessageEnum repiledMessageType;

  Message({
    required this.repiledMessage,
    required this.repiledTo,
    required this.repiledMessageType,
    required this.senderId,
    required this.recieverid,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'recieverid': recieverid,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'messageId': messageId,
      'isSeen': isSeen,
      'repiledMessage': repiledMessage,
      'repiledTo': repiledTo,
      'repiledMessageType': repiledMessageType.type,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] ?? '',
      recieverid: map['recieverid'] ?? '',
      text: map['text'] ?? '',
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      messageId: map['messageId'] ?? '',
      isSeen: map['isSeen'] ?? false,
      repiledMessage: map['repiledMessage'] ?? '',
      repiledTo: map['repiledTo'] ?? '',
      repiledMessageType: (map['repiledMessageType'] as String).toEnum(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));
}
