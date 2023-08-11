import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_flutter/common/enums/messages_enum.dart';

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
    return messageType == MessageEnum.text
        ? Text(
            message,
            style: const TextStyle(fontSize: 16),
          )
        : messageType == MessageEnum.image
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  imageUrl: message,
                  fit: BoxFit.contain,
                ),
              )
            : Container();
  }
}
