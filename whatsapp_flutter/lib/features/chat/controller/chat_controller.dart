import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/common/enums/messages_enum.dart';
import 'package:whatsapp_flutter/common/provider/message_reply_provider.dart';
import 'package:whatsapp_flutter/common/utils/myData.dart';
import 'package:whatsapp_flutter/features/auth/controller/authController.dart';
import 'package:whatsapp_flutter/features/chat/repo/chat_repo.dart';
import 'package:whatsapp_flutter/models/chat_contact.dart';
import 'package:whatsapp_flutter/models/message.dart';
import 'package:whatsapp_flutter/models/userModel.dart';

final chatControllerProvider = Provider(
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
    final messageReply = ref.read(messageReplyProvider);
    chatRepo.sendtextMsg(
        context: context,
        text: text,
        recieverUserId: recieverUserId,
        senderUser: MyData.currentUserData!,
        messageReply: messageReply);

    ref.read(messageReplyProvider.state).update((state) => null);
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
    final messageReply = ref.read(messageReplyProvider);
    chatRepo.sendFileMessage(
        messageReply: messageReply,
        context: context,
        file: file,
        recieverUserId: recieverUserId,
        senderUserData: MyData.currentUserData!,
        ref: ref,
        messageType: messageType);
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void sendGIfMessage({
    required BuildContext context,
    required String gifUrl,
    required String recieverUserId,
  }) async {
    int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
    String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
    String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';
    final messageReply = ref.read(messageReplyProvider);
    chatRepo.sendGifMsg(
        messageReply: messageReply,
        context: context,
        gifUrl: newgifUrl,
        recieverUserId: recieverUserId,
        senderUser: MyData.currentUserData!);
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String recieverUserId,
    required String messageId,
  }) {
    chatRepo.setChatMessageSeen(
        context: context, recieverUserId: recieverUserId, messageId: messageId);
  }
}
