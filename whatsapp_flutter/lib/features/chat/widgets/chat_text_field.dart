import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/colors.dart';
import 'package:whatsapp_flutter/common/enums/messages_enum.dart';
import 'package:whatsapp_flutter/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_flutter/utils/functions.dart';
import 'package:whatsapp_flutter/utils/utils.dart';

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

  bool isShowEmojiContainer = false;

  void sendTextMessage() async {
    if (isShowSendBtn) {
      ref.read(chatControllerProvider).sendTextMessage(
            context: context,
            text: _messageController.text,
            recieverUserId: widget.recieverUserId,
          );
      setState(() {
        _messageController.text = '';
      });
    }
  }

  void selectFile({
    required File file,
    required MessageEnum messageType,
  }) async {
    ref.read(chatControllerProvider).sendFileMessage(
        context: context,
        recieverUserId: widget.recieverUserId,
        messageType: MessageEnum.image,
        file: file);
  }

  void selectImage() async {
    File? file = await pickImageFromGallery(context: context);

    if (file != null) {
      ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          recieverUserId: widget.recieverUserId,
          messageType: MessageEnum.image,
          file: file);
    }
  }

  void selectVideo() async {
    File? file = await pickVideoFromGallery(context: context);

    if (file != null) {
      ref.read(chatControllerProvider).sendFileMessage(
          context: context,
          recieverUserId: widget.recieverUserId,
          messageType: MessageEnum.video,
          file: file);
    }
  }

  void selectGif() async {
    GiphyGif? file = await pickGiF(context: context);

    if (file != null) {


      ref.read(chatControllerProvider).sendGIfMessage(
          context: context,
          gifUrl: file.url,
          recieverUserId: widget.recieverUserId);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = !isShowEmojiContainer;
    });
  }

  void hideEmojiConatiner() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  FocusNode focusNode = FocusNode();

  void showKeyBorad() {
    focusNode.requestFocus();
  }

  void hideKeyBorad() {
    focusNode.unfocus();
  }

  void toggleEmojiKeyBorad() {
    if (isShowEmojiContainer) {
      showKeyBorad();
      hideEmojiConatiner();
    } else {
      hideKeyBorad();
      showEmojiContainer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          SizedBox(
            width: getDeviceWidth(context) * 0.82,
            child: TextFormField(
              focusNode: focusNode,
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
                            onPressed: toggleEmojiKeyBorad,
                            icon: Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            )),
                        IconButton(
                            onPressed: () {
                              selectGif();
                            },
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
                        onPressed: () {
                          selectImage();
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          selectVideo();
                        },
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
        ]),
        Visibility(
          visible: isShowEmojiContainer,
          child: SizedBox(
              width: getDeviceWidth(context),
              height: getDeviceHeight(context) * 0.4,
              child: EmojiPicker(
                onEmojiSelected: (category, emoji) {
                  _messageController.text += emoji.emoji;
                  setState(() {});
                  isShowSendBtn = _messageController.text.isNotEmpty;
                },
              )),
        )
      ],
    );
  }
}
