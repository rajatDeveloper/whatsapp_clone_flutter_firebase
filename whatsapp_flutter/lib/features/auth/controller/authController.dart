import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/features/auth/repository/auth_repo.dart';

final authControllerProvider = Provider(
    (ref) => AuthController(authRepo: ref.watch(authRepoProvider), ref: ref));

class AuthController {
  final AuthRepo authRepo;
  final ProviderRef ref;

  AuthController({
    required this.authRepo,
    required this.ref,
  });

  void signInWithPhnNumber({
    required BuildContext context,
    required String phoneNumber,
  }) {
    authRepo.signInWithPhn(
      context: context,
      phoneNumber: phoneNumber,
    );
  }

  void verifyOTP({
    required BuildContext context,
    required String verificationId,
    required String smsCode,
  }) {
    authRepo.verifyOTP(
      context: context,
      verificationId: verificationId,
      smsCode: smsCode,
    );
  }

  void saveDataToFireBase(
      {required BuildContext context,
      required String name,
      required File? profilePic}) {
    authRepo.saveUserDataToFirebase(
        name: name, profileImage: profilePic, ref: ref, context: context);
  }
}
