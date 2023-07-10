import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_flutter/common/enums/messages_enum.dart';
import 'package:whatsapp_flutter/models/chat_contact.dart';
import 'package:whatsapp_flutter/models/message.dart';
import 'package:whatsapp_flutter/models/userModel.dart';
import 'package:whatsapp_flutter/utils/utils.dart';

final chatRepoProvider = Provider<ChatRepo>((ref) {
  return ChatRepo(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance);
});

class ChatRepo {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepo({required this.firestore, required this.auth});

  _saveDataToContactSubCollection({
    required UserModel senderUserData,
    required UserModel recieverUserData,
    required String text,
    required DateTime timesent,
    required String recieverUserId,
  }) async {
    // user  - > reviver id - > chat - > sender id - > messages
    var reciverChatContact = ChatContact(
      name: senderUserData.name,
      profilePic: senderUserData.profilePic,
      contactId: senderUserData.uid,
      timeSent: timesent,
      lastMessage: text,
    );

    await firestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chat')
        .doc(auth.currentUser!.uid)
        .set(reciverChatContact.toMap());

    // user  - > sender id - > chat - > reciever id - > messages

    var senderChatContact = ChatContact(
      name: recieverUserData.name,
      profilePic: recieverUserData.profilePic,
      contactId: recieverUserData.uid,
      timeSent: timesent,
      lastMessage: text,
    );

    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chat')
        .doc(recieverUserId)
        .set(senderChatContact.toMap());
  }


_saveMessageToMessageSubCollection({
  required String recieverUserId,
  required String text, 
  required DateTime timesent,
  required String messageId  , 
  required String recieverUsername,
  required String username 


})async{

}
  //get all chats
  void sendtextMsg({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel recieverUserData;

      var userDataMap =
          await firestore.collection('users').doc(recieverUserId).get();

      recieverUserData = UserModel.fromMap(userDataMap.data()!);

      _saveDataToContactSubCollection(
          senderUserData: senderUser,
          recieverUserData: recieverUserData,
          text: text,
          timesent: timeSent,
          recieverUserId: recieverUserId);


    } catch (e) {
      showSnakBar(
        context: context,
        message: e.toString(),
      );
    }
  }
}
