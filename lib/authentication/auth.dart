import "package:firebase_auth/firebase_auth.dart";
import 'package:totp_app/encryption/encryption.dart';
import "../models/User.dart";
import "../db/Database.dart";

class Authentication {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> login(StringBuffer username, StringBuffer password) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: username.toString(),
        password: password.toString(),
      );
      FirebaseUser user = await auth.currentUser();
      if (user.isEmailVerified) {
        await Database().initializeUserCollection(user.uid);
      }
      await EncryptionHelper.createHelper("123456");
      return true;
    } catch (e) {
      print("Error Incorrect values or $e");
      return false;
    } finally {
      username.clear();
      password.clear();
    }
  }

  Future<bool> register(StringBuffer username, StringBuffer password) async {
    print("Creating");
    try {
      await auth.createUserWithEmailAndPassword(
          email: username.toString(), password: password.toString());
      return true;
    } catch (e) {
      print("Error already exists or $e");
      return false;
    } finally {
      username.clear();
      password.clear();
    }
  }

  Future<User> currentUser() async {
    FirebaseUser currentUser = await auth.currentUser();
    return User.userFromFirebaseUser(currentUser);
  }

  Future<bool> sendVerificationEmail() async {
    FirebaseUser user = (await auth.currentUser());
    if (user != null && !user.isEmailVerified) {
      await user.sendEmailVerification();
      print("Email Sent");
      return true;
    } else {
      print("Already verified or user null");
      return false;
    }
  }
}
