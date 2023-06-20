import 'package:flutter/material.dart';
import 'package:whatsapp_flutter/colors.dart';
import 'package:whatsapp_flutter/screens/mobile_layout_screen.dart';
import 'package:whatsapp_flutter/screens/web_layout_screen.dart';
import 'package:whatsapp_flutter/utils/responsive_layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Whatsapp UI',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: const ResponsiveLayout(
        mobileScreenLayout: MobileLayoutScreen(),
        webScreenLayout: WebLayoutScreen(),
      ),
    );
  }
}
