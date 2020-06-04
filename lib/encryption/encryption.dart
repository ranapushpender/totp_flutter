import "package:flutter/services.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';

class EncryptionHelper {
  StringBuffer encryptionKey;
  Firestore db;
  FirebaseUser user;
  static EncryptionHelper helper;
  final platform = MethodChannel("com.flutter.epic/epic");

  static Future<void> createHelper(StringBuffer password) async {
    if (helper == null) {
      helper = new EncryptionHelper();
      await helper.init(password);
    }
    return helper;
  }

  Future<void> init(StringBuffer password) async{
    this.db = Firestore.instance;
    this.user = await FirebaseAuth.instance.currentUser();
    var encryptedMasterKeyDocument = await this.db.collection("/users").document(user.uid).collection("keys").document("masterKey").get();
    print(encryptedMasterKeyDocument["masterKey"]);
    print(password.toString());
    StringBuffer clientDerivedKey = new StringBuffer(await platform.invokeMethod('getEncryptionKey',{"password":password.toString(),"salt":encryptedMasterKeyDocument["salt"].toString()}));
    print(clientDerivedKey.toString());
    this.encryptionKey = new StringBuffer(await platform.invokeMethod('decryptKey',{"encKey":clientDerivedKey.toString(),"masterKey":encryptedMasterKeyDocument["masterKey"].toString()}));
    print(encryptionKey);
    /*clientDerivedKey.clear();
    password.clear();
    print("*****Encryption key got ${this.encryptionKey.toString()}");*/
  }

  static Future<List<StringBuffer>> createMasterKey(
      StringBuffer password) async {
    const platform = MethodChannel("com.flutter.epic/epic");
    List<dynamic> result = await platform.invokeMethod(
      'generateEncryptionKey',
      {"password": "palakpaneer"},
    );
    print("Encrypted master key : ${result[0]}\nSalt : ${result[1]}");
    return [
      StringBuffer(result[0]),
      StringBuffer(result[1]),
    ];
    /*const platform = MethodChannel("com.flutter.epic/epic");
    List<dynamic> result = await platform.invokeMethod('generateEncryptionKey',{"username":"pushpender661@gmail.com","password":"palakpaneer"});
    print("Encrypted master key : ${result[0]}\nSalt : ${result[1]}");
    String encryptionKey = await platform.invokeMethod('getEncryptionKey',{"password":"palakpaneer","salt":result[1]});
    print("PBKDF Encryption key : $encryptionKey");
    String masterKey = await platform.invokeMethod('decryptKey',{"encKey":encryptionKey,"masterKey":result[0]});
    print("Decrypted master key :  $masterKey");
    String encryptedToken = await platform.invokeMethod("encrypt",{"token":"HelloTest I am","key":masterKey});
    String decryptedToken = await platform.invokeMethod("decrypt",{"token":encryptedToken,"key":masterKey});
    print("Encrypted Token : $encryptedToken");
    print("Decrypted Token : $decryptedToken");*/
  }
}
