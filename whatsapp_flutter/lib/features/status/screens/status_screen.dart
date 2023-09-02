import 'package:flutter/material.dart';
// import 'package:story_view/controller/story_controller.dart';
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
        body:
            // storyItems.isEmpty
            //     ? const Loder()
            //     :
            Text(widget.status.profilePic.length.toString())
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
        //   )
        );
  }
}
