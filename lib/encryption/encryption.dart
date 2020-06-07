import "package:flutter/services.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';

class EncryptionHelper {
  dynamic encryptionKey;
  Firestore db;
  FirebaseUser user;
  static EncryptionHelper helper;
  final platform = MethodChannel("com.flutter.epic/epic");

  static Future<EncryptionHelper> createHelper([String password]) async {
    if (helper == null) {
      helper = new EncryptionHelper();
      await helper.init(password);
    }
    return helper;
  }

  Future<void> init(String password) async {
    this.db = Firestore.instance;
    this.user = await FirebaseAuth.instance.currentUser();
    var encryptedMasterKeyDocument = await this
        .db
        .collection("/users")
        .document(user.uid)
        .collection("keys")
        .document("masterKey")
        .get();
    print(encryptedMasterKeyDocument["masterKey"]);
    print(password.toString());
    dynamic clientDerivedKey = await platform.invokeMethod(
      'getEncryptionKey',
      {
        "password": password.toString(),
        "salt": encryptedMasterKeyDocument["salt"].toString()
      },
    );
    print(clientDerivedKey.toString());

    this.encryptionKey = await platform.invokeMethod(
      'decryptKey',
      {
        "encKey": clientDerivedKey.toString(),
        "masterKey": encryptedMasterKeyDocument["masterKey"].toString()
      },
    );
    print("Testing decrypting");
    print(this.encryptionKey);
    return;
  }

  static Future<List<dynamic>> createMasterKey(StringBuffer password) async {
    const platform = MethodChannel("com.flutter.epic/epic");
    List<dynamic> result = await platform.invokeMethod(
      'generateEncryptionKey',
      {"password": password.toString()},
    );
    print("Encrypted master key : ${result[0]}\nSalt : ${result[1]}");
    return [
      result[0],
      result[1],
    ];
  }

  Future<String> encrypt(String token) async {
    return await this.platform.invokeMethod("encrypt",{"key":this.encryptionKey,"token":token});
  }
  Future<String> decrypt(String token) async {
    return await this.platform.invokeMethod("decrypt",{"key":this.encryptionKey,"token":token});
  }
}
