import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/constants/firebase_const.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/widgets/message_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];

  final _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
      ),
      backgroundColor: Color.fromARGB(255, 231, 248, 255),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseConst.getAllMessages(widget.user),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Center(child: SizedBox());

                  case ConnectionState.active:
                  case ConnectionState.done:
                }

                final data = snapshot.data?.docs;
                // log("data:- ${jsonEncode(data![0].data())}");
                _list =
                    data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

                if (_list.isNotEmpty) {
                  return ListView.builder(
                    itemCount: _list.length,
                    padding: EdgeInsets.only(
                      top: 15.h,
                    ),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return MessageCard(
                        message: _list[index],
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      "Say Hii...👋🏻",
                      style: TextStyle(
                        fontSize: 26,
                      ),
                    ),
                  );
                }
              },
            ),
          ),
          _chatInput(),
        ],
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(
          top: 12.h,
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 3.h,
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
                color: Colors.black54,
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(200.r),
              child: CachedNetworkImage(
                height: 32.h,
                width: 36.w,
                fit: BoxFit.fill,
                imageUrl: widget.user.image,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => CircleAvatar(
                  backgroundColor: Colors.lightBlue,
                  child: Icon(CupertinoIcons.person),
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Last seen not available",
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.black54,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 9.w,
      ),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.emoji_emotions_outlined),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: "Type Here....",
                        hintStyle: TextStyle(
                            color: const Color.fromARGB(255, 160, 160, 160)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.photo_camera_back_outlined),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt_outlined),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                FirebaseConst.sendMessage(widget.user, _textController.text);
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding: EdgeInsets.only(
              top: 10,
              right: 5,
              left: 10,
              bottom: 10,
            ),
            shape: CircleBorder(),
            color: Colors.green,
            child: Icon(
              Icons.send,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
