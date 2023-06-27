
import 'package:flutter/material.dart';
import 'package:whatsapp_flutter/common/widgets/error.dart';
import 'package:whatsapp_flutter/features/auth/screen/login_screen.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case LoginScreen.routeName:
      return MaterialPageRoute(
        builder: (_) => LoginScreen(),
      );

    default:
      return MaterialPageRoute(
          builder: (_) => const ErrorScreen(error: "this route is not found"));
  }
}
