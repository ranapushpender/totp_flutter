import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:totp_app/authentication/auth.dart';
import 'package:totp_app/models/Device.dart';
import 'package:totp_app/otp/otp.dart';
import 'package:totp_app/models/Token.dart';
import "../encryption/encryption.dart";
import "../models/User.dart";

class Database {
  final db = Firestore.instance;

  Future<void> initializeUserCollection(String uid) async {
    var document = await db.collection("/users").document(uid).get();
    if (!document.exists) {
      print("Generating master key");
      List<dynamic> credentials = await EncryptionHelper.createMasterKey(
        new StringBuffer("123456"),
      );
      print(credentials);
      await db.collection("/users").document(uid).setData({"uid": uid});
      await db
          .collection("/users")
          .document(uid)
          .collection("keys")
          .document("masterKey")
          .setData({"masterKey": credentials[0], "salt": credentials[1]});
    }
  }

  Future<bool> saveToken(AppOTP token) async {
    var user = await FirebaseAuth.instance.currentUser();
    db
        .collection("/users")
        .document(user.uid)
        .collection("tokens")
        .add(token.toMap());
    return true;
  }

  Future<bool> updateToken(String documentID, AppOTP token) async {
    await token.encryptString();
    var user = await FirebaseAuth.instance.currentUser();
    try {
      await db
          .collection("/users")
          .document(user.uid)
          .collection("tokens")
          .document(documentID)
          .updateData(token.toMap());
      return true;
    } catch (e) {
      print("Error while updating $e");
      return false;
    }
  }

  Future<bool> deleteDocument(String documentID) async {
    var user = await FirebaseAuth.instance.currentUser();
    try {
      await db
          .collection("/users")
          .document(user.uid)
          .collection("tokens")
          .document(documentID)
          .delete();
      return true;
    } catch (e) {
      print("Error while deleting : $e");
      return false;
    }
  }

  Future<List<Token>> getAllTokens() async {
    var user = await FirebaseAuth.instance.currentUser();
    var tokenDocuments = (await db
            .collection("/users")
            .document(user.uid)
            .collection("tokens")
            .getDocuments())
        .documents;
    var tokens = await Future.wait(
      tokenDocuments.map(
        (e) async {
          AppOTP otp = AppOTP(otpString: new StringBuffer(e["otpString"]));
//          var decryptedTest = await otp.decryptedString;
          return Token.createFromOTPString(
              otpString: await otp.decryptedString, documentID: e.documentID);
        },
      ),
    );
    return tokens;
  }

  Future<bool> saveDevice(Device device) async {
    try {
      var user = await FirebaseAuth.instance.currentUser();
      await db
          .collection("/users")
          .document(user.uid)
          .collection("devices")
          .add(device.toMap());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteDevice(Device device) async {
    var user = await FirebaseAuth.instance.currentUser();
    try {
      await db
          .collection("/users")
          .document(user.uid)
          .collection("devices")
          .document(device.id)
          .delete();
      return true;
    } catch (e) {
      print("Error while deleting : $e");
      return false;
    }
  }

  Future<Stream<QuerySnapshot>> getAllDevicesStream() async {
    var user = await FirebaseAuth.instance.currentUser();
    return db
        .collection("/users")
        .document(user.uid)
        .collection("devices")
        .snapshots();
  }

  Future<Stream<QuerySnapshot>> getAllTokensStream() async {
    var user = await FirebaseAuth.instance.currentUser();
    return db
        .collection("/users")
        .document(user.uid)
        .collection("tokens")
        .snapshots();
  }

  Future<void> sendToDevice(String encryptedToken,Device device) async{
    final docs = await db.collection("/devices").where("publicKey",isEqualTo: device.devicePublicKey).getDocuments();
    if(!docs.documents.isEmpty){
        await db.collection("/devices").document(docs.documents[0].documentID).updateData({
              "tokenToPrint" : encryptedToken,
            });
    }
    
  }
}
