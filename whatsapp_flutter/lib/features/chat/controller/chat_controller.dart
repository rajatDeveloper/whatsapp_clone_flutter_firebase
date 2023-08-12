import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/common/enums/messages_enum.dart';
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

  void sendFileMessage({
    required BuildContext context,
    required String recieverUserId,
    required MessageEnum messageType,
    required File file,
  }) async {
    chatRepo.sendFileMessage(
        context: context,
        file: file,
        recieverUserId: recieverUserId,
        senderUserData: MyData.currentUserData!,
        ref: ref,
        messageType: messageType);
  }

  void sendGIfMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
  }) async {
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

    chatRepo.sendGifMsg(
        context: context,
        gifUrl: newgifUrl,
        recieverUserId: recieverUserId,
        senderUser: MyData.currentUserData!);
  }
}
