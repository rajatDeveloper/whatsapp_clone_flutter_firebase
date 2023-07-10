import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/colors.dart';
import 'package:whatsapp_flutter/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_flutter/utils/functions.dart';

class ChatTextField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const ChatTextField({
    required this.recieverUserId,
    super.key,
  });

  @override
  ConsumerState<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends ConsumerState<ChatTextField> {
  bool isShowSendBtn = false;
  final TextEditingController _messageController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  void sendTextMessage() async {
    if (isShowSendBtn) {
      setState(() {
        _messageController.text = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
        width: getDeviceWidth(context) * 0.82,
        child: TextFormField(
          controller: _messageController,
          onChanged: (val) {
            setState(() {
              isShowSendBtn = val.isNotEmpty;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: mobileChatBoxColor,
            prefixIcon: SizedBox(
              width: 100,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.gif,
                          color: Colors.grey,
                        ))
                  ],
                ),
              ),
            ),
            suffixIcon: SizedBox(
              width: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.grey,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.attach_file,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            hintText: 'Type a message!',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: const BorderSide(
                width: 0,
                style: BorderStyle.none,
              ),
            ),
            contentPadding: const EdgeInsets.all(10),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.only(left: 5.0),
        child: CircleAvatar(
          backgroundColor: const Color(0xFF128C7E),
          radius: 25,
          child: GestureDetector(
            onTap: () {
              sendTextMessage();
            },
            child: Icon(
              isShowSendBtn ? Icons.send : Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
      )
    ]);
  }
}
