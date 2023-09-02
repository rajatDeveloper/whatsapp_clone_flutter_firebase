import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/common/utils/myData.dart';
import 'package:whatsapp_flutter/features/auth/controller/authController.dart';
import 'package:whatsapp_flutter/features/status/repo/status_repo.dart';
import 'package:whatsapp_flutter/models/status_model.dart';

final statusControllerProvider = Provider((ref) {
  final statusRepo = ref.watch(statusRepoProvider);
  return StatusController(
    statusRepo: statusRepo,
    ref: ref,
  );
});

class StatusController {
  final StatusRepo statusRepo;
  final ProviderRef ref;

  StatusController({required this.statusRepo, required this.ref});

  void addStatus({
    required File file,
    required BuildContext context,
  }) {
    // ref.watch(UserDataAuthProvier).whenData((value) => statusRepo.uploadStatus(
    //       username: value!.name,
    //       profilePic: value.profilePic,
    //       phoneNumber: value.phoneNumber,
    //       statusImage: file,
    //       context: context,
    //     ));
    statusRepo.uploadStatus(
        username: MyData.currentUserData!.name,
        profilePic: MyData.currentUserData!.profilePic,
        phoneNumber: MyData.currentUserData!.phoneNumber,
        statusImage: file,
        context: context);
  }

  Future<List<Status>> getStatus({
    required BuildContext context,
  }) async {
    var data = await statusRepo.getStatus(context);
    log("status nummber : ${data.length}");
    return data;
  }
}
