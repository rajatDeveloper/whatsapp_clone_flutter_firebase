import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
// import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:whatsapp_flutter/common/enums/messages_enum.dart';
import 'package:whatsapp_flutter/common/widgets/video_player.dart';

class ImageTextGifCard extends StatelessWidget {
  const ImageTextGifCard({
    Key? key,
    required this.messageType,
    required this.message,
  }) : super(key: key);
  final MessageEnum messageType;
  final String message;

  @override
  Widget build(BuildContext context) {
    bool isPlaying = false;
    final AudioPlayer audioPlayer = AudioPlayer();

    return messageType == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 16),
          )
        : messageType == MessageEnum.image
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.network(
                  message,
                  fit: BoxFit.contain,
                ),
              )
            : messageType == MessageEnum.audio
                ? StatefulBuilder(builder: (context, setState) {
                    return IconButton(
                        onPressed: () async {
                          if (isPlaying) {
                            await audioPlayer.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            await audioPlayer.play(UrlSource(message));
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        },
                        icon: Icon(isPlaying
                            ? Icons.pause_circle
                            : Icons.play_circle));
                  })
                : messageType == MessageEnum.video
                    ? VideoPlayerCachedItem(url: message)
                    : messageType == MessageEnum.gif
                        ? Image.network(
                            message,
                            fit: BoxFit.contain,
                          )
                        : Container();
  }
}
