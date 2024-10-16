import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/constants/firebase_const.dart';
import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(user: widget.user),
          ),
        );
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 4.h,
        ),
        elevation: 1.5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: StreamBuilder(
          stream: FirebaseConst.getLastMessage(widget.user),
          builder: (context, snapshots) {
            final data = snapshots.data?.docs;

            final list =
                data?.map((e) => Message.fromJson(e.data())).toList() ?? [];

            if (list.isNotEmpty) {
              _message = list[0];
            }

            return ListTile(
              // leading: CircleAvatar(
              //   backgroundColor: Colors.lightBlue,
              //   child: Icon(CupertinoIcons.person),
              // ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: CachedNetworkImage(
                  height: 34.h,
                  width: 34.h,
                  imageUrl: widget.user.image,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => CircleAvatar(
                    backgroundColor: Colors.lightBlue,
                    child: Icon(CupertinoIcons.person),
                  ),
                ),
              ),
              title: Text(widget.user.name),
              subtitle: Text(
                _message != null
                    ? _message!.type == Type.img
                        ? "Image"
                        : _message!.msg
                    : widget.user.about,
                maxLines: 1,
              ),
              trailing: _message == null
                  ? null // show nothing when there is no message
                  : _message!.read.isEmpty &&
                          _message!.fromId != FirebaseConst.user.uid
                      ? // show for unread msgs
                      Container(
                          width: 9.w,
                          height: 9.h,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        )
                      // msg sent time
                      : null,
            );
          },
        ),
      ),
    );
  }
}
