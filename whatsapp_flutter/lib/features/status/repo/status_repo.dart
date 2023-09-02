import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_flutter/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_flutter/common/utils/myData.dart';
import 'package:whatsapp_flutter/models/status_model.dart';
import 'package:whatsapp_flutter/models/userModel.dart';
import 'package:whatsapp_flutter/utils/utils.dart';

final statusRepoProvider = Provider((ref) => StatusRepo(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
      ref: ref,
    ));

class StatusRepo {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  StatusRepo({required this.firestore, required this.auth, required this.ref});

  void uploadStatus(
      {required String username,
      required String profilePic,
      required String phoneNumber,
      required File statusImage,
      required BuildContext context}) async {
    try {
      var statusUid = const Uuid().v1();
      String uid = auth.currentUser!.uid;
      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('/status/$statusUid$uid', statusImage);

      List<Contact> contacts = [];

      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }

      List<String> uidWhoCanSee = [];

      for (int i = 0; i < contacts.length; i++) {
        var userDataFirebase = await firestore
            .collection('users')
            .where('phoneNumber',
                isEqualTo: contacts[i].phones[0].number.replaceAll(" ", ""))
            .get();

        if (userDataFirebase.docs.isNotEmpty) {
          var userData = UserModel.fromMap(userDataFirebase.docs[0].data());
          uidWhoCanSee.add(userData.uid);
        }
      }

      List<String> statusimageUrls = [];

      var statusesSnaphot = await firestore
          .collection('status')
          .where('uid', isEqualTo: MyData.currentUserData!.uid)
          .where('createdAt',
              isLessThan: DateTime.now().subtract(const Duration(hours: 24)))
          .get();

      if (statusesSnaphot.docs.isNotEmpty) {
        log("i am here ");
        Status status = Status.fromMap(statusesSnaphot.docs[0].data());
        statusimageUrls = status.photoUrl;
        log("added new status image to old status images ");
        statusimageUrls.add(imageUrl);

        await firestore
            .collection('status')
            .doc(statusesSnaphot.docs[0].id)
            .update({
          'photoUrl': statusimageUrls,
          'createdAt': DateTime.now(),
        });
        log("return here ");
        return;
      } else {
        log("added new status image");
        statusimageUrls = [imageUrl];
      }

      Status status = Status(
        uid: uid,
        username: username,
        phoneNumber: phoneNumber,
        photoUrl: statusimageUrls,
        createdAt: DateTime.now(),
        profilePic: profilePic,
        statusId: statusUid,
        whoCanSee: uidWhoCanSee,
      );

      await firestore.collection('status').doc(statusUid).set(status.toMap());
      log("created new status ");
    } catch (e) {
      showSnakBar(context: context, message: e.toString());
    }
  }

  Future<List<Status>> getStatus(BuildContext context) async {
    List<Status> statusData = [];
    try {
      List<Contact> contacts = [];
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
      }
      for (int i = 0; i < contacts.length; i++) {
        var statusesSnapshot = await firestore
            .collection('status')
            .where(
              'phoneNumber',
              isEqualTo: contacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .where(
              'createdAt',
              isGreaterThan: DateTime.now()
                  .subtract(const Duration(hours: 24))
                  .millisecondsSinceEpoch,
            )
            .get();
        for (var tempData in statusesSnapshot.docs) {
          Status tempStatus = Status.fromMap(tempData.data());
          if (tempStatus.whoCanSee.contains(auth.currentUser!.uid)) {
            statusData.add(tempStatus);
          }
        }
      }
    } catch (e) {
      showSnakBar(context: context, message: e.toString());
    }
    return statusData;
  }
}
