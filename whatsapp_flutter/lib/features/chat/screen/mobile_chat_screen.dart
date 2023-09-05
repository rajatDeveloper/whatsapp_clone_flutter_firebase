import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/colors.dart';
import 'package:whatsapp_flutter/common/widgets/loder.dart';
import 'package:whatsapp_flutter/features/auth/controller/authController.dart';
import 'package:whatsapp_flutter/features/call/controller/call_controller.dart';
import 'package:whatsapp_flutter/features/chat/widgets/chat_text_field.dart';
import 'package:whatsapp_flutter/info.dart';
import 'package:whatsapp_flutter/models/userModel.dart';
import 'package:whatsapp_flutter/utils/functions.dart';
import 'package:whatsapp_flutter/features/chat/screen/chat_list.dart';

class MobileChatScreen extends ConsumerWidget {
  static const String routeName = '/mobileChatScreen';
  final String name;
  final String uid;
  final bool isGroupChat;
  final String profilePic;
  const MobileChatScreen(
      {Key? key,
      required this.profilePic,
      required this.isGroupChat,
      required this.name,
      required this.uid})
      : super(key: key);

  void makeCall({required WidgetRef ref, required BuildContext context}) {
    ref.read(callControllerProvider).makeCall(
          context: context,
          receiverName: name,
          receverProfilePic: profilePic,
          recevierUid: uid,
          isGroupChat: isGroupChat,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: isGroupChat
            ? Text(name,
                style: TextStyle(
                    fontSize: getFontSize(12, getDeviceWidth(context))))
            : StreamBuilder<UserModel?>(
                stream: ref
                    .read(authControllerProvider)
                    .getUserDataStream(ueserId: uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(height: 30, child: Loder());
                  }
                  return Container(
                    alignment: Alignment.centerLeft,
                    height: 30,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: getFontSize(12, getDeviceWidth(context)),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(snapshot.data!.isOnline ? 'Online' : 'Offline',
                            style: TextStyle(
                              fontSize:
                                  getFontSize(10, getDeviceWidth(context)),
                            )),
                      ],
                    ),
                  );
                }),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () => makeCall(ref: ref, context: context),
            icon: const Icon(Icons.video_call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.call),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatList(
              recieverUserId: uid,
              isGroupChat: isGroupChat,
            ),
          ),
          ChatTextField(
            recieverUserId: uid,
            isGroupChat: isGroupChat,
          ),
        ],
      ),
    );
  }
}
