import "package:firebase_auth/firebase_auth.dart";
import 'package:totp_app/encryption/encryption.dart';
import "../models/User.dart";
import "../db/Database.dart";
import "./device_storage.dart";

class Authentication {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<bool> logout() async {
    await DeviceStorage().deleteEncryptionKey();
    auth.signOut();
    return true;
  }

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
      var passwordFromStorage =
          await DeviceStorage().saveEncryptionKey(password);
      await EncryptionHelper.createHelper(password.toString());
      return true;
    } catch (e) {
      print("Error Incorrect values or $e");
      return false;
    } finally {
      username.clear();
      password.clear();
    }
    return false;
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

  Future<bool> isLoggedIn() async {
    FirebaseUser user = await auth.currentUser();
    if (user != null && user.isEmailVerified) {
      var password = StringBuffer(await DeviceStorage().getEncryptionKey());
      if (password == null || password.isEmpty) {
        auth.signOut();
        return false;
      } else {
        print("Password is : $password");
        await EncryptionHelper.createHelper(password.toString());
        return true;
      }
    }
    return false;
  }
}
