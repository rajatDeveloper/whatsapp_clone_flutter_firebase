import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/models/userModel.dart';
import 'package:whatsapp_flutter/features/chat/screen/mobile_chat_screen.dart';
import 'package:whatsapp_flutter/utils/utils.dart';

final selectContactRepoProvider = Provider((ref) => SelectContactRepo(
      firestore: FirebaseFirestore.instance,
    ));

class SelectContactRepo {
  final FirebaseFirestore firestore;

  SelectContactRepo({
    required this.firestore,
  });

  Future<List<Contact>> getContacts() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(withProperties: true);
        return contacts;
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    return contacts;
  }

  void selectContact(
      {required Contact selectedContact, required context}) async {
    try {
      var userCollection = await firestore.collection('users').get();
      bool isFoound = false;
      for (var documnet in userCollection.docs) {
        var userData = UserModel.fromMap(documnet.data());
        String selectedPhnNumber =
            selectedContact.phones[0].number.replaceAll(" ", "");
        log("contact numger : ${selectedPhnNumber}");
        if (userData.phoneNumber == selectedPhnNumber) {
          isFoound = true;
          log("Contact status  : ${isFoound.toString()}");
          Navigator.pushNamed(context, MobileChatScreen.routeName, arguments: {
            "name": userData.name,
            "uid": userData.uid,
          });
          break;
        }
      }
      if (!isFoound) {
        showSnakBar(
            context: context,
            message: "This Contact is not register in WhatsChat Database");
        return;
      }
    } catch (e) {
      showSnakBar(context: context, message: e.toString());
    }
  }
}
