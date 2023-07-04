import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/features/auth/repository/auth_repo.dart';

final authControllerProvider = Provider((ref) => AuthController(
      authRepo: ref.watch(authRepoProvider),
    ));

class AuthController {
  final AuthRepo authRepo;

  AuthController({
    required this.authRepo,
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
}
