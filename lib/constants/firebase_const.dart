import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseConst {
  // for authentications
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for cloud database features
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
}
