import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/constants/firebase_const.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/utlis/routes/route_names.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.home),
        title: Text('Chat App'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: 15.h,
          right: 9.w,
        ),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => FloatingActionButton(
            onPressed: () {
              authProvider.signOut();
              Navigator.pushReplacementNamed(context, RouteNames.loginScreen);
            },
            child: Icon(Icons.add_comment_rounded),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseConst.firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());

            case ConnectionState.active:
            case ConnectionState.done:
          }

          final data = snapshot.data?.docs;

          list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

          if (list.isNotEmpty) {
            return ListView.builder(
              itemCount: list.length,
              padding: EdgeInsets.only(
                top: 15.h,
              ),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ChatUserCard(
                  user: list[index],
                );
                // return Text("Name:- ${list[index]}");
              },
            );
          } else {
            return Center(
              child: Text(
                "No connections found!",
                style: TextStyle(
                  fontSize: 21,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
