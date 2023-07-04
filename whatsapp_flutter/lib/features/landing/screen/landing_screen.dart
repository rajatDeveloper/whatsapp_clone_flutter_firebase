import 'package:flutter/material.dart';
import 'package:whatsapp_flutter/colors.dart';
import 'package:whatsapp_flutter/common/widgets/custom_btn.dart';
import 'package:whatsapp_flutter/features/auth/screen/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 50,
          ),
          Center(
            child: const Text(
              "Welcome to WhatsChat",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: size.height / 9,
          ),
          Image.asset(
            "assets/bg.png",
            height: 340,
            width: 340,
            color: tabColor,
          ),
          SizedBox(
            height: size.height / 9,
          ),
          const Text("Made with ❤️",
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w600, color: greyColor)),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: CustomButton(
                text: "AGREE AND CONTINUE",
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.routeName);
                }),
          )
        ],
      )),
    );
  }
}
