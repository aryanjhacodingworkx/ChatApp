import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/constants/firebase_const.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:chat_app/utlis/my_date_util.dart';
import 'package:flutter/cupertino.dart';
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
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: (widget.message.msg.length <= 4) ? 100 : null,
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 30.w,
                  top: 5.h,
                  bottom: 20.h,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: Color(0xffFAFAFA),
                  border: Border.all(
                    color: Color.fromARGB(255, 233, 233, 233),
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: widget.message.type == Type.text
                    ? Text(
                        widget.message.msg,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black87,
                        ),
                      )
                    :
                    //show image
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: CachedNetworkImage(
                          // height: 150.h,
                          // width: 170.w,
                          fit: BoxFit.fill,
                          imageUrl: widget.message.msg,
                          placeholder: (context, url) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.image),
                        ),
                      ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  right: 19.w,
                  bottom: 3.h,
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
              ),
            ],
          ),
        ),
        SizedBox(
          width: 36.w,
        ),
      ],
    );
  }

//our user
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 36.w,
        ),
        Flexible(
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                width: (widget.message.msg.length <= 5) ? 120 : null,
                padding: EdgeInsets.only(
                  left: 10.w,
                  right: 30.w,
                  top: 5.h,
                  bottom: 20.h,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffDCF7C5),
                  border: Border.all(
                    color: const Color.fromARGB(255, 204, 235, 177),
                  ),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: widget.message.type == Type.text
                    ? Text(
                        widget.message.msg,
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: Colors.black87,
                        ),
                      )
                    :
                    //show image
                    ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: CachedNetworkImage(
                          // height: 150.h,
                          // width: 170.w,
                          fit: BoxFit.fill,
                          imageUrl: widget.message.msg,
                          placeholder: (context, url) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.image),
                        ),
                      ),
              ),
              (widget.message.read.isNotEmpty)
                  ? Padding(
                      padding: EdgeInsets.only(
                        right: 18.w,
                        bottom: 3.h,
                      ),
                      child: Icon(
                        Icons.done_all,
                        color: Colors.blue,
                        size: 21,
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                        right: 18.w,
                        bottom: 3.h,
                      ),
                      child: Icon(
                        Icons.done_all,
                        color: Colors.grey,
                        size: 21,
                      ),
                    ),

              // SizedBox(
              //   width: 6.w,
              // ),
              Padding(
                padding: EdgeInsets.only(
                  right: 42.w,
                  bottom: 3.h,
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
          ),
        ),
      ],
    );
  }
}
