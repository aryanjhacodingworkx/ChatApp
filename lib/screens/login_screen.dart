// import 'dart:math';
import 'dart:developer';

import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/utlis/helper.dart';
import 'package:chat_app/utlis/image_locations.dart';
import 'package:chat_app/utlis/routes/route_names.dart';
import 'package:chat_app/utlis/string_class.dart';
import 'package:chat_app/utlis/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Let's Chat"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Consumer<AuthProvider>(
              builder: (context, authProvider, child) => ElevatedButton(
                onPressed: () {
                  Helper.showProgressIndicator(context);
                  authProvider.signInWithGoogle().then((value) {
                    Navigator.pop(context);
                    if (value != null) {
                      log('user info:- ${value.user}');
                      log('user AditionalInfo:- ${value.additionalUserInfo}');

                      Navigator.pushReplacementNamed(
                          context, RouteNames.homeScreen);
                    }
                  });
                },
                child: SizedBox(
                  width: 190.w,
                  child: Row(
                    children: [
                      Image(
                        height: 40.h,
                        image: AssetImage(ImageLocations.googleLogo),
                      ),
                      Text(
                        MyStrings.loginWithGoogle,
                        style: loginButtonTextStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
