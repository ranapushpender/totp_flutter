import 'dart:convert';
import 'dart:math';
import "package:flutter/services.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:encrypt/encrypt.dart';
import 'package:encrypt/encrypt_io.dart';
import 'package:password/password.dart';
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
    final testPass = Password.hash(
      password,
      new PBKDF2(iterationCount: 100, desiredKeyLength: 16),
    );
    print("The password after hashing with this is :  $testPass");
    final strippedPass = testPass.split(',')[2].toString().split('\$')[2];
    print('Strpped pass $strippedPass');

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
    /*dynamic clientDerivedKey = await platform.invokeMethod(
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
    );*/

    final iv = IV.fromLength(16);
    final encrypter = new Encrypter(AES(Key.fromBase64(strippedPass)));
    final decryptedKey = encrypter.decrypt(
      Encrypted.fromBase64(encryptedMasterKeyDocument["masterKey"].toString()),
      iv: iv,
    );
    this.encryptionKey = decryptedKey;
    print("Testing decrypting");
    print(this.encryptionKey);
    return;
  }

  static Future<List<dynamic>> createMasterKey(StringBuffer password) async {
    var random = Random.secure();

    var values = List<int>.generate(32, (i) => random.nextInt(256));
    String randomEncryptionKey = base64Url.encode(values);
    final iv = IV.fromLength(16);

    final testPass = Password.hash(
      password.toString(),
      new PBKDF2(iterationCount: 100, desiredKeyLength: 16),
    );
    print('PAssword after hash $testPass');
    final strippedPass = testPass.split(',')[2].toString().split('\$')[2];
    print('Strpped pass $strippedPass');
    final encrypter = new Encrypter(AES(Key.fromBase64(strippedPass)));
    randomEncryptionKey = encrypter.encrypt(randomEncryptionKey, iv: iv).base64;

    //const platform = MethodChannel("com.flutter.epic/epic");
    /*List<dynamic> result = await platform.invokeMethod(
      'generateEncryptionKey',
      {"password": password.toString()},
    );
    print("Encrypted master key : ${result[0]}\nSalt : ${result[1]}");*/
    return [
      randomEncryptionKey,
      "Test SAlt",
    ];
  }

  Future<String> encrypt(String token) async {
    print('The encryption key is ${this.encryptionKey}');
    final iv = IV.fromLength(16);
    final encrypter = new Encrypter(AES(Key.fromBase64(this.encryptionKey)));
    return encrypter.encrypt(token, iv: iv).base64;
    /*return await this
        .platform
        .invokeMethod("encrypt", {"key": this.encryptionKey, "token": token});*/
  }

  Future<String> decrypt(String token) async {
    print('I was decrypting');
    /*return await this
        .platform
        .invokeMethod("decrypt", {"key": this.encryptionKey, "token": token});*/
    print(this.encryptionKey);
    final iv = IV.fromLength(16);
    final encrypter = new Encrypter(AES(Key.fromBase64(this.encryptionKey)));
    return encrypter.decrypt(Encrypted.fromBase64(token), iv: iv);
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
