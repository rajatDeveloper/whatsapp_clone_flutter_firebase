import 'package:cached_video_player/cached_video_player.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_flutter/colors.dart';

class VideoPlayerCachedItem extends StatefulWidget {
  const VideoPlayerCachedItem({
    Key? key,
    required this.url,
  }) : super(key: key);
  final String url;

  @override
  State<VideoPlayerCachedItem> createState() => _VideoPlayerCachedItemState();
}

class _VideoPlayerCachedItemState extends State<VideoPlayerCachedItem> {
  late final CachedVideoPlayerController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = CachedVideoPlayerController.network(
      widget.url,
    )..initialize().then((_) {
        setState(() {
          controller.setVolume(1);
        });
      });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedVideoPlayer(controller),
          Align(
            alignment: Alignment.center,
            child: IconButton(
                onPressed: () {
                  if (controller.value.isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                  setState(() {});
                },
                icon: controller.value.isPlaying
                    ? const Icon(
                        Icons.pause_circle,
                        color: Colors.black,
                      )
                    : const Icon(
                        Icons.play_circle,
                        color: Colors.black,
                      )),
          )
        ],
      ),
    );
  }
}
