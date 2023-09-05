import 'dart:io';

import 'package:flutter/material.dart';
import 'package:whatsapp_flutter/common/widgets/error.dart';
import 'package:whatsapp_flutter/features/auth/group/screens/create_group_screen.dart';
import 'package:whatsapp_flutter/features/auth/screen/login_screen.dart';
import 'package:whatsapp_flutter/features/auth/screen/otp_screen.dart';
import 'package:whatsapp_flutter/features/auth/screen/user_info_screen.dart';
import 'package:whatsapp_flutter/features/select_contacts/screens/select_contact_screen.dart';
import 'package:whatsapp_flutter/features/chat/screen/mobile_chat_screen.dart';
import 'package:whatsapp_flutter/features/status/screens/status_conform_screen.dart';
import 'package:whatsapp_flutter/features/status/screens/status_screen.dart';
import 'package:whatsapp_flutter/models/status_model.dart';

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
      final isGroupChat = data["isGroupChat"] as bool;
      final profilePic = data['profilePoc'] as String;
      return MaterialPageRoute(
        builder: (_) => MobileChatScreen(
            profilePic: profilePic,
            name: name,
            uid: uid,
            isGroupChat: isGroupChat),
      );

    case ConfromStatusScreen.routeName:
      final arg = routeSettings.arguments as File;
      return MaterialPageRoute(
        builder: (_) => ConfromStatusScreen(
          file: arg,
        ),
      );
    case StatusScreen.routeName:
      final arg = routeSettings.arguments as Status;
      return MaterialPageRoute(
        builder: (_) => StatusScreen(
          status: arg,
        ),
      );
    case CreateGroupScreen.routeName:
      // final arg = routeSettings.arguments as Status;
      return MaterialPageRoute(
        builder: (_) => CreateGroupScreen(),
      );
    default:
      return MaterialPageRoute(
          builder: (_) => const ErrorScreen(error: "this route is not found"));
  }
}
