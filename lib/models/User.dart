import 'package:firebase_auth/firebase_auth.dart';

class User {
  String token;
  String uid;
  User({this.uid});

  static User userFromFirebaseUser(FirebaseUser firebaseUser) {
    return User(uid: firebaseUser.uid);
  }
}
