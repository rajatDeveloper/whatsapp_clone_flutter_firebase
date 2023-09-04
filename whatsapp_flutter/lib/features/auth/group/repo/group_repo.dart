import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_flutter/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_flutter/utils/utils.dart';
import 'package:whatsapp_flutter/models/group.dart' as model;

final groupRepoProvider = Provider((ref) => GroupRepo(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
      ref: ref,
    ));

class GroupRepo {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  final ProviderRef ref;

  GroupRepo({required this.firestore, required this.auth, required this.ref});

  void createGroup(
      {required BuildContext context,
      required String groupName,
      required File groupPic,
      required List<Contact> selectedContacts}) async {
    try {
      List<String> uids = [];
      for (int i = 0; i < selectedContacts.length; i++) {
        var usersCollection = await firestore
            .collection('users')
            .where(
              'phoneNumber',
              isEqualTo: selectedContacts[i].phones[0].number.replaceAll(
                    ' ',
                    '',
                  ),
            )
            .get();

        if (usersCollection.docs.isNotEmpty && usersCollection.docs[0].exists) {
          uids.add(usersCollection.docs[0].data()['uid']);
        }
      }
      var groupId = const Uuid().v1();
      var groupPicUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase('/group/$groupId', groupPic);

      model.Group group = model.Group(
        senderId: auth.currentUser!.uid,
        name: groupName,
        groupId: groupId,
        groupPic: groupPicUrl,
        lastMessage: "",
        membersUid: [auth.currentUser!.uid, ...uids],
      );

      await firestore.collection('groups').doc(groupId).set(group.toMap());
    } catch (e) {
      showSnakBar(context: context, message: e.toString());
    }
  }
}
