import 'dart:developer';

import 'package:chat_app/constants/firebase_const.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/utlis/my_date_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({super.key, required this.message});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return FirebaseConst.user.uid == widget.message.fromId
        ? _greenMessage()
        : _blueMessage();
  }

//sender or another user message
  Widget _blueMessage() {
    if (widget.message.read.isEmpty) {
      FirebaseConst.updateReadStatus(widget.message);
      log("Message read!");
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(18.w),
            margin: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 221, 245, 255),
                border:
                    Border.all(color: const Color.fromARGB(153, 3, 168, 244)),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                  bottomRight: Radius.circular(30.r),
                )),
            child: Text(
              widget.message.msg,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            right: 20.w,
          ),
          child: Text(
            MyDateUtil.getFormattedTime(
              context: context,
              time: widget.message.sent,
            ),
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        )
      ],
    );
  }

//our user
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20.w,
            ),
            if (widget.message.read.isNotEmpty)
              Icon(
                Icons.done_all,
                color: Colors.blue,
                size: 21,
              ),
            SizedBox(
              width: 6.w,
            ),
            Text(
              MyDateUtil.getFormattedTime(
                context: context,
                time: widget.message.sent,
              ),
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(18.w),
            margin: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 2.h,
            ),
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 218, 255, 276),
                border:
                    Border.all(color: const Color.fromARGB(153, 3, 168, 244)),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.r),
                  topRight: Radius.circular(30.r),
                  bottomLeft: Radius.circular(30.r),
                )),
            child: Text(
              widget.message.msg,
              style: TextStyle(
                fontSize: 15.sp,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
