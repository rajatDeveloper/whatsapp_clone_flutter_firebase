import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/features/auth/screen/otp_screen.dart';
import 'package:whatsapp_flutter/features/auth/screen/user_info_screen.dart';
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
      await auth.signInWithCredential(PhoneAuthProvider.credential(
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
    try {} catch (e) {
      
    }
  }
}
