import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/features/auth/controller/authController.dart';
import 'package:whatsapp_flutter/utils/functions.dart';
import 'package:whatsapp_flutter/utils/utils.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  const UserInfoScreen({super.key});
  static const String routeName = "/user-info-screen";

  @override
  ConsumerState<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends ConsumerState<UserInfoScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
  }

  File? Image;

  void selectImage() async {
    final image = await pickImageFromGallery(context: context);
    if (image != null) {
      setState(() {
        Image = image;
      });
    }
  }

  void storeUserData() async {
    String name = _nameController.text.trim();
    if (name.isNotEmpty) {
      ref
          .read(authControllerProvider)
          .saveDataToFireBase(context: context, name: name, profilePic: Image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          children: [
            Stack(
              children: [
                Image == null
                    ? const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg"),
                      )
                    : CircleAvatar(
                        radius: 64,
                        backgroundImage: FileImage(Image!),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: () {
                      selectImage();
                    },
                    icon: Icon(Icons.camera_alt),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Container(
                  width: getDeviceWidth(context) * 0.85,
                  padding: const EdgeInsets.all(20.0),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: getFontSize(16, getDeviceWidth(context))),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    storeUserData();
                  },
                  icon: Icon(Icons.done),
                )
              ],
            )
          ],
        ),
      )),
    );
  }
}
