import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/common/provider/message_reply_provider.dart';
import 'package:whatsapp_flutter/common/widgets/image_gif_card.dart';
import 'package:whatsapp_flutter/utils/functions.dart';

class MessageReplyPreview extends ConsumerWidget {
  const MessageReplyPreview({super.key});

  void cancelReply(WidgetRef ref) {
    ref.read(messageReplyProvider.state).update((state) => null);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messageReply = ref.watch(messageReplyProvider);
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10))),
      width: getDeviceWidth(context),
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: Text(
                messageReply!.isMe ? 'Me' : 'Opposite',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: getFontSize(16, getDeviceWidth(context))),
              )),
              GestureDetector(
                onTap: () {
                  cancelReply(ref);
                },
                child: Icon(
                  Icons.close,
                  size: getDeviceWidth(context) * 0.05,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          ImageTextGifCard(
              messageType: messageReply.messageEnum,
              message: messageReply.message)
        ],
      ),
    );
  }
}
