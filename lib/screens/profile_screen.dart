import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/constants/firebase_const.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/providers/photo_provider.dart';
import 'package:chat_app/utlis/routes/route_names.dart';
import 'package:chat_app/utlis/text_styles.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:touch_ripple_effect/touch_ripple_effect.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  _onSubmit() {
    return _formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Screen'),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: 15.h,
          right: 9.w,
        ),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => FloatingActionButton(
            onPressed: () {
              authProvider.signOut().then(
                    (value) => Navigator.pushReplacementNamed(
                        context, RouteNames.loginScreen),
                  );
            },
            child: Icon(Icons.logout_outlined),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 40.h,
                ),
                Stack(children: [
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(200.r),
                      child: CachedNetworkImage(
                        height: 150.h,
                        width: 170.w,
                        fit: BoxFit.fill,
                        imageUrl: widget.user.image,
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) => CircleAvatar(
                          backgroundColor: Colors.lightBlue,
                          child: Icon(CupertinoIcons.person),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 75,
                    child: MaterialButton(
                      elevation: 1,
                      onPressed: () {
                        showModalBottomSheet(
                            backgroundColor: Colors.white,
                            context: context,
                            builder: (context) {
                              return SizedBox(
                                height: 200.h,
                                width: double.infinity.w,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    Container(
                                      height: 6.0.h,
                                      width: 60.0.w,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 211, 211, 211),
                                        borderRadius:
                                            BorderRadius.circular(10.0.r),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Consumer<ProfileImageProvider>(
                                          builder: (context, value, child) =>
                                              TouchRippleEffect(
                                            rippleColor: Colors.white,
                                            onTap: () {
                                              value.getImageFromCamera();
                                            },
                                            child: myCameraIcon(),
                                          ),
                                        ),
                                        Consumer<ProfileImageProvider>(
                                          builder: (context, value, child) =>
                                              TouchRippleEffect(
                                            rippleColor: Colors.white,
                                            onTap: () {
                                              value.getImageFromGallery();
                                            },
                                            child: myGalleryIcon(),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                      },
                      shape: CircleBorder(),
                      color: Colors.white,
                      child: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 20.h),
                Text(
                  widget.user.email,
                  style: profileButtonEmailTextStyle,
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  initialValue: widget.user.name,
                  onSaved: (newValue) =>
                      FirebaseConst.currentUser.name = newValue ?? "No Name",
                  validator: (value) =>
                      value == null || value.isEmpty ? "Required Field" : null,
                  onTapOutside: (val) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: Icon(
                        CupertinoIcons.person,
                        color: Colors.blue,
                      ),
                      labelText: "Name",
                      hintText: "eg. John Doe",
                      hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 170, 170, 170))),
                ),
                SizedBox(height: 20.h),
                TextFormField(
                  autovalidateMode: AutovalidateMode.always,
                  initialValue: widget.user.about,
                  onSaved: (newValue) =>
                      FirebaseConst.currentUser.about = newValue ?? "No Name",
                  validator: (value) =>
                      value == null || value.isEmpty ? "Required Field" : null,
                  onTapOutside: (val) => FocusScope.of(context).unfocus(),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      prefixIcon: Icon(
                        CupertinoIcons.info,
                        color: Colors.blue,
                      ),
                      labelText: "About",
                      hintText: "eg. Feeling happy....",
                      hintStyle: TextStyle(
                          color: const Color.fromARGB(255, 170, 170, 170))),
                ),
                SizedBox(height: 40.h),
                TouchRippleEffect(
                  rippleColor: Colors.white,
                  onTap: () {
                    if (_onSubmit()) {
                      _formKey.currentState!.save();
                      FirebaseConst.updateUserInfo().then(
                        (val) {
                          Fluttertoast.showToast(
                            msg: "Profile updated successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor:
                                const Color.fromARGB(255, 140, 167, 255),
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        },
                      );
                    }
                  },
                  child: Container(
                    width: 120.w,
                    height: 35.h,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 12.w,
                            right: 9.w,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          "Update",
                          style: profileButtonUpdateTextStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Column myCameraIcon() {
  return Column(
    children: [
      Icon(
        Icons.camera_alt_outlined,
        size: 80,
        color: Colors.purple,
      ),
      SizedBox(
        height: 12.h,
      ),
      Text(
        "Camera",
        style: profileScreenBottomSheetTextStyle,
      )
    ],
  );
}

Column myGalleryIcon() {
  return Column(
    children: [
      Icon(
        Icons.image_outlined,
        size: 80,
        color: Colors.purple,
      ),
      SizedBox(
        height: 12.h,
      ),
      Text(
        "Gallery",
        style: profileScreenBottomSheetTextStyle,
      ),
    ],
  );
}
