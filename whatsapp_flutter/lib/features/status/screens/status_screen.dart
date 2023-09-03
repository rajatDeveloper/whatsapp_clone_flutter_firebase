import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:story_view/story_view.dart';
import 'package:whatsapp_flutter/common/widgets/loder.dart';
import 'package:whatsapp_flutter/models/status_model.dart';

class StatusScreen extends StatefulWidget {
  static const routeName = '/statusScreen';
  final Status status;
  const StatusScreen({super.key, required this.status});

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  // StoryController storyController = StoryController();
  // List<StoryItem> storyItems = [];

  void initStroyPageItems() {
    // for (int i = 0; i < widget.status.photoUrl.length; i++) {
    //   log("test $i");
    //   storyItems.add(StoryItem.pageImage(
    //     url: widget.status.photoUrl[i],
    //     controller: storyController,
    //   ));
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initStroyPageItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.close),
            )
          ],
        ),
        body:
            // storyItems.isEmpty
            //     ? const Loder()
            //     :
            Center(child: Image.network(widget.status.photoUrl[0])));
    // StoryView(
    //     storyItems: storyItems,
    //     controller: storyController,
    //     inline: false,
    //     repeat: false,
    //     onVerticalSwipeComplete: (direction) {
    //       if (direction == Direction.down) {
    //         Navigator.pop(context);
    //       }
    //     },
    //     onComplete: () {
    //       Navigator.pop(context);
    //     },
    //   ));
  }
}
