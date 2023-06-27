import 'package:flutter/material.dart';

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
      appBar: AppBar(
        title: Text("Enter your phone number"),
      ),
    );
  }
}
