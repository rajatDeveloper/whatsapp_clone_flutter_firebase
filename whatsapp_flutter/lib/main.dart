import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_flutter/colors.dart';
import 'package:whatsapp_flutter/common/utils/myData.dart';
import 'package:whatsapp_flutter/common/widgets/error.dart';
import 'package:whatsapp_flutter/common/widgets/loder.dart';
import 'package:whatsapp_flutter/features/auth/controller/authController.dart';
import 'package:whatsapp_flutter/features/landing/screen/landing_screen.dart';
import 'package:whatsapp_flutter/firebase_options.dart';
import 'package:whatsapp_flutter/screens/mobile_layout_screen.dart';
import 'package:whatsapp_flutter/utils/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Whatsapp UI',
        theme: ThemeData.dark().copyWith(
          appBarTheme: const AppBarTheme(
            color: appBarColor,
            elevation: 0.0,
            centerTitle: false,
          ),
          scaffoldBackgroundColor: backgroundColor,
        ),
        onGenerateRoute: (settings) => generateRoute(settings),
        home: ref.watch(UserDataAuthProvier).when(
            data: (user) {
              if (user == null) {
                return const LandingScreen();
              } else {
                MyData.currentUserData = user;
                return const MobileLayoutScreen();
              }
            },
            loading: () => const Loder(),
            error: (e, s) => ErrorScreen(error: e.toString())
            //  const ResponsiveLayout(
            //   mobileScreenLayout: MobileLayoutScreen(),
            //   webScreenLayout: WebLayoutScreen(),
            // ),
            ));
  }
}


// 7:23
//8484848484 - otp -123456  
//8607749965 - 123456 