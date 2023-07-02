import 'package:flutter/material.dart';
import 'package:whatsapp_flutter/colors.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = "/login";
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text("Enter your phone number"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
              child:
                  Text("We will send you an SMS to verify your phone number"),
            ),
            const SizedBox(
              height: 10,
            ),
            TextButton(onPressed: () {}, child: Text("Select country/region")),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [],
            )
          ],
        ),
      ),
    );
  }
}
