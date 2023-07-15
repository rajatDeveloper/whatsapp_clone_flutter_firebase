import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/common/utils/myData.dart';
import 'package:whatsapp_flutter/features/auth/controller/authController.dart';
import 'package:whatsapp_flutter/features/chat/repo/chat_repo.dart';
import 'package:whatsapp_flutter/models/chat_contact.dart';
import 'package:whatsapp_flutter/models/message.dart';
import 'package:whatsapp_flutter/models/userModel.dart';

final chatControllerProvider = Provider.autoDispose(
  (ref) => ChatController(
    chatRepo: ref.watch(chatRepoProvider),
    ref: ref,
  ),
);

class ChatController {
  final ChatRepo chatRepo;
  final ProviderRef ref;

  ChatController({
    required this.chatRepo,
    required this.ref,
  });

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
  }) async {
    chatRepo.sendtextMsg(
        context: context,
        text: text,
        recieverUserId: recieverUserId,
        senderUser: MyData.currentUserData!);
  }

  Stream<List<ChatContact>> getChatContacts() {
    return chatRepo.getChatList();
  }

  Stream<List<Message>> getChatStream({
    required String recieverUserId,
  }) {
    return chatRepo.getChatStream(recieverUserId: recieverUserId);
  }
}
