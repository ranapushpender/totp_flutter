import 'dart:convert';

import "package:flutter/services.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:pointycastle/asymmetric/api.dart';

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
    print(this.encryptionKey);
    return await this
        .platform
        .invokeMethod("encrypt", {"key": this.encryptionKey, "token": token});
  }

  Future<String> decrypt(String token) async {
    return await this
        .platform
        .invokeMethod("decrypt", {"key": this.encryptionKey, "token": token});
  }
}

class PublicKeyEncryptionHelper {
  /*final String publicKey = """-----BEGIN PUBLIC KEY-----
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC0dgMN9Hfo6LdS41qT1hEcBt0a
1UKcZmX0bwEsg4ZmvYbPxIoWSVYpo4mB0XHv9QLh/Iw0voX+ULFgkcFv4pfBQpKy
cvKRrFdJ/zp8JlyG/ELiCKl5lGxcwur8ab9FhBP4MFKGlNapvz3CECxUzzHOfcYk
A/csF0UgxolMu1/QbwIDAQAB
-----END PUBLIC KEY-----""";*/
  final String publicKey;

  PublicKeyEncryptionHelper(this.publicKey);

  String encrypt(String secret) {
    print("Parsing");
    final parser = new RSAKeyParser();
    dynamic rsaKey = parser.parse(this.publicKey);
    Encrypter e = new Encrypter(RSA(publicKey: rsaKey));
    Encrypted encrypted = e.encrypt(secret);
    return encrypted.base64;
  }
}
