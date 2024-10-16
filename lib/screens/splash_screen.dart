import 'dart:async';

import 'package:chat_app/constants/firebase_const.dart';
import 'package:chat_app/utlis/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2), () {
      if (FirebaseConst.authInstance.currentUser != null) {
        Navigator.pushReplacementNamed(context, RouteNames.homeScreen);
      } else {
        Navigator.pushReplacementNamed(context, RouteNames.loginScreen);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Animate(
          effects: [
            ScaleEffect(duration: Durations.medium1),
          ],
          child: Image(
            height: 200.h,
            width: 200.w,
            image: AssetImage('assets/splash_logo.png'),
          ),
        ),
      ),
    );
  }
}
