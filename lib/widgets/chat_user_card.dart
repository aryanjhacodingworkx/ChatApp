import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chat_user_model.dart';
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
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15.w,
          vertical: 4.h,
        ),
        elevation: 1.5,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: ListTile(
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
            widget.user.about,
            maxLines: 1,
          ),
          trailing: Text(
            "12:00 PM",
            style: TextStyle(fontSize: 13.sp, color: Colors.black54),
          ),
        ),
      ),
    );
  }
}
