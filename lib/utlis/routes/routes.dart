import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/screens/home_screen.dart';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/utlis/routes/route_names.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case RouteNames.homeScreen:
        return MaterialPageRoute(
          builder: (context) => HomeScreen(),
        );
      case RouteNames.loginScreen:
        return MaterialPageRoute(
          builder: (context) => LoginScreen(),
        );

      default:
        return MaterialPageRoute(builder: (context) {
          return Scaffold(
            body: Center(child: Text("No routes defined")),
          );
        });
    }
  }
}
