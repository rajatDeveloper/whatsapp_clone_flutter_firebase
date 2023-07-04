import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/colors.dart';
import 'package:whatsapp_flutter/features/auth/controller/authController.dart';

class OTPScreen extends ConsumerWidget {
  const OTPScreen({
    Key? key,
    required this.verficationId,
  }) : super(key: key);
  final String verficationId;

  static const String routeName = "/otp-screen";

  void verfiyOTP(BuildContext context, String otp, WidgetRef ref) {
    ref.read(authControllerProvider).verifyOTP(
          context: context,
          verificationId: verficationId,
          smsCode: otp,
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text("Verify your OTP"),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Enter the OTP sent to your number",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "- - - - - -",
                  hintStyle: TextStyle(
                    fontSize: 30,
                  ),
                ),
                keyboardAppearance: Brightness.dark,
                onChanged: (val) {
                  if (val.length == 6) {
                    verfiyOTP(context, val.trim(), ref);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
