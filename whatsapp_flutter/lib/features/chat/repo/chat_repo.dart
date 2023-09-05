import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_flutter/common/enums/messages_enum.dart';
import 'package:whatsapp_flutter/common/provider/message_reply_provider.dart';
import 'package:whatsapp_flutter/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_flutter/common/utils/myData.dart';
import 'package:whatsapp_flutter/models/chat_contact.dart';
import 'package:whatsapp_flutter/models/group.dart';
import 'package:whatsapp_flutter/models/message.dart';
import 'package:whatsapp_flutter/models/userModel.dart';
import 'package:whatsapp_flutter/utils/utils.dart';

final chatRepoProvider = Provider((ref) {
  return ChatRepo(
      firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance);
});

class ChatRepo {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  ChatRepo({required this.firestore, required this.auth});

  _saveDataToContactSubCollection(
      {required UserModel? senderUserData,
      required UserModel? recieverUserData,
      required String text,
      required DateTime timesent,
      required String recieverUserId,
      required bool isGroupChat}) async {
    log('point - 1');
    // user  - > reviver id - > chat - > sender id - > messages

    if (isGroupChat) {
      await firestore.collection('groups').doc(recieverUserId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      var reciverChatContact = ChatContact(
        name: senderUserData!.name,
        profilePic: senderUserData.profilePic,
        contactId: senderUserData.uid,
        timeSent: timesent,
        lastMessage: text,
      );

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(reciverChatContact.toMap());

      // user  - > sender id - > chat - > reciever id - > messages
      log('point - 3');
      var senderChatContact = ChatContact(
        name: recieverUserData!.name,
        profilePic: recieverUserData.profilePic,
        contactId: recieverUserData.uid,
        timeSent: timesent,
        lastMessage: text,
      );

      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .set(senderChatContact.toMap());
      log('point - 3');
    }
  }

  _saveMessageToMessageSubCollection(
      {required String recieverUserId,
      required String text,
      required DateTime timesent,
      required String messageId,
      required String username,
      required MessageEnum messageType,
      required MessageReply? messageReply,
      required String senderUserName,
      required String? recieverUserName,
      required bool isGroupChat}) async {
    var message = Message(
      senderId: auth.currentUser!.uid,
      recieverid: recieverUserId,
      text: text,
      type: messageType,
      timeSent: timesent,
      messageId: messageId,
      isSeen: false,
      repiledMessage: messageReply == null ? "" : messageReply.message,
      repiledTo: messageReply == null
          ? ""
          : messageReply.isMe
              ? senderUserName
              : recieverUserName ?? "",
      repiledMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );

    if (isGroupChat) {
      await firestore
          .collection('groups')
          .doc(recieverUserId)
          .collection('chats')
          .doc(messageId)
          .set(message.toMap());
      return;
    } else {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(message.toMap());
    }
  }

  //get all chats
  void sendtextMsg(
      {required BuildContext context,
      required String text,
      required String recieverUserId,
      required UserModel senderUser,
      required MessageReply? messageReply,
      required bool isGroupChat}) async {
    try {
      log("poiynt - -1");
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }

      // var userDataMap =
      //     await firestore.collection('users').doc(recieverUserId).get();

      // recieverUserData = UserModel.fromMap(userDataMap.data()!);
      log("poiynt - 0");
      _saveDataToContactSubCollection(
          isGroupChat: isGroupChat,
          senderUserData: senderUser,
          recieverUserData: recieverUserData,
          text: text,
          timesent: timeSent,
          recieverUserId: recieverUserId);

      var messageId = const Uuid().v1();

      _saveMessageToMessageSubCollection(
        isGroupChat: isGroupChat,
        recieverUserName: recieverUserData?.name,
        recieverUserId: recieverUserId,
        text: text,
        timesent: timeSent,
        messageId: messageId,
        username: senderUser.name,
        messageType: MessageEnum.text,
        messageReply: messageReply,
        senderUserName: senderUser.name,
      );
    } catch (e) {
      showSnakBar(
        context: context,
        message: e.toString(),
      );
    }
  }

  //show chat list of logined user
  Stream<List<ChatContact>> getChatList() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ChatContact.fromMap(doc.data());
      }).toList();
    });
  }

  Stream<List<Message>> getChatStream({required String recieverUserId}) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromMap(doc.data());
      }).toList();
    });
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required UserModel senderUserData,
    required ProviderRef ref, // can call fireatire provider functions
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String imageUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              'chat//${messageType.type}/${senderUserData.uid}/$recieverUserId/$messageId',
              file);

      UserModel? recieverUserData;
      
      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }
      String contactMsg;
      switch (messageType) {
        case MessageEnum.image:
          contactMsg = "Image";
          break;
        case MessageEnum.video:
          contactMsg = "Video";
          break;
        case MessageEnum.audio:
          contactMsg = "Audio";
          break;
        case MessageEnum.gif:
          contactMsg = "Gif";
          break;

        default:
          contactMsg = "File";
      }

      _saveDataToContactSubCollection(
          isGroupChat: isGroupChat,
          senderUserData: senderUserData,
          recieverUserData: recieverUserData,
          text: contactMsg,
          timesent: timeSent,
          recieverUserId: recieverUserId);

      _saveMessageToMessageSubCollection(
        isGroupChat: isGroupChat,
        recieverUserId: recieverUserId,
        text: imageUrl,
        timesent: timeSent,
        messageId: messageId,
        recieverUserName: isGroupChat ? "" : recieverUserData!.name,
        username: senderUserData.name,
        messageType: messageType,
        messageReply: messageReply,
        senderUserName: senderUserData.name,
      );
    } catch (e) {
      showSnakBar(context: context, message: e.toString());
    }
  }

  void sendGifMsg(
      {required BuildContext context,
      required String gifUrl,
      required String recieverUserId,
      required UserModel senderUser,
      required MessageReply? messageReply,
      required bool isGroupChat}) async {
    try {
      log("poiynt - -1");
      var timeSent = DateTime.now();
      UserModel? recieverUserData;

      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(recieverUserId).get();
        recieverUserData = UserModel.fromMap(userDataMap.data()!);
      }
      log("poiynt - 0");
      _saveDataToContactSubCollection(
          isGroupChat: isGroupChat,
          senderUserData: senderUser,
          recieverUserData: recieverUserData,
          text: 'GIF',
          timesent: timeSent,
          recieverUserId: recieverUserId);

      var messageId = const Uuid().v1();
      _saveMessageToMessageSubCollection(
        isGroupChat: isGroupChat,
        recieverUserId: recieverUserId,
        text: gifUrl,
        timesent: timeSent,
        messageId: messageId,
        username: senderUser.name,
        messageType: MessageEnum.gif,
        messageReply: messageReply,
        recieverUserName: recieverUserData?.name,
        senderUserName: senderUser.name,
      );
    } catch (e) {
      showSnakBar(
        context: context,
        message: e.toString(),
      );
    }
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String recieverUserId,
    required String messageId,
  }) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(recieverUserId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(recieverUserId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnakBar(context: context, message: e.toString());
    }
  }

//get chat groups func

  Stream<List<Group>> getGroups() {
    return firestore.collection('groups').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        var data = Group.fromMap(doc.data());
        if (data.membersUid.contains(auth.currentUser!.uid)) {
          return data;
        }
        return Group(
          timeSent: DateTime.now(),
          senderId: '',
          name: '',
          groupId: '',
          lastMessage: '',
          groupPic: '',
          membersUid: [],
        );
      }).toList();
    });
  }

  // get group chat strem

  Stream<List<Message>> getGroupChatStream({required String groupId}) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('timeSent', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Message.fromMap(doc.data());
      }).toList();
    });
  }
}
