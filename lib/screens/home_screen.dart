import 'dart:convert';
import 'dart:developer';

import 'package:chat_app/constants/firebase_const.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/providers/auth_provider.dart';
import 'package:chat_app/screens/profile_screen.dart';
import 'package:chat_app/utlis/routes/route_names.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //for storing all the users currently available
  List<ChatUser> _list = [];

  // for searching the users
  List<ChatUser> _search = [];

  bool _isSearchingOn = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseConst.getCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: Icon(Icons.home),
        title: _isSearchingOn
            ? TextField(
                autofocus: true,
                onTapOutside: (val) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Name/Email...",
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: const Color.fromARGB(255, 196, 196, 196),
                  ),
                ),
                onChanged: (value) {
                  _search.clear();

                  for (var i in _list) {
                    if (i.name.toLowerCase().contains(value.toLowerCase()) ||
                        i.email.toLowerCase().contains(value.toLowerCase())) {
                      _search.add(i);
                    }
                    setState(() {
                      _search;
                    });
                  }
                },
              )
            : Text('Chat App'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  _isSearchingOn = !_isSearchingOn;
                });
              },
              icon: Icon(_isSearchingOn
                  ? CupertinoIcons.clear_circled
                  : Icons.search)),
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(user: FirebaseConst.currentUser),
                  ),
                );
              },
              icon: Icon(Icons.more_vert)),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          bottom: 15.h,
          right: 9.w,
        ),
        child: Consumer<AuthProvider>(
          builder: (context, authProvider, child) => FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add_comment_rounded),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseConst.getAllUsers(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return Center(child: CircularProgressIndicator());

            case ConnectionState.active:
            case ConnectionState.done:
          }

          final data = snapshot.data?.docs;
          _list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

          if (_list.isNotEmpty) {
            return ListView.builder(
              itemCount: _isSearchingOn ? _search.length : _list.length,
              padding: EdgeInsets.only(
                top: 15.h,
              ),
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return ChatUserCard(
                  user: _isSearchingOn ? _search[index] : _list[index],
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
