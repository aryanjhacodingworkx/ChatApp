import 'dart:io';
import 'dart:developer';

import 'package:chat_app/models/chat_user_model.dart';
import 'package:chat_app/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseConst {
  // for authentications
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for cloud database features
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  // for firebase storage features
  static FirebaseStorage storage = FirebaseStorage.instance;

  // to return current user
  static User get user => auth.currentUser!;

  // for checking if user already exists or not?
  static Future<bool> userExists() async {
    return (await firestore
            .collection('users')
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  // for creating a new user
  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    final newUserDetails = ChatUser(
      image: user.photoURL.toString(),
      name: user.displayName.toString(),
      about: "Hello ji",
      createdAt: time,
      id: user.uid,
      lastActive: time,
      isOnline: false,
      pushToken: '',
      email: user.email.toString(),
    );

    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(newUserDetails.toJson());
  }

  // for getting user info from firestore db
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //to save the coming user info
  static late ChatUser currentUser;

  // to get the info of current user.
  static Future<void> getCurrentUserInfo() async {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .get()
        .then((value) async {
      if (value.exists) {
        currentUser = ChatUser.fromJson(value.data()!);
      } else {
        await createUser().then((onValue) => getCurrentUserInfo());
      }
    });
  }

  static Future<void> updateUserInfo() async {
    await firestore.collection('users').doc(user.uid).update({
      'name': currentUser.name,
      'about': currentUser.about,
    });
  }

  static Future<void> updateProfilePicture(File file) async {
    try {
      // Getting image file extension
      final ext = file.path.split('.').last;
      log("ext $ext");
      log("reached dest 1");

      // Reference to Firebase Storage
      final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
      log("reached dest 2");

      // Uploading image
      await ref
          .putFile(file, SettableMetadata(contentType: 'image/$ext'))
          .then((p0) {
        log('Done transferring data: ${p0.bytesTransferred / 1000} kb');
      });
      log("reached dest 3");

      // Updating image to Firestore DB
      currentUser.image = await ref.getDownloadURL();
      await firestore.collection('users').doc(user.uid).update({
        'image': currentUser.image,
      });
      log("reached dest 4");
    } catch (e) {
      // Logging the error
      log("Error occurred: $e");
    }
  }

  //------Chat Screen related stuff-------//

  // get conversation id
  static getConversationId(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting user info from firestore db
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser chatUser) {
    return firestore
        .collection('chats/${getConversationId(chatUser.id)}/messages/')
        // .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  // for sending messages
  static Future<void> sendMessage(ChatUser chatUser, String msg) async {
    // msg sending time(also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
      toId: chatUser.id,
      msg: msg,
      read: '',
      type: Type.text,
      fromId: user.uid,
      sent: time,
    );

    final ref = firestore
        .collection('chats/${getConversationId(chatUser.id)}/messages/');

    await ref.doc(time).set(message.toJson());
  }

  // update read status of the msg
  static Future<void> updateReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({
      'read': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  //to get only last msg of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser chatUser) {
    return firestore
        .collection('chats/${getConversationId(chatUser.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
}
