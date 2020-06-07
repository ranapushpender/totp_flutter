import "package:flutter/material.dart";
import 'package:otp/otp.dart';
import "../encryption/encryption.dart";

enum TokenTypes { TOTP, HOTP, INVALID }

class Token {
  int id;
  String label;
  String issuer;
  String username;
  StringBuffer secret;
  Algorithm algorithm;
  int period;
  TokenTypes type;
  int counter;
  String documentID;

  static Token createFromOTPString(
      {@required StringBuffer otpString, String documentID}) {
    Token token = Token();
    if (documentID != null) {
      token.documentID = documentID;
    }
    print(otpString);
    //Setting the type
    if (otpString.toString().contains("totp")) {
      token.type = TokenTypes.TOTP;
    } else if (otpString.toString().contains("hotp")) {
      token.type = TokenTypes.HOTP;
    } else {
      token.type = TokenTypes.INVALID;
    }
    //Destructuring the otp string to create values
    token.label = otpString.toString().split(token.tokenType)[1].split("?")[0];
    print(token.label);
    List<String> details =
        otpString.toString().split(token.tokenType)[1].split("?")[1].split("&");
    print(details);
    for (int i = 0; i < details.length; i++) {
      switch (details[i].split("=")[0]) {
        case "secret":
          token.secret = new StringBuffer(details[i].split("=")[1]);
          break;
        case "issuer":
          token.issuer = details[i].split("=")[1];
          break;
        case "algorithm":
          token.algorithm = algorithmFromString(details[i].split("=")[1]);
          break;
        case "period":
          token.period = int.parse(details[i].split("=")[1]);
          break;
        case "counter":
          token.counter = int.parse(details[i].split("=")[1]);
          break;
      }
    }
    print(
        "Token added ${token.issuer} ${token.algorithm} ${token.counter} ${token.username} ${token.label} ${token.period} ${token.secret}");
    return token;
  }

  static Algorithm algorithmFromString(String algo) {
    switch (algo) {
      case "SHA1":
        return Algorithm.SHA1;
        break;
      case "SHA256":
        return Algorithm.SHA256;
        break;
      case "SHA512":
        return Algorithm.SHA512;
        break;
      default:
        return Algorithm.SHA1;
    }
  }

  String get tokenType {
    switch (this.type) {
      case TokenTypes.TOTP:
        return ("totp/");
        break;
      case TokenTypes.HOTP:
        return ("hotp/");
        break;
      default:
        return ("INVALID");
    }
  }
  StringBuffer get tokenString{
    StringBuffer otpString = StringBuffer("otpauth://");
    otpString.write(this.tokenType);
    otpString.write(this.label+"?");
    if(secret!=null){
      otpString.write("secret=${this.secret}");
    }
    if(this.issuer!=null){
      otpString.write("&issuer=${this.issuer}");
    }
    if(this.algorithm!=null){
      otpString.write("&algorithm=${this.algorithm.toString()}");
    }
    if(this.period!=null){
      otpString.write("&period=${this.period}");
    }
    if(this.type == TokenTypes.HOTP && this.counter!=null){
      otpString.write("&counter=${this.counter}");
    }
    return otpString;
  }
  
}
