import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_flutter/common/enums/messages_enum.dart';
import 'package:whatsapp_flutter/common/provider/message_reply_provider.dart';
import 'package:whatsapp_flutter/common/utils/myData.dart';
import 'package:whatsapp_flutter/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_flutter/features/chat/widgets/my_message_card.dart';
import 'package:whatsapp_flutter/features/chat/widgets/sender_message_card.dart';

import 'package:whatsapp_flutter/models/message.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const ChatList(
      {Key? key, required this.isGroupChat, required this.recieverUserId})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    messageController.dispose();
  }

  void onMessageSwip(
      {required String message,
      required bool isMe,
      required MessageEnum messageEnum}) {
    // ignore: deprecated_member_use
    ref.read(messageReplyProvider.state).update((state) =>
        MessageReply(message: message, isMe: isMe, messageEnum: messageEnum));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Message>>(
        stream: widget.isGroupChat
            ? ref.watch(chatControllerProvider).getGroupStream(
                  groupId: widget.recieverUserId,
                )
            : ref.watch(chatControllerProvider).getChatStream(
                  recieverUserId: widget.recieverUserId,
                ),
        builder: (context, snapshot) {
          // log(snapshot.data!.length.toString());
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }

          SchedulerBinding.instance.addPostFrameCallback((_) {
            messageController
                .jumpTo(messageController.position.maxScrollExtent);
          });

          return ListView.builder(
            controller: messageController,
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final messageData = snapshot.data![index];
              var timeSent = DateFormat.Hm().format(messageData.timeSent);

              if (!messageData.isSeen &&
                  messageData.recieverid ==
                      FirebaseAuth.instance.currentUser!.uid) {
                ref.read(chatControllerProvider).setChatMessageSeen(
                    context: context,
                    recieverUserId: widget.recieverUserId,
                    messageId: messageData.messageId);
              }

              if (messageData.senderId ==
                  FirebaseAuth.instance.currentUser!.uid) {
                return MyMessageCard(
                    messageType: messageData.type,
                    message: messageData.text,
                    date: timeSent,
                    repliedText: messageData.repiledMessage,
                    username: messageData.repiledTo,
                    repiedMessageType: messageData.repiledMessageType,
                    onLeftSwipe: () {
                      onMessageSwip(
                        message: messageData.text,
                        isMe: true,
                        messageEnum: messageData.type,
                      );
                    },
                    isSeen: messageData.isSeen);
              }
              return SenderMessageCard(
                messageType: messageData.type,
                message: messageData.text,
                date: timeSent,
                repliedText: messageData.repiledMessage,
                username: messageData.repiledTo,
                repiedMessageType: messageData.repiledMessageType,
                onRightSwipe: () {
                  onMessageSwip(
                    message: messageData.text,
                    isMe: false,
                    messageEnum: messageData.type,
                  );
                },
              );
            },
          );
        });
  }
}
