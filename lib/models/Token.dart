import "package:flutter/material.dart";
import "../encryption/encryption.dart";

class Token {
  int id;
  String email;
  String website;
  String token;

  Token({
    @required this.id,
    @required this.email,
    @required this.website,
    @required this.token,
  });

  static Future<void> createEncryptedToken({
    @required int id,
    @required String email,
    @required String website,
    @required String token,
  }) async {
    token = await (await EncryptionHelper.createHelper()).encrypt(token);
    return Token(email: email, id: id, token: token, website: website);
  }

  Future<String> get getToken async {
    return await (await EncryptionHelper.createHelper()).decrypt(this.token);
  }

  Future<Map<String, dynamic>> toMap() async {
    return {
      "email": this.email,
      "website": this.website,
      "token": this.token,
      "id": this.id
    };
  }
}
