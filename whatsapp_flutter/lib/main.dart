import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp_flutter/colors.dart';
import 'package:whatsapp_flutter/features/landing/screen/landing_screen.dart';
import 'package:whatsapp_flutter/firebase_options.dart';
import 'package:whatsapp_flutter/screens/mobile_layout_screen.dart';
import 'package:whatsapp_flutter/screens/web_layout_screen.dart';
import 'package:whatsapp_flutter/utils/responsive_layout.dart';
import 'package:whatsapp_flutter/utils/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        onGenerateRoute: (settings) => generateRoute(settings),
        home: LandingScreen()
        //  const ResponsiveLayout(
        //   mobileScreenLayout: MobileLayoutScreen(),
        //   webScreenLayout: WebLayoutScreen(),
        // ),
        );
  }
}


// 46  