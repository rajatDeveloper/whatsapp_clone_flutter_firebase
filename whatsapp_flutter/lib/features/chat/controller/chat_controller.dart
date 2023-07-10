import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/features/auth/controller/authController.dart';
import 'package:whatsapp_flutter/features/chat/repo/chat_repo.dart';
import 'package:whatsapp_flutter/models/chat_contact.dart';

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

  // Stream<List<ChatContact>> chatContacts() {
  //   return chatRepo.getChatContacts();
  // }
}
