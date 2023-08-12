import 'dart:io';

import 'package:enough_giphy_flutter/enough_giphy_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showSnakBar({required BuildContext context, required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

Future<File?> pickImageFromGallery({
  required BuildContext context,
}) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnakBar(context: context, message: e.toString());
  }
  return image;
}

Future<File?> pickVideoFromGallery({
  required BuildContext context,
}) async {
  File? video;
  try {
    final pickedVideo =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedVideo != null) {
      video = File(pickedVideo.path);
    }
  } catch (e) {
    showSnakBar(context: context, message: e.toString());
  }
  return video;
}

Future<GiphyGif?> pickGiF({
  required BuildContext context,
}) async {
  GiphyGif? gif;
  try {
    // PLlP1pOSZbNFr1XsB8sSqjeuvSMtKJ7z

    gif = await Giphy.getGif(
        context: context, apiKey: "PLlP1pOSZbNFr1XsB8sSqjeuvSMtKJ7z");
  } catch (e) {
    showSnakBar(context: context, message: e.toString());
  }
  return gif;
}
