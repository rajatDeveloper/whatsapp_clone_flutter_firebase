import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_flutter/common/utils/myData.dart';
import 'package:whatsapp_flutter/features/auth/screen/otp_screen.dart';
import 'package:whatsapp_flutter/features/auth/screen/user_info_screen.dart';
import 'package:whatsapp_flutter/models/userModel.dart';
import 'package:whatsapp_flutter/screens/mobile_layout_screen.dart';
import 'package:whatsapp_flutter/utils/utils.dart';

final authRepoProvider = Provider((ref) => AuthRepo(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ));

class AuthRepo {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthRepo({
    required this.auth,
    required this.firestore,
  });

  void signInWithPhn({
    required String phoneNumber,
    required BuildContext context,
  }) async {
    try {
      // showLoading(context: context);
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (phoneAuthCredential) async {
          await auth.signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (verificationFailed) {
          showSnakBar(
              context: context, message: verificationFailed.message.toString());
        },
        codeSent: (verificationId, resendingToken) async {
          Navigator.pushNamed(context, OTPScreen.routeName,
              arguments: verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      showSnakBar(context: context, message: e.toString());
    }
  }

  void verifyOTP({
    required String verificationId,
    required String smsCode,
    required BuildContext context,
  }) async {
    try {
      var data = await auth.signInWithCredential(PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode));

      Navigator.pushNamedAndRemoveUntil(
          context, UserInfoScreen.routeName, (route) => false);
    } catch (e) {
      showSnakBar(context: context, message: e.toString());
    }
  }

  void saveUserDataToFirebase(
      {required String name,
      required File? profileImage,
      required ProviderRef ref,
      required BuildContext context}) async {
    try {
      String uid = auth.currentUser!.uid;
      String photoUrl =
          "https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg";

      if (profileImage != null) {
        photoUrl = await ref
            .read(commonFirebaseStorageRepositoryProvider)
            .storeFileToFirebase(
              "profile_image/$uid",
              profileImage,
            );

        var user = UserModel(
            name: name,
            uid: uid,
            profilePic: photoUrl,
            isOnline: true,
            phoneNumber: auth.currentUser!.phoneNumber!,
            groupId: []);

        await firestore.collection("users").doc(uid).set(user.toMap());
        log("data");
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => MobileLayoutScreen()),
            (route) => false);
      }
    } catch (e) {
      showSnakBar(context: context, message: e.toString());
    }
  }

  //save logined user data to local phn storage
  Future<UserModel?> getCurrentUserData() async {
    var userData =
        await firestore.collection("users").doc(auth.currentUser?.uid).get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }

    return user;
  }

  Stream<UserModel> userData(String ueserId) {
    return firestore
        .collection("users")
        .doc(ueserId)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  void setUserState(bool isOnline) async {
    await firestore
        .collection("users")
        .doc(auth.currentUser?.uid)
        .update({'isOnline': isOnline});
  }
}
