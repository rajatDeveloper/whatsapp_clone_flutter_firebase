import 'package:flutter/material.dart';
import 'package:whatsapp_flutter/common/widgets/error.dart';
import 'package:whatsapp_flutter/features/auth/screen/login_screen.dart';
import 'package:whatsapp_flutter/features/auth/screen/otp_screen.dart';
import 'package:whatsapp_flutter/features/auth/screen/user_info_screen.dart';
import 'package:whatsapp_flutter/features/select_contacts/screens/select_contact_screen.dart';
import 'package:whatsapp_flutter/features/chat/screen/mobile_chat_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => LoginScreen(),
      );
    case OTPScreen.routeName:
      final id = routeSettings.arguments as String;
      return MaterialPageRoute(
        builder: (_) => OTPScreen(
          verficationId: id,
        ),
      );

    case ContactScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => ContactScreen(),
      );
    case UserInfoScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => UserInfoScreen(),
      );

    case MobileChatScreen.routeName:
      final data = routeSettings.arguments as Map<String, dynamic>;
      final name = data["name"] as String;
      final uid = data["uid"] as String;
      return MaterialPageRoute(
        builder: (_) => MobileChatScreen(name: name, uid: uid),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => const ErrorScreen(error: "this route is not found"));
  }
}
