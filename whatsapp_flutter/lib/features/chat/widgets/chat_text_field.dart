import 'dart:developer';
import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:whatsapp_flutter/colors.dart';
import 'package:whatsapp_flutter/common/enums/messages_enum.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:whatsapp_flutter/common/provider/message_reply_provider.dart';
import 'package:whatsapp_flutter/features/chat/controller/chat_controller.dart';
import 'package:whatsapp_flutter/features/chat/widgets/message_reply_preview.dart';
import 'package:whatsapp_flutter/utils/functions.dart';
import 'package:whatsapp_flutter/utils/utils.dart';

class ChatTextField extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const ChatTextField({
    required this.recieverUserId,
    required this.isGroupChat,
    super.key,
  });

  @override
  ConsumerState<ChatTextField> createState() => _ChatTextFieldState();
}

class _ChatTextFieldState extends ConsumerState<ChatTextField> {
  bool isShowSendBtn = false;
  final TextEditingController _messageController = TextEditingController();

  bool isShowEmojiContainer = false;
  FlutterSoundRecorder? _soundRecorder;
  bool isRecoderInit = false;
  bool isRecording = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _soundRecorder = FlutterSoundRecorder();
    openAudio();
  }

  void openAudio() async {
    final status = await Permission.microphone.request();

    if (status != PermissionStatus.granted) {
      showSnakBar(context: context, message: "Permission not granted !");
    } else {
      await _soundRecorder!.openRecorder();
      isRecoderInit = true;
    }
  }

  void selectFile({
    required File file,
    required MessageEnum messageType,
  }) async {
    ref.read(chatControllerProvider).sendFileMessage(
        isGroupChat: widget.isGroupChat,
        context: context,
        recieverUserId: widget.recieverUserId,
        messageType: messageType,
        file: file);
  }

  void selectImage() async {
    File? file = await pickImageFromGallery(context: context);

    if (file != null) {
      ref.read(chatControllerProvider).sendFileMessage(
          isGroupChat: widget.isGroupChat,
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
          isGroupChat: widget.isGroupChat,
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
          isGroupChat: widget.isGroupChat,
          context: context,
          gifUrl: file.url,
          recieverUserId: widget.recieverUserId);
    }
  }

  void sendTextMessage() async {
    if (isShowSendBtn) {
      ref.read(chatControllerProvider).sendTextMessage(
            isGroupChat: widget.isGroupChat,
            context: context,
            text: _messageController.text,
            recieverUserId: widget.recieverUserId,
          );
      setState(() {
        _messageController.text = '';
      });
    } else {
      //logic for recoiding file
      var tempDir = await getTemporaryDirectory();
      var filePath = '${tempDir.path}/flutter_sound_example.aac';
      if (isRecoderInit == false) {
        return;
      }

      if (isRecording) {
        await _soundRecorder!.stopRecorder();
        selectFile(file: File(filePath), messageType: MessageEnum.audio);
      } else {
        await _soundRecorder!.startRecorder(
          toFile: filePath,
        );
      }

      setState(() {
        isRecording = !isRecording;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _messageController.dispose();
    _soundRecorder!.closeRecorder();
    isRecoderInit = false;
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
    final messageReply = ref.watch(messageReplyProvider);

    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
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
                  isShowSendBtn
                      ? Icons.send
                      : isRecording
                          ? Icons.close
                          : Icons.mic,
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
