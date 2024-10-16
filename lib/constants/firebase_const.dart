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
  static FirebaseAuth authInstance = FirebaseAuth.instance;

  // for cloud database features
  static FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  // for firebase storage features
  static FirebaseStorage storageInstance = FirebaseStorage.instance;

  // to return current user
  static User get user => authInstance.currentUser!;

  // for checking if user already exists or not?
  static Future<bool> userExists() async {
    return (await firestoreInstance
            .collection('users')
            .doc(authInstance.currentUser!.uid)
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

    return await firestoreInstance
        .collection('users')
        .doc(user.uid)
        .set(newUserDetails.toJson());
  }

  // for getting user info from firestore db
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestoreInstance
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  //to save the coming user info
  static late ChatUser currentUser;

  // to get the info of current user.
  static Future<void> getCurrentUserInfo() async {
    await firestoreInstance
        .collection('users')
        .doc(authInstance.currentUser!.uid)
        .get()
        .then((value) async {
      if (value.exists) {
        currentUser = ChatUser.fromJson(value.data()!);
      } else {
        await createUser().then((onValue) => getCurrentUserInfo());
      }
    });
  }

  // for updating the current user info
  static Future<void> updateUserInfo() async {
    await firestoreInstance.collection('users').doc(user.uid).update({
      'name': currentUser.name,
      'about': currentUser.about,
    });
  }

  // for updating the dp of the current user
  static Future<void> updateProfilePicture(File file) async {
    try {
      // Getting image file extension
      final ext = file.path.split('.').last;

      // Reference to Firebase Storage
      final ref =
          storageInstance.ref().child('profile_pictures/${user.uid}.$ext');

      // Uploading image
      await ref
          .putFile(file, SettableMetadata(contentType: 'image/$ext'))
          .then((p0) {
        log('Done transferring data: ${p0.bytesTransferred / 1000} kb');
      });

      // Updating image to Firestore DB
      currentUser.image = await ref.getDownloadURL();
      await firestoreInstance.collection('users').doc(user.uid).update({
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
    return firestoreInstance
        .collection('chats/${getConversationId(chatUser.id)}/messages/')
        // .where('id', isNotEqualTo: user.uid)
        .orderBy('sent', descending: true)
        .snapshots();
  }

  // for sending messages
  static Future<void> sendMessage(
      ChatUser chatUser, String msg, Type type) async {
    // msg sending time(also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
      toId: chatUser.id,
      msg: msg,
      read: '',
      type: type,
      fromId: user.uid,
      sent: time,
    );

    final ref = firestoreInstance
        .collection('chats/${getConversationId(chatUser.id)}/messages/');

    await ref.doc(time).set(message.toJson());
  }

  // update read status of the msg
  static Future<void> updateReadStatus(Message message) async {
    firestoreInstance
        .collection('chats/${getConversationId(message.fromId)}/messages/')
        .doc(message.sent)
        .update({
      'read': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  //to get only last msg of a specific chat
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser chatUser) {
    return firestoreInstance
        .collection('chats/${getConversationId(chatUser.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }

  static Future<void> sendChatImages(ChatUser chatUser, File file) async {
    try {
      // Getting image file extension
      final ext = file.path.split('.').last;

      // Reference to Firebase Storage
      final ref = storageInstance.ref().child(
          'images/${getConversationId(chatUser.id)}/${DateTime.now().millisecondsSinceEpoch}.$ext');

      // Uploading image
      await ref
          .putFile(file, SettableMetadata(contentType: 'image/$ext'))
          .then((p0) {
        log('Done transferring data: ${p0.bytesTransferred / 1000} kb');
      });

      // Updating image to Firestore DB
      final imageUrl = currentUser.image = await ref.getDownloadURL();
      await sendMessage(
        chatUser,
        imageUrl,
        Type.img,
      );
    } catch (e) {
      // Logging the error
      log("Error occurred: $e");
    }
  }
}
