import 'package:chat_app/models/chat_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConst {
  // for authentications
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for cloud database features
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

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
}
