import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/features/auth/group/controller/group_controller.dart';
import 'package:whatsapp_flutter/features/auth/group/widgets/select_contacts_for_group.dart';
import 'package:whatsapp_flutter/utils/functions.dart';
import 'package:whatsapp_flutter/utils/utils.dart';

class CreateGroupScreen extends ConsumerStatefulWidget {
  static const routeName = '/create-group-screen';
  const CreateGroupScreen({super.key});

  @override
  ConsumerState<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends ConsumerState<CreateGroupScreen> {
  File? image;
  final _groupNameController = TextEditingController();

  void selectImage() async {
    image = await pickImageFromGallery(context: context);
    setState(() {});
  }

  void createGroup() {
    if (_groupNameController.text.trim().isNotEmpty && image != null) {
      ref.read(groupControllerProvider).createGroup(
          context: context,
          groupName: _groupNameController.text.trim(),
          groupPic: image!,
          selectedContacts: ref.read(selectedContactGroups));
      ref.read(selectedContactGroups.state).update((state) => []);
      Navigator.pop(context);
    } else {
      showSnakBar(
          context: context,
          message: "Pls enter group name and select group image");
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _groupNameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Group'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createGroup();
        },
        child: const Icon(Icons.done),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                image == null
                    ? const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg"),
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(image!),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () {
                      selectImage();
                    },
                    icon: const Icon(Icons.camera_alt),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _groupNameController,
                decoration: const InputDecoration(
                  hintText: 'Group Name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Select Participants",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: getFontSize(16, getDeviceWidth(context))),
                ),
              ),
            ),
            SizedBox(
                height: getDeviceHeight(context) * 0.7,
                child: const SelectContactGroup())
          ],
        ),
      ),
    );
  }
}
