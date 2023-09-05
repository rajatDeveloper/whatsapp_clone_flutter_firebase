import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_flutter/common/utils/myData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whatsapp_flutter/features/call/repo/call_repo.dart';
import 'package:whatsapp_flutter/models/call.dart';

final callControllerProvider = Provider((ref) {
  return CallController(
      ref: ref,
      callRepo: ref.read(
        callRepoProvider,
      ));
});

class CallController {
  final CallRepo callRepo;
  final ProviderRef ref;

  CallController({
    required this.callRepo,
    required this.ref,
  });

  Stream<DocumentSnapshot> get callStream => callRepo.callStream;

  void makeCall(
      {required BuildContext context,
      required String receiverName,
      required String recevierUid,
      required String receverProfilePic,
      required bool isGroupChat}) {
    String callId = const Uuid().v1();

    Call senderCallData = Call(
        callerId: MyData.currentUserData!.uid,
        callerName: MyData.currentUserData!.name,
        callPic: MyData.currentUserData!.profilePic,
        recevierId: recevierUid,
        recevierName: receiverName,
        recevierPic: receverProfilePic,
        callId: callId,
        hasDialled: true);

    Call reciverCallData = Call(
        callerId: MyData.currentUserData!.uid,
        callerName: MyData.currentUserData!.name,
        callPic: MyData.currentUserData!.profilePic,
        recevierId: recevierUid,
        recevierName: receiverName,
        recevierPic: receverProfilePic,
        callId: callId,
        hasDialled: false);

    callRepo.makeCall(
        senderCallData: senderCallData,
        context: context,
        reciverCallData: reciverCallData);
  }
}
