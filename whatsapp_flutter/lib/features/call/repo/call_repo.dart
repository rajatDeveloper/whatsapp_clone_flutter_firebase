import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/common/utils/myData.dart';
import 'package:whatsapp_flutter/models/call.dart';
import 'package:whatsapp_flutter/utils/utils.dart';

final callRepoProvider = Provider((ref) => CallRepo(
      firestore: FirebaseFirestore.instance,
      auth: FirebaseAuth.instance,
    ));

class CallRepo {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  CallRepo({required this.firestore, required this.auth});
  Stream<DocumentSnapshot> get callStream =>
      firestore.collection('call').doc(MyData.currentUserData!.uid).snapshots();

  void makeCall(
      {required Call senderCallData,
      required BuildContext context,
      required Call reciverCallData}) async {
    try {
      await firestore
          .collection('call')
          .doc(senderCallData.callerId)
          .set(senderCallData.toMap());

      await firestore
          .collection('call')
          .doc(senderCallData.recevierId)
          .set(reciverCallData.toMap());
    } catch (e) {
      showSnakBar(context: context, message: e.toString());
    }
  }
}
